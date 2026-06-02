import 'package:flutter/material.dart';
import '../data/datasources/doa_data_source.dart';
import '../data/models/doa_model.dart';

class PilarIslamProvider extends ChangeNotifier {
  final List<DoaModel> _allDoa = PilarIslamDataSource.allDoa;
  final Map<String, List<DoaModel>> _categoryCache = {};

  String _selectedCategory = PilarIslamDataSource.categories.first;
  String _searchQuery = '';

  String get selectedCategory => _selectedCategory;
  List<String> get categories => PilarIslamDataSource.categories;
  String get searchQuery => _searchQuery;

  List<DoaModel> get filteredDoa {
    final base = _categoryCache.putIfAbsent(
      _selectedCategory,
      () => PilarIslamDataSource.getDoaByCategory(_selectedCategory),
    );

    if (_searchQuery.isEmpty) return base;

    final query = _searchQuery.toLowerCase();
    return base.where((doa) {
      return doa.title.toLowerCase().contains(query) ||
          doa.arabicText.toLowerCase().contains(query) ||
          doa.translation.toLowerCase().contains(query);
    }).toList();
  }

  bool get hasDataForSelectedCategory {
    return PilarIslamDataSource.getDoaByCategory(_selectedCategory).isNotEmpty;
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

  DoaModel? get firstDoaInCategory {
    final list = filteredDoa;
    return list.isNotEmpty ? list.first : null;
  }
}
