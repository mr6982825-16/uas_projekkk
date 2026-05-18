import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HadithBook {
  final String name;
  final String id;
  final int available;

  HadithBook({required this.name, required this.id, required this.available});

  factory HadithBook.fromJson(Map<String, dynamic> json) {
    return HadithBook(
      name: json['name'] ?? '',
      id: json['id'] ?? '',
      available: int.tryParse(json['available'].toString()) ?? 0,
    );
  }
}

class HadithItem {
  final int number;
  final String arab;
  final String contents;

  HadithItem({required this.number, required this.arab, required this.contents});

  factory HadithItem.fromJson(Map<String, dynamic> json) {
    return HadithItem(
      number: int.tryParse(json['number'].toString()) ?? 0,
      arab: json['arab'] ?? '',
      contents: json['id'] ?? '', 
    );
  }
}

class HadithProvider extends ChangeNotifier {
  final Dio _dio = Dio(BaseOptions(
    connectTimeout: const Duration(seconds: 15),
    receiveTimeout: const Duration(seconds: 15),
  ));
  
  List<HadithBook> _books = [];
  List<HadithItem> _hadiths = [];
  bool _isLoading = false;
  String _error = '';

  List<HadithBook> get books => _books;
  List<HadithItem> get hadiths => _hadiths;
  bool get isLoading => _isLoading;
  String get error => _error;

  final List<String> _mirrors = [
    "https://api.hadith.gading.dev",
    "https://hadith-api-ghazihan.vercel.app", 
    "https://corsproxy.io/?https://api.hadith.gading.dev", // Fallback CORS proxy for Flutter Web
  ];

  Future<void> fetchBooks() async {
    if (_books.isNotEmpty && _error.isEmpty) return;
    
    _isLoading = true;
    _error = '';
    notifyListeners();

    for (String baseUrl in _mirrors) {
      try {
        final response = await _dio.get("$baseUrl/books");
        if (response.statusCode == 200) {
          var responseData = response.data;
          
          // Fix for Proxy returning String instead of JSON
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }

          final List data = responseData['data'];
          _books = data.map((json) => HadithBook.fromJson(json)).toList();
          _error = '';
          break; // Success
        }
      } catch (e) {
        _error = "Error: $e";
        debugPrint("Error fetching books from $baseUrl: $e");
      }
    }

    if (_books.isEmpty && _error.isNotEmpty && !_error.contains("Timeout")) {
      _error = "Gagal menghubungkan ke server hadits. Periksa koneksi internet Anda.";
    }
    
    _isLoading = false;
    notifyListeners();
  }

  Future<void> fetchHadiths(String bookId, {int range = 20}) async {
    _isLoading = true;
    _hadiths = [];
    _error = '';
    notifyListeners();

    bool success = false;
    for (String baseUrl in _mirrors) {
      try {
        final response = await _dio.get("$baseUrl/books/$bookId?range=1-$range");
        if (response.statusCode == 200) {
          var responseData = response.data;
          
          // Fix for Proxy returning String instead of JSON
          if (responseData is String) {
            responseData = jsonDecode(responseData);
          }

          final List data = responseData['data']['hadiths'];
          _hadiths = data.map((json) => HadithItem.fromJson(json)).toList();
          success = true;
          _error = '';
          break;
        }
      } catch (e) {
        _error = "Error: $e";
        debugPrint("Error fetching hadiths from $baseUrl: $e");
      }
    }

    if (!success) {
      _error = "Gagal memuat hadits. Pastikan koneksi internet stabil.";
    }

    _isLoading = false;
    notifyListeners();
  }
}
