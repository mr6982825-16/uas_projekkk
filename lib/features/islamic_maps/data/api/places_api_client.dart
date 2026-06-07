import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/place_model.dart';

class PlacesApiClient {
  final Dio _dio = Dio();
  // Ganti dengan Google Maps API Key Anda! Harus sama dengan yang di AndroidManifest.xml
  static const String _apiKey = "AIzaSyA_Masukkan_Kunci_Asli_Anda_Di_Sini";
  
  final String _baseUrl = "https://maps.googleapis.com/maps/api/place/nearbysearch/json";

  Future<List<PlaceModel>> searchNearby(double lat, double lng, String type, String keyword) async {
    try {
      final response = await _dio.get(
        _baseUrl,
        queryParameters: {
          'location': '\$lat,\$lng',
          'radius': '5000', // 5 KM
          'type': type,
          'keyword': keyword,
          'key': _apiKey,
        }
      );

      if (response.statusCode == 200 && response.data['status'] == 'OK') {
        final List results = response.data['results'];
        return results.map((json) => PlaceModel.fromJson(json)).toList();
      } else {
        debugPrint("Places API Error: \${response.data['status']}");
        if (response.data['status'] == 'REQUEST_DENIED') {
          debugPrint("Pastikan API Key valid dan Google Places API sudah diaktifkan di GCP!");
        }
      }
    } catch (e) {
      debugPrint("Exception fetching places: \$e");
    }
    return [];
  }
}
