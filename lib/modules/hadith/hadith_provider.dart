import 'package:flutter/material.dart';
import 'package:uas_projekk/modules/hadith/hadith_data.dart';

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
      // API may return the translation under different keys depending on mirror/proxy
      contents: json['contents'] ?? json['content'] ?? json['translation'] ?? json['translate'] ?? json['body'] ?? json['text'] ?? json['id'] ?? '',
    );
  }
}

class HadithProvider extends ChangeNotifier {
  List<HadithBook> _books = [];
  List<HadithItem> _hadiths = [];
  bool _isLoading = false;
  String _error = '';

  List<HadithBook> get books => _books;
  List<HadithItem> get hadiths => _hadiths;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchBooks() async {
    if (_books.isNotEmpty && _error.isEmpty) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _books = hadithBooksData.map((json) => HadithBook.fromJson(json)).toList();
      _error = '';
    } catch (e) {
      _books = [];
      _error = 'Gagal memuat daftar hadist.';
      debugPrint('Error loading local hadith books: $e');
    }

    _isLoading = false;
    notifyListeners();
  }

  int _currentStart = 1;
  int _currentEnd = 20;
  bool _isFetchingMore = false;
  bool _hasReachedMax = false;

  bool get isFetchingMore => _isFetchingMore;
  bool get hasReachedMax => _hasReachedMax;

  Future<void> fetchHadiths(String bookId, {bool loadMore = false}) async {
    if (loadMore) {
      if (_isFetchingMore || _hasReachedMax) return;
      _isFetchingMore = true;
      _currentStart += 20;
      _currentEnd += 20;
      notifyListeners();
    } else {
      _isLoading = true;
      _hadiths = [];
      _error = '';
      _currentStart = 1;
      _currentEnd = 20;
      _hasReachedMax = false;
      notifyListeners();
    }

    try {
      final allHadiths = hadithItemsByBook[bookId] ?? [];
      final items = allHadiths
          .map((json) => HadithItem.fromJson(json))
          .skip(_currentStart - 1)
          .take(_currentEnd - _currentStart + 1)
          .toList();

      if (items.isEmpty) {
        _hasReachedMax = true;
      } else {
        if (loadMore) {
          _hadiths.addAll(items);
        } else {
          _hadiths = items;
        }
        _error = '';
      }
    } catch (e) {
      _error = 'Gagal memuat hadits lokal.';
      debugPrint('Error loading local hadiths for $bookId: $e');
    }

    _isLoading = false;
    _isFetchingMore = false;
    notifyListeners();
  }
}
