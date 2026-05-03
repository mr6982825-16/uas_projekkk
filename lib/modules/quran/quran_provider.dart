import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uas_projekk/core/constants.dart';

class QuranProvider with ChangeNotifier {
  final Dio _dio = Dio();
  List<dynamic> _surahs = [];
  bool _isLoading = false;

  List<dynamic> get surahs => _surahs;
  bool get isLoading => _isLoading;

  Future<void> fetchSurahs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get("${AppConstants.quranBaseUrl}/surah");
      if (response.statusCode == 200) {
        _surahs = response.data['data'];
      }
    } catch (e) {
      debugPrint("Error fetching surahs: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<List<dynamic>?> fetchSurahDetail(int number) async {
    try {
      final response = await _dio.get("${AppConstants.quranBaseUrl}/surah/$number/editions/quran-uthmani,id.indonesian");
      if (response.statusCode == 200) {
        return response.data['data'] as List<dynamic>;
      }
    } catch (e) {
      debugPrint("Error fetching surah detail: $e");
    }
    return null;
  }
}
