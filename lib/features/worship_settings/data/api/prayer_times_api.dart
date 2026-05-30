import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/prayer_schedule_model.dart';

class PrayerTimesApi {
  final Dio _dio = Dio();

  /// Mengambil jadwal shalat hari ini berdasarkan nama kota dan negara
  Future<PrayerSchedule?> getTimingsByCity(String city, String country) async {
    try {
      final response = await _dio.get(
        'http://api.aladhan.com/v1/timingsByCity',
        queryParameters: {
          'city': city,
          'country': country,
          'method': 2, // 2 = Islamic Society of North America (ISNA) - bisa disesuaikan
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return PrayerSchedule.fromJson(response.data);
      }
    } catch (e) {
      debugPrint("Error fetching prayer times: \$e");
    }
    return null;
  }
}
