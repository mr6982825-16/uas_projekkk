import 'package:flutter/material.dart';
import 'package:uas_projekk/modules/hadith/hadith_data.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:dio/dio.dart';

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
  final Dio _dio = Dio();

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

  // Fetch all books (online, fallback to offline)
  Future<void> fetchBooks() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      // 1. Initialize with local data first so the UI doesn't remain blank
      final localBooks = hadithBooksData.map((json) => HadithBook.fromJson(json)).toList();
      _books = localBooks;

      // 2. Try fetching from online API to update totals
      final response = await _dio.get('https://hadis-api-id.vercel.app/hadith').timeout(const Duration(seconds: 8));
      if (response.statusCode == 200) {
        final List<dynamic> data = response.data;
        final onlineBooks = data.map((json) {
          final slug = json['slug'] ?? '';
          final name = json['name'] ?? '';
          final total = int.tryParse(json['total'].toString()) ?? 0;
          return HadithBook(
            id: slug,
            name: name,
            available: total,
          );
        }).toList();

        // Merge: keep local ones not in online data (e.g. arbain-nawawi, riyadush-shalihin)
        final mergedBooks = <HadithBook>[];
        for (var local in localBooks) {
          final online = onlineBooks.firstWhere(
            (o) => o.id == local.id,
            orElse: () => HadithBook(id: '', name: '', available: 0),
          );
          if (online.id.isNotEmpty) {
            mergedBooks.add(online);
          } else {
            mergedBooks.add(local);
          }
        }
        _books = mergedBooks;
      }
      _error = '';
    } catch (e) {
      debugPrint('Error loading online books, using cached/offline data: $e');
      if (_books.isEmpty) {
        _books = hadithBooksData.map((json) => HadithBook.fromJson(json)).toList();
      }
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // Fetch hadiths with pagination (online, fallback to offline)
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

    final localOnly = bookId == 'arbain-nawawi' || bookId == 'riyadush-shalihin';

    if (localOnly) {
      try {
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
            _currentPage = 2;
          }
          _error = '';
        }
      } catch (e) {
        _error = 'Gagal memuat hadits.';
        debugPrint('Error loading offline hadiths for $bookId: $e');
      } finally {
        _isLoading = false;
        _isFetchingMore = false;
        notifyListeners();
      }
      return;
    }

    try {
      final limit = 20;
      final page = _currentPage;
      final url = 'https://hadis-api-id.vercel.app/hadith/$bookId?page=$page&limit=$limit';
      
      final response = await _dio.get(url).timeout(const Duration(seconds: 10));
      if (response.statusCode == 200) {
        final data = response.data;
        final List<dynamic> itemsJson = data['items'] ?? [];
        
        final items = itemsJson.map((json) => HadithItem.fromJson(Map<String, dynamic>.from(json))).toList();
        
        if (items.isEmpty) {
          _hasReachedMax = true;
        } else {
          if (loadMore) {
            _hadiths.addAll(items);
            _currentPage = _currentPage + 1;
          } else {
            _hadiths = items;
            _currentPage = 2;
          }
          _error = '';
        }
      } else {
        throw Exception('API returned status code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error loading online hadiths for $bookId, falling back to local: $e');
      // FALLBACK TO OFFLINE
      try {
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
            _currentPage = 2;
          }
          _error = '';
        }
      } catch (err) {
        _error = 'Gagal memuat hadits.';
        debugPrint('Error in fallback: $err');
      }
    } finally {
      _isLoading = false;
      _isFetchingMore = false;
      notifyListeners();
    }
  }

  // Fetch a single Hadith by its number (online, fallback to offline)
  Future<void> fetchSingleHadith(String bookId, int number) async {
    _isSearchingSingle = true;
    _searchedHadith = null;
    _searchError = '';
    notifyListeners();

    final localOnly = bookId == 'arbain-nawawi' || bookId == 'riyadush-shalihin';

    if (localOnly) {
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
        debugPrint('Error fetching single hadith offline: $e');
      } finally {
        _isSearchingSingle = false;
        notifyListeners();
      }
      return;
    }

    try {
      final url = 'https://hadis-api-id.vercel.app/hadith/$bookId/$number';
      final response = await _dio.get(url).timeout(const Duration(seconds: 8));
      
      if (response.statusCode == 200) {
        final data = response.data;
        _searchedHadith = HadithItem.fromJson(Map<String, dynamic>.from(data));
        _searchError = '';
      } else {
        throw Exception('API returned status code ${response.statusCode}');
      }
    } catch (e) {
      debugPrint('Error fetching single hadith online: $e, falling back to local');
      // FALLBACK TO OFFLINE
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
      } catch (err) {
        _searchError = 'Hadist nomor $number tidak ditemukan atau terjadi kesalahan.';
        debugPrint('Error in fallback: $err');
      }
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
