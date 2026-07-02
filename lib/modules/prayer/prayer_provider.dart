import 'dart:math' as math;

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:uas_projekk/core/notifications/prayer_notification_service.dart';

class PrayerTimes {
  final String fajr;
  final String dhuhr;
  final String asr;
  final String maghrib;
  final String isha;
  final String date;

  PrayerTimes({
    required this.fajr,
    required this.dhuhr,
    required this.asr,
    required this.maghrib,
    required this.isha,
    required this.date,
  });

  factory PrayerTimes.fromJson(Map<String, dynamic> json) {
    final timings = json['timings'];
    return PrayerTimes(
      fajr: timings['Fajr'],
      dhuhr: timings['Dhuhr'],
      asr: timings['Asr'],
      maghrib: timings['Maghrib'],
      isha: timings['Isha'],
      date: json['date']['readable'],
    );
  }
}

class PrayerProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  PrayerTimes? _prayerTimes;
  String _address = 'Mencari lokasi...';
  bool _isLoading = false;
  Position? _currentPosition;
  double _qiblaBearing = 0.0;
  String _locationMessage = '';
  String _city = '';
  String _province = '';
  String _country = '';

  PrayerProvider() {
    _loadSavedData();
  }

  PrayerTimes? get prayerTimes => _prayerTimes;
  String get address => _address;
  bool get isLoading => _isLoading;
  Position? get currentPosition => _currentPosition;
  double get qiblaBearing => _qiblaBearing;
  String get locationMessage => _locationMessage;
  String get city => _city;
  String get province => _province;
  String get country => _country;
  bool get hasLocation => _currentPosition != null;

  Future<void> _loadSavedData() async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final fajr = prefs.getString('cached_fajr');
      final dhuhr = prefs.getString('cached_dhuhr');
      final asr = prefs.getString('cached_asr');
      final maghrib = prefs.getString('cached_maghrib');
      final isha = prefs.getString('cached_isha');
      final date = prefs.getString('cached_date');

      if (fajr != null && dhuhr != null && asr != null && maghrib != null && isha != null && date != null) {
        _prayerTimes = PrayerTimes(
          fajr: fajr,
          dhuhr: dhuhr,
          asr: asr,
          maghrib: maghrib,
          isha: isha,
          date: date,
        );
        _address = prefs.getString('cached_address') ?? 'Lokasi Terakhir Login';
        _city = prefs.getString('cached_city') ?? '';
        _province = prefs.getString('cached_province') ?? '';
        _country = prefs.getString('cached_country') ?? '';
        final lat = prefs.getDouble('cached_latitude');
        final lon = prefs.getDouble('cached_longitude');
        if (lat != null && lon != null) {
          _currentPosition = Position(
            latitude: lat,
            longitude: lon,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
            altitudeAccuracy: 0.0,
            headingAccuracy: 0.0,
          );
          _qiblaBearing = calculateQiblaBearing(lat, lon);
        }
        notifyListeners();

        // Jadwalkan notifikasi latar belakang dan timer di latar depan
        final notifService = PrayerNotificationService();
        notifService.scheduleBackgroundNotifications(_prayerTimes!);
        notifService.startTimer(this);
      }
    } catch (e) {
      debugPrint('Error loading cached prayer times: $e');
    }
  }

  Future<void> fetchPrayerTimes() async {
    _isLoading = true;
    notifyListeners();

    try {
      final position = await _determinePosition();
      _currentPosition = position;
      _qiblaBearing = calculateQiblaBearing(position.latitude, position.longitude);
      _locationMessage = 'Lokasi berhasil didapatkan';
      await _loadLocationDetails(position);

      final date = DateFormat('dd-MM-yyyy').format(DateTime.now());

      final response = await _dio.get(
        'https://api.aladhan.com/v1/timings/$date',
        queryParameters: {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'method': 4,
        },
      );

      if (response.statusCode == 200) {
        _prayerTimes = PrayerTimes.fromJson(response.data['data']);
        _address = 'Lokasi Anda (GPS Aktif)';

        // Simpan ke SharedPreferences
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('cached_fajr', _prayerTimes!.fajr);
        await prefs.setString('cached_dhuhr', _prayerTimes!.dhuhr);
        await prefs.setString('cached_asr', _prayerTimes!.asr);
        await prefs.setString('cached_maghrib', _prayerTimes!.maghrib);
        await prefs.setString('cached_isha', _prayerTimes!.isha);
        await prefs.setString('cached_date', _prayerTimes!.date);
        await prefs.setString('cached_address', _address);
        await prefs.setString('cached_city', _city);
        await prefs.setString('cached_province', _province);
        await prefs.setString('cached_country', _country);
        await prefs.setDouble('cached_latitude', position.latitude);
        await prefs.setDouble('cached_longitude', position.longitude);

        // Schedule background notifications and start foreground timer
        final notifService = PrayerNotificationService();
        notifService.scheduleBackgroundNotifications(_prayerTimes!);
        notifService.startTimer(this);
      }
    } catch (e) {
      debugPrint('Error fetching prayer times: $e');
      _locationMessage = e.toString();

      // Fallback ke cache jika tersedia
      final prefs = await SharedPreferences.getInstance();
      final fajr = prefs.getString('cached_fajr');
      if (fajr != null) {
        _prayerTimes = PrayerTimes(
          fajr: fajr,
          dhuhr: prefs.getString('cached_dhuhr') ?? '',
          asr: prefs.getString('cached_asr') ?? '',
          maghrib: prefs.getString('cached_maghrib') ?? '',
          isha: prefs.getString('cached_isha') ?? '',
          date: prefs.getString('cached_date') ?? '',
        );
        _address = prefs.getString('cached_address') ?? 'Lokasi Terakhir Login';
        if (!_address.contains('(Terakhir Login)')) {
          _address = '$_address (Terakhir Login)';
        }
        _city = prefs.getString('cached_city') ?? '';
        _province = prefs.getString('cached_province') ?? '';
        _country = prefs.getString('cached_country') ?? '';
        final lat = prefs.getDouble('cached_latitude');
        final lon = prefs.getDouble('cached_longitude');
        if (lat != null && lon != null) {
          _currentPosition = Position(
            latitude: lat,
            longitude: lon,
            timestamp: DateTime.now(),
            accuracy: 0.0,
            altitude: 0.0,
            heading: 0.0,
            speed: 0.0,
            speedAccuracy: 0.0,
            altitudeAccuracy: 0.0,
            headingAccuracy: 0.0,
          );
          _qiblaBearing = calculateQiblaBearing(lat, lon);
        }

        final notifService = PrayerNotificationService();
        notifService.scheduleBackgroundNotifications(_prayerTimes!);
        notifService.startTimer(this);
      } else {
        _address = 'Gagal mengambil lokasi';
        _prayerTimes = null;
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> _loadLocationDetails(Position position) async {
    try {
      final placemarks = await placemarkFromCoordinates(
        position.latitude,
        position.longitude,
      );
      if (placemarks.isNotEmpty) {
        final placemark = placemarks.first;
        _city = placemark.locality?.isNotEmpty == true
            ? placemark.locality!
            : placemark.subAdministrativeArea ?? '';
        _province = placemark.administrativeArea ?? '';
        _country = placemark.country ?? '';
      }
    } catch (e) {
      debugPrint('Failed to resolve location details: $e');
      _city = '';
      _province = '';
      _country = '';
    }
    notifyListeners();
  }

  static double calculateQiblaBearing(double latitude, double longitude) {
    const kaabaLat = 21.422487;
    const kaabaLon = 39.826206;

    final lat1 = latitude * math.pi / 180;
    final lat2 = kaabaLat * math.pi / 180;
    final lonDifference = (kaabaLon - longitude) * math.pi / 180;

    final y = math.sin(lonDifference) * math.cos(lat2);
    final x = math.cos(lat1) * math.sin(lat2) -
        math.sin(lat1) * math.cos(lat2) * math.cos(lonDifference);

    final bearing = (math.atan2(y, x) * 180 / math.pi + 360) % 360;
    return bearing;
  }

  Future<Position> _determinePosition() async {
    bool serviceEnabled;
    LocationPermission permission;

    serviceEnabled = await Geolocator.isLocationServiceEnabled();
    if (!serviceEnabled) {
      return Future.error('Location services are disabled.');
    }

    permission = await Geolocator.checkPermission();
    if (permission == LocationPermission.denied) {
      permission = await Geolocator.requestPermission();
      if (permission == LocationPermission.denied) {
        return Future.error('Location permissions are denied');
      }
    }

    if (permission == LocationPermission.deniedForever) {
      return Future.error('Location permissions are permanently denied.');
    }

    return await Geolocator.getCurrentPosition();
  }
}
