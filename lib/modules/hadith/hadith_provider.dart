import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HadithProvider with ChangeNotifier {
  final Dio _dio = Dio();
  List<dynamic> _hadiths = [];
  bool _isLoading = false;

  List<dynamic> get hadiths => _hadiths;
  bool get isLoading => _isLoading;

  Future<void> fetchHadiths(String slug) async {
    _hadiths = [];
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get("https://hadis-api-id.vercel.app/hadith/$slug?limit=50");
      if (response.statusCode == 200) {
        // Handle different response formats
        if (response.data['hadiths'] != null) {
          _hadiths = response.data['hadiths'];
        } else if (response.data['items'] != null) {
          _hadiths = response.data['items'];
        } else if (response.data['data'] != null && response.data['data']['hadiths'] != null) {
          _hadiths = response.data['data']['hadiths'];
        }
      }
    } catch (e) {
      debugPrint("Error fetching hadiths: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
