import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'dart:convert';

class HadithProvider with ChangeNotifier {
  final Dio _dio = Dio();
  List<dynamic> _hadiths = [];
  bool _isLoading = false;
  bool _isMoreLoading = false;
  int _currentPage = 1;
  int _lastPage = 1;

  List<dynamic> get hadiths => _hadiths;
  bool get isLoading => _isLoading;
  bool get isMoreLoading => _isMoreLoading;
  bool get hasMore => _currentPage < _lastPage;

  String _getProxiedUrl(String url) {
    if (kIsWeb) {
      // Using corsproxy.io as an alternative
      return "https://corsproxy.io/?${Uri.encodeComponent(url)}";
    }
    return url;
  }

  Future<void> fetchHadiths(String slug) async {
    _hadiths = [];
    _isLoading = true;
    _currentPage = 1;
    notifyListeners();

    try {
      if (slug == 'shahih-bukhari') {
        final url = _getProxiedUrl("https://hadits.nu.or.id/api/hadith/shahih-bukhari?page=1&per_page=20");
        final response = await _dio.get(url);
        
        var data = response.data;
        if (data is String) data = jsonDecode(data); // Handle cases where proxy returns raw string

        if (response.statusCode == 200) {
          _hadiths = data['data'];
          _currentPage = data['meta']['currentPage'];
          _lastPage = data['meta']['lastPage'];
        }
      } else {
        final url = _getProxiedUrl("https://hadis-api-id.vercel.app/hadith/$slug?limit=50");
        final response = await _dio.get(url);
        
        var data = response.data;
        if (data is String) data = jsonDecode(data);

        if (response.statusCode == 200) {
          if (data['hadiths'] != null) {
            _hadiths = data['hadiths'];
          } else if (data['items'] != null) {
            _hadiths = data['items'];
          } else if (data['data'] != null && data['data']['hadiths'] != null) {
            _hadiths = data['data']['hadiths'];
          }
          _lastPage = 1;
        }
      }
    } catch (e) {
      debugPrint("Error fetching hadiths: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchMoreHadiths(String slug) async {
    if (_isMoreLoading || !hasMore || slug != 'shahih-bukhari') return;

    _isMoreLoading = true;
    notifyListeners();

    try {
      final nextPage = _currentPage + 1;
      final url = _getProxiedUrl("https://hadits.nu.or.id/api/hadith/shahih-bukhari?page=$nextPage&per_page=20");
      final response = await _dio.get(url);

      var data = response.data;
      if (data is String) data = jsonDecode(data);

      if (response.statusCode == 200) {
        final newHadiths = data['data'];
        _hadiths.addAll(newHadiths);
        _currentPage = data['meta']['currentPage'];
        _lastPage = data['meta']['lastPage'];
      }
    } catch (e) {
      debugPrint("Error fetching more hadiths: $e");
    } finally {
      _isMoreLoading = false;
      notifyListeners();
    }
  }
}
