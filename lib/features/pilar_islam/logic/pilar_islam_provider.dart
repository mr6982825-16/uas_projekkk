import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../data/models/doa_model.dart';
import '../data/datasources/doa_data_source.dart';

class PilarIslamProvider extends ChangeNotifier {
  List<DoaModel> _allDoa = [];
  bool _isLoading = true;
  String _error = '';

  String _selectedCategory = 'Pagi';
  String _searchQuery = '';
  final Map<String, int> _counts = {};

  PilarIslamProvider() {
    autoSelectCategoryBasedOnTime();
    loadDoaData();
  }

  List<DoaModel> get allDoa => _allDoa;
  bool get isLoading => _isLoading;
  String get error => _error;
  String get selectedCategory => _selectedCategory;
  String get searchQuery => _searchQuery;

  List<String> get categories => [
        'Pagi',
        'Malam',
        'Shalat',
        'Perjalanan',
        'Fajar',
        'Siang',
        'Sore',
      ];

  Future<void> loadDoaData() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final jsonString = await rootBundle.loadString('assets/data/doa.json');
      final List<dynamic> jsonList = jsonDecode(jsonString);
      _allDoa = jsonList.map((json) => DoaModel.fromJson(json)).toList();
      _error = '';
    } catch (e) {
      _error = 'Gagal memuat data doa.';
      debugPrint('Error loading Doa JSON: $e. Falling back to local datasource.');
      // Fallback to local datasource
      _allDoa = PilarIslamDataSource.allDoa;
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<DoaModel> get filteredDoa {
    final base = _allDoa.where((d) => d.category == _selectedCategory).toList();

    if (_searchQuery.isEmpty) return base;

    final query = _searchQuery.toLowerCase();
    return base.where((doa) {
      return doa.title.toLowerCase().contains(query) ||
          doa.arabicText.toLowerCase().contains(query) ||
          doa.translation.toLowerCase().contains(query) ||
          doa.transliteration.toLowerCase().contains(query);
    }).toList();
  }

  void selectCategory(String category) {
    if (_selectedCategory == category) return;
    _selectedCategory = category;
    _searchQuery = '';
    notifyListeners();
  }

  void setSearchQuery(String query) {
    _searchQuery = query;
    notifyListeners();
  }

  // Auto Select Category based on current device time
  void autoSelectCategoryBasedOnTime() {
    final hour = DateTime.now().hour;
    if (hour >= 4 && hour < 6) {
      _selectedCategory = 'Fajar';
    } else if (hour >= 6 && hour < 11) {
      _selectedCategory = 'Pagi';
    } else if (hour >= 11 && hour < 15) {
      _selectedCategory = 'Siang';
    } else if (hour >= 15 && hour < 18) {
      _selectedCategory = 'Sore';
    } else {
      _selectedCategory = 'Malam';
    }
    notifyListeners();
  }

  // Counter logic
  int getCount(String id) {
    return _counts[id] ?? 0;
  }

  void incrementCount(String id, int target) {
    final current = getCount(id);
    if (current < target) {
      _counts[id] = current + 1;
      notifyListeners();
    }
  }

  void resetCount(String id) {
    _counts[id] = 0;
    notifyListeners();
  }

  void resetAllCountsInCategory(String category) {
    final categoryDoas = _allDoa.where((d) => d.category == category);
    for (var d in categoryDoas) {
      _counts[d.id] = 0;
    }
    notifyListeners();
  }
}
