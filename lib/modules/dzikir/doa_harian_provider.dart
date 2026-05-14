import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:uas_projekk/modules/dzikir/doa_harian_model.dart';

class DoaHarianProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  List<DoaHarian> _allDoa = [];
  List<DoaHarian> _filteredDoa = [];
  bool _isLoading = false;
  String _error = '';

  List<DoaHarian> get allDoa => _filteredDoa.isEmpty && _allDoa.isNotEmpty ? _allDoa : _filteredDoa;
  bool get isLoading => _isLoading;
  String get error => _error;

  Future<void> fetchAllDoa() async {
    _isLoading = true;
    _error = '';
    notifyListeners();

    try {
      final response = await _dio.get('https://api.myquran.com/v2/doa/semua');
      
      if (response.statusCode == 200) {
        final data = response.data['data'] as List;
        _allDoa = data.map((json) => DoaHarian.fromJson(json)).toList();
      } else {
        _error = 'Gagal memuat data: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  void searchDoa(String query) {
    if (query.isEmpty) {
      _filteredDoa = [];
    } else {
      _filteredDoa = _allDoa
          .where((doa) => doa.judul.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    notifyListeners();
  }
}
