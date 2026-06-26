import 'dart:async';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_projekk/modules/prayer/prayer_provider.dart';
import 'notification_helper.dart';

class PrayerNotificationService extends ChangeNotifier {
  static final PrayerNotificationService _instance = PrayerNotificationService._internal();
  factory PrayerNotificationService() => _instance;
  PrayerNotificationService._internal();

  final AudioPlayer _audioPlayer = AudioPlayer();
  final NotificationHelper _notificationHelper = NotificationHelper();
  
  Timer? _timer;
  bool _isPlayingAdhan = false;
  String _playingPrayerName = '';
  String _lastPlayedKey = ''; // format: 'day-prayerName' (e.g., '26-Maghrib')

  bool get isPlayingAdhan => _isPlayingAdhan;
  String get playingPrayerName => _playingPrayerName;

  static const Map<String, String> adhanSounds = {
    'makkah': 'https://www.islamcan.com/audio/adhan/azan1.mp3',
    'madinah': 'https://www.islamcan.com/audio/adhan/azan2.mp3',
    'alaqsa': 'https://www.islamcan.com/audio/adhan/azan5.mp3',
    'egypt': 'https://www.islamcan.com/audio/adhan/azan6.mp3',
    'turkey': 'https://www.islamcan.com/audio/adhan/azan7.mp3',
    'yusuf_islam': 'https://www.islamcan.com/audio/adhan/azan3.mp3',
  };

  Future<void> init() async {
    await _notificationHelper.init();
    
    _audioPlayer.onPlayerStateChanged.listen((state) {
      if (state == PlayerState.completed || state == PlayerState.stopped) {
        _isPlayingAdhan = false;
        _playingPrayerName = '';
        notifyListeners();
      }
    });
  }

  void startTimer(PrayerProvider prayerProvider) {
    _timer?.cancel();
    // Check every 30 seconds for accuracy
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      _checkPrayerTimes(prayerProvider);
    });
  }

  void stopTimer() {
    _timer?.cancel();
  }

  Future<void> playAdhan(String prayerName) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final soundId = prefs.getString('selectedAdhanSoundId') ?? 'makkah';
      final isEnabled = prefs.getBool('isAdhanNotifEnabled') ?? true;

      if (!isEnabled) return;

      final rawUrl = adhanSounds[soundId] ?? adhanSounds['makkah']!;
      // Use CORS proxy for Web to avoid audio loading issues
      final playUrl = kIsWeb ? 'https://corsproxy.io/?$rawUrl' : rawUrl;

      await _audioPlayer.stop();
      _isPlayingAdhan = true;
      _playingPrayerName = prayerName;
      notifyListeners();

      await _audioPlayer.play(UrlSource(playUrl));
      
      // Also trigger a system notification immediately
      await _notificationHelper.showInstantNotification(
        'Waktu Shalat $prayerName',
        'Sudah memasuki waktu shalat $prayerName. Mari laksanakan ibadah shalat.',
      );
    } catch (e) {
      print('Failed to play adhan audio: $e');
      _isPlayingAdhan = false;
      _playingPrayerName = '';
      notifyListeners();
    }
  }

  Future<void> stopAdhan() async {
    await _audioPlayer.stop();
    _isPlayingAdhan = false;
    _playingPrayerName = '';
    notifyListeners();
  }

  PrayerTimes? _lastPrayerTimes;

  Future<void> scheduleBackgroundNotifications(PrayerTimes times) async {
    _lastPrayerTimes = times;
    final prefs = await SharedPreferences.getInstance();
    final isEnabled = prefs.getBool('isAdhanNotifEnabled') ?? true;

    // First, clear all previous scheduled alarms
    await _notificationHelper.cancelAllNotifications();

    if (!isEnabled) return;

    final Map<int, MapEntry<String, String>> prayerTimesMap = {
      1: MapEntry('Subuh', times.fajr),
      2: MapEntry('Dzuhur', times.dhuhr),
      3: MapEntry('Ashar', times.asr),
      4: MapEntry('Maghrib', times.maghrib),
      5: MapEntry('Isya', times.isha),
    };

    final now = DateTime.now();

    for (var entry in prayerTimesMap.entries) {
      final id = entry.key;
      final name = entry.value.key;
      final timeStr = entry.value.value;

      try {
        final scheduledTime = _parsePrayerTime(timeStr);
        if (scheduledTime.isAfter(now)) {
          await _notificationHelper.schedulePrayerNotification(
            id: id,
            title: 'Waktu Shalat $name',
            body: 'Sudah memasuki waktu shalat $name. Mari laksanakan ibadah shalat.',
            scheduledTime: scheduledTime,
          );
        }
      } catch (e) {
        print('Error scheduling notification for $name: $e');
      }
    }
  }

  Future<void> reschedule() async {
    if (_lastPrayerTimes != null) {
      await scheduleBackgroundNotifications(_lastPrayerTimes!);
    }
  }

  DateTime _parsePrayerTime(String timeStr) {
    // Clean string from any timezone abbreviations (e.g., "12:00 (WIB)")
    final cleanTime = timeStr.split(' ')[0].replaceAll(RegExp(r'[^0-9:]'), '');
    final parts = cleanTime.split(':');
    final hour = int.parse(parts[0]);
    final minute = int.parse(parts[1]);
    final now = DateTime.now();
    return DateTime(now.year, now.month, now.day, hour, minute);
  }

  void _checkPrayerTimes(PrayerProvider provider) {
    if (provider.prayerTimes == null) return;
    
    final times = provider.prayerTimes!;
    final now = DateTime.now();
    final todayDay = now.day;

    final Map<String, String> currentPrayers = {
      'Subuh': times.fajr,
      'Dzuhur': times.dhuhr,
      'Ashar': times.asr,
      'Maghrib': times.maghrib,
      'Isya': times.isha,
    };

    for (var entry in currentPrayers.entries) {
      final name = entry.key;
      final timeStr = entry.value;

      try {
        final prayerTime = _parsePrayerTime(timeStr);
        // Check if current hour and minute match the prayer time
        if (now.hour == prayerTime.hour && now.minute == prayerTime.minute) {
          final playKey = '$todayDay-$name';
          if (_lastPlayedKey != playKey) {
            _lastPlayedKey = playKey;
            playAdhan(name);
          }
        }
      } catch (e) {
        print('Error checking prayer time $name: $e');
      }
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }
}
