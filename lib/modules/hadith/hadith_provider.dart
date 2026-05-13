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
  final String contents;

  HadithItem({required this.number, required this.contents});

  factory HadithItem.fromJson(Map<String, dynamic> json) {
    return HadithItem(
      number: json['number'],
      contents: json['id'], // Indonesian translation is in 'id' field for this API
    );
  }
}

class HadithProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  List<HadithBook> _books = [];
  List<HadithItem> _hadiths = [];
  bool _isLoading = false;

  List<HadithBook> get books => _books;
  List<HadithItem> get hadiths => _hadiths;
  bool get isLoading => _isLoading;

  Future<void> fetchBooks() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get("https://api.hadith.gading.dev/books");
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        _books = data.map((json) => HadithBook.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching hadith books: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchHadiths(String bookId, {int range = 50}) async {
    _isLoading = true;
    _hadiths = [];
    notifyListeners();

    try {
      final response = await _dio.get("https://api.hadith.gading.dev/books/$bookId?range=1-$range");
      if (response.statusCode == 200) {
        final List data = response.data['data']['hadiths'];
        _hadiths = data.map((json) => HadithItem.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching hadiths: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
