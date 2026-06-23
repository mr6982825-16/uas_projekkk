import 'package:flutter/material.dart';
import 'package:uas_projekk/modules/hadith/hadith_data.dart';
import 'package:hive_flutter/hive_flutter.dart';

class HadithBook {
  final String name;
  final String id;
  final int available;

  HadithBook({
    required this.name,
    required this.id,
    required this.available,
  });

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
      contents: json['contents'] ?? json['id'] ?? '',
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'number': number,
      'arab': arab,
      'id': contents,
    };
  }
}

class FavoriteHadithItem {
  final String bookId;
  final String bookName;
  final int number;
  final String arab;
  final String contents;

  FavoriteHadithItem({
    required this.bookId,
    required this.bookName,
    required this.number,
    required this.arab,
    required this.contents,
  });

  Map<String, dynamic> toJson() {
    return {
      'bookId': bookId,
      'bookName': bookName,
      'number': number,
      'arab': arab,
      'contents': contents,
    };
  }

  factory FavoriteHadithItem.fromJson(Map<dynamic, dynamic> json) {
    return FavoriteHadithItem(
      bookId: json['bookId'] ?? '',
      bookName: json['bookName'] ?? '',
      number: json['number'] ?? 0,
      arab: json['arab'] ?? '',
      contents: json['contents'] ?? '',
    );
  }
}

class HadithProvider extends ChangeNotifier {
  final String _favBoxName = 'favorite_hadiths';

  List<HadithBook> _books = [];
  List<HadithItem> _hadiths = [];
  List<FavoriteHadithItem> _favorites = [];
  
  bool _isLoading = false;
  String _error = '';

  List<HadithBook> get books => _books;
  List<HadithItem> get hadiths => _hadiths;
  List<FavoriteHadithItem> get favorites => _favorites;
  bool get isLoading => _isLoading;
  String get error => _error;

  // Pagination states
  int _currentPage = 1;
  bool _isFetchingMore = false;
  bool _hasReachedMax = false;

  int get currentPage => _currentPage;
  bool get isFetchingMore => _isFetchingMore;
  bool get hasReachedMax => _hasReachedMax;

  // Single search/jump state
  HadithItem? _searchedHadith;
  bool _isSearchingSingle = false;
  String _searchError = '';

  HadithItem? get searchedHadith => _searchedHadith;
  bool get isSearchingSingle => _isSearchingSingle;
  String get searchError => _searchError;

  void clearSearchedHadith() {
    _searchedHadith = null;
    _searchError = '';
    notifyListeners();
  }

  // Fetch all books (offline)
  Future<void> fetchBooks() async {
    if (_books.isNotEmpty) return;

    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      _books = hadithBooksData.map((json) => HadithBook.fromJson(json)).toList();
      _error = '';
    } catch (e) {
      _error = 'Gagal memuat daftar kitab.';
      debugPrint('Error loading offline hadith books: $e');
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch hadiths with pagination (offline)
  Future<void> fetchHadiths(String bookId, {bool loadMore = false}) async {
    if (loadMore) {
      if (_isFetchingMore || _hasReachedMax) return;
      _isFetchingMore = true;
      notifyListeners();
    } else {
      _isLoading = true;
      _hadiths = [];
      _error = '';
      _currentPage = 1;
      _hasReachedMax = false;
      _searchedHadith = null;
      _searchError = '';
      notifyListeners();
    }

    try {
      // Local offline hadith pagination
      final allHadiths = hadithItemsByBook[bookId] ?? [];
      final pageSize = 20;
      final startIndex = loadMore ? _currentPage * pageSize : 0;

      final items = allHadiths
          .map((json) => HadithItem.fromJson(Map<String, dynamic>.from(json)))
          .skip(startIndex)
          .take(pageSize)
          .toList();

      if (items.isEmpty) {
        _hasReachedMax = true;
      } else {
        if (loadMore) {
          _hadiths.addAll(items);
          _currentPage = _currentPage + 1;
        } else {
          _hadiths = items;
        }
        _error = '';
      }
    } catch (e) {
      _error = 'Gagal memuat hadits.';
      debugPrint('Error loading hadiths for $bookId: $e');
    } finally {
      _isLoading = false;
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  // Fetch a single Hadith by its number (offline)
  Future<void> fetchSingleHadith(String bookId, int number) async {
    _isSearchingSingle = true;
    _searchedHadith = null;
    _searchError = '';
    notifyListeners();

    try {
      final allHadiths = hadithItemsByBook[bookId] ?? [];
      final found = allHadiths.firstWhere(
        (h) => (h['number'] as int) == number,
        orElse: () => {},
      );

      if (found.isNotEmpty) {
        _searchedHadith = HadithItem.fromJson(Map<String, dynamic>.from(found));
        _searchError = '';
      } else {
        _searchError = 'Hadist nomor $number tidak ditemukan.';
      }
    } catch (e) {
      _searchError = 'Hadist nomor $number tidak ditemukan atau terjadi kesalahan.';
      debugPrint('Error fetching single hadith: $e');
    } finally {
      _isSearchingSingle = false;
      notifyListeners();
    }
  }

  // Favorite Management using Hive
  Future<void> initFavorites() async {
    try {
      if (!Hive.isBoxOpen(_favBoxName)) {
        await Hive.openBox(_favBoxName);
      }
      final box = Hive.box(_favBoxName);
      _favorites = box.values
          .map((e) => FavoriteHadithItem.fromJson(Map<dynamic, dynamic>.from(e)))
          .toList();
      notifyListeners();
    } catch (e) {
      debugPrint('Error loading favorites box: $e');
    }
  }

  bool isFavorite(String bookId, int number) {
    return _favorites.any((fav) => fav.bookId == bookId && fav.number == number);
  }

  Future<void> toggleFavorite(String bookId, String bookName, HadithItem item) async {
    try {
      if (!Hive.isBoxOpen(_favBoxName)) {
        await Hive.openBox(_favBoxName);
      }
      final box = Hive.box(_favBoxName);
      final index = _favorites.indexWhere((fav) => fav.bookId == bookId && fav.number == item.number);
      
      if (index >= 0) {
        // Remove
        final key = box.keys.elementAt(index);
        await box.delete(key);
        _favorites.removeAt(index);
      } else {
        // Add
        final fav = FavoriteHadithItem(
          bookId: bookId,
          bookName: bookName,
          number: item.number,
          arab: item.arab,
          contents: item.contents,
        );
        await box.add(fav.toJson());
        _favorites.add(fav);
      }
      notifyListeners();
    } catch (e) {
      debugPrint('Error toggling favorite: $e');
    }
  }
}
