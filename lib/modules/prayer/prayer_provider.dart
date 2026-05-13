import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';

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
  String _address = "Mencari lokasi...";
  bool _isLoading = false;

  PrayerTimes? get prayerTimes => _prayerTimes;
  String get address => _address;
  bool get isLoading => _isLoading;

  Future<void> fetchPrayerTimes() async {
    _isLoading = true;
    notifyListeners();

    try {
      Position position = await _determinePosition();
      final date = DateFormat('dd-MM-yyyy').format(DateTime.now());
      
      final response = await _dio.get(
        "https://api.aladhan.com/v1/timings/$date",
        queryParameters: {
          'latitude': position.latitude,
          'longitude': position.longitude,
          'method': 4, // JAKIM or similar
        },
      );

      if (response.statusCode == 200) {
        _prayerTimes = PrayerTimes.fromJson(response.data['data']);
        _address = "Lokasi Anda (GPS Aktif)";
      }
    } catch (e) {
      debugPrint("Error fetching prayer times: $e");
      _address = "Gagal mengambil lokasi";
    } finally {
      _isLoading = false;
      notifyListeners();
    }
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
