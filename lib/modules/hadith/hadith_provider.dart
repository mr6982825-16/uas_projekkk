import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class HadithBook {
  final String name;
  final String id;
  final int available;

  HadithBook({required this.name, required this.id, required this.available});

  factory HadithBook.fromJson(Map<String, dynamic> json) {
    return HadithBook(
      name: json['name'],
      id: json['id'],
      available: json['available'],
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
      number: json['number'],
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
    "https://hadith-api-ghazihan.vercel.app", // Fallback mirror
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
          final List data = response.data['data'];
          _books = data.map((json) => HadithBook.fromJson(json)).toList();
          _error = '';
          break; // Success
        }
      } catch (e) {
        _error = "Gagal memuat daftar buku (Mirror: $baseUrl). Menghubungi mirror lain...";
        debugPrint("Error fetching books from $baseUrl: $e");
      }
    }

    if (_books.isEmpty && _error.isNotEmpty) {
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
          final List data = response.data['data']['hadiths'];
          _hadiths = data.map((json) => HadithItem.fromJson(json)).toList();
          success = true;
          _error = '';
          break;
        }
      } catch (e) {
        _error = "Gagal memuat hadits (Mirror: $baseUrl).";
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
