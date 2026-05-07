import 'dart:async';
import 'package:adhan/adhan.dart';
import 'package:audioplayers/audioplayers.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';

class PrayerProvider with ChangeNotifier {
  PrayerTimes? _prayerTimes;
  String _locationName = "Detecting...";
  bool _isLoading = false;
  bool _isMuted = false;
  final AudioPlayer _audioPlayer = AudioPlayer();
  Timer? _timer;
  String? _lastPlayedMinute;

  PrayerTimes? get prayerTimes => _prayerTimes;
  String get locationName => _locationName;
  bool get isLoading => _isLoading;
  bool get isMuted => _isMuted;

  PrayerProvider() {
    _loadMuteStatus();
    _startMonitoring();
  }

  Future<void> _loadMuteStatus() async {
    final prefs = await SharedPreferences.getInstance();
    _isMuted = prefs.getBool('isMuted') ?? false;
    notifyListeners();
  }

  Future<void> toggleMute() async {
    _isMuted = !_isMuted;
    final prefs = await SharedPreferences.getInstance();
    await prefs.setBool('isMuted', _isMuted);
    if (_isMuted) {
      _audioPlayer.stop();
    }
    notifyListeners();
  }

  void _startMonitoring() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _checkAdzan();
    });
  }

  void _checkAdzan() {
    if (_prayerTimes == null || _isMuted) return;

    final now = DateTime.now();
    final currentMinute = DateFormat('HH:mm').format(now);

    // List of prayer times to check
    final prayers = {
      "Fajr": _prayerTimes!.fajr,
      "Dhuhr": _prayerTimes!.dhuhr,
      "Asr": _prayerTimes!.asr,
      "Maghrib": _prayerTimes!.maghrib,
      "Isha": _prayerTimes!.isha,
    };

    prayers.forEach((name, time) {
      final prayerMinute = DateFormat('HH:mm').format(time.toLocal());
      if (currentMinute == prayerMinute && _lastPlayedMinute != currentMinute) {
        _playAdzan();
        _lastPlayedMinute = currentMinute;
      }
    });
  }

  Future<void> _playAdzan() async {
    try {
      await _audioPlayer.play(AssetSource('audio/adzan.mp3'));
    } catch (e) {
      debugPrint("Error playing adzan: $e");
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _audioPlayer.dispose();
    super.dispose();
  }

  String get nextPrayerName {
    if (_prayerTimes == null) return "...";
    final next = _prayerTimes!.nextPrayer();
    if (next == Prayer.none) return "Fajr (Tomorrow)";
    return next.name.toUpperCase();
  }

  DateTime? get nextPrayerTime {
    if (_prayerTimes == null) return null;
    final next = _prayerTimes!.nextPrayer();
    if (next == Prayer.none) return _prayerTimes!.fajr;
    return _prayerTimes!.timeForPrayer(next);
  }

  Future<void> fetchPrayerTimes() async {
    _isLoading = true;
    notifyListeners();

    try {
      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();
      if (!serviceEnabled) {
        _locationName = "Location Disabled";
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();
      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
        if (permission == LocationPermission.denied) {
          _locationName = "Permission Denied";
          return;
        }
      }

      Position? position;
      try {
        position = await Geolocator.getCurrentPosition(
          desiredAccuracy: LocationAccuracy.low,
          timeLimit: const Duration(seconds: 5),
        );
      } catch (e) {
        debugPrint("Location timeout or error, using fallback: $e");
      }

      // Default to Jakarta if position is null
      final lat = position?.latitude ?? -6.2088;
      final lon = position?.longitude ?? 106.8456;
      final coordinates = Coordinates(lat, lon);
      
      final params = CalculationMethod.muslim_world_league.getParameters();
      params.madhab = Madhab.shafi;
      
      _prayerTimes = PrayerTimes.today(coordinates, params);
      _locationName = position != null ? "Current Location" : "Jakarta (Default)";
    } catch (e) {
      debugPrint("Error calculating prayer times: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  String formatTime(DateTime time) {
    return DateFormat.Hm().format(time.toLocal());
  }
}
