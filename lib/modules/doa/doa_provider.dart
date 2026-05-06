import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:uas_projekk/core/constants.dart';

class DoaProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  List<dynamic> _allDoas = [];
  bool _isLoading = false;

  List<dynamic> get allDoas => _allDoas;
  bool get isLoading => _isLoading;

  Future<void> fetchAllDoas() async {
    if (_allDoas.isNotEmpty) return;
    
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get(AppConstants.doaBaseUrl);
      if (response.statusCode == 200) {
        _allDoas = response.data['data'];
      }
    } catch (e) {
      debugPrint("Error fetching Doas: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  List<dynamic> getDoasByCategory(String category) {
    if (category == "Semua Doa") return _allDoas;
    
    final query = category.toLowerCase();
    
    if (query == "pagi & petang") {
      return _allDoas.where((d) => d['judul'].toLowerCase().contains('pagi') || d['judul'].toLowerCase().contains('petang')).toList();
    }
    if (query == "sholat & ibadah") {
      return _allDoas.where((d) => d['judul'].toLowerCase().contains('shalat') || d['judul'].toLowerCase().contains('wudhu') || d['judul'].toLowerCase().contains('masjid')).toList();
    }
    if (query == "makanan & minuman") {
      return _allDoas.where((d) => d['judul'].toLowerCase().contains('makan') || d['judul'].toLowerCase().contains('minum')).toList();
    }
    if (query == "kebahagiaan & kesulitan") {
      return _allDoas.where((d) => d['judul'].toLowerCase().contains('sedih') || d['judul'].toLowerCase().contains('sulit') || d['judul'].toLowerCase().contains('bahagia') || d['judul'].toLowerCase().contains('gelisah')).toList();
    }
    if (query == "sakit & kematian") {
      return _allDoas.where((d) => d['judul'].toLowerCase().contains('sakit') || d['judul'].toLowerCase().contains('mati') || d['judul'].toLowerCase().contains('jenazah')).toList();
    }
    if (query == "perjalanan") {
      return _allDoas.where((d) => d['judul'].toLowerCase().contains('safar') || d['judul'].toLowerCase().contains('kendaraan') || d['judul'].toLowerCase().contains('perjalanan')).toList();
    }
    if (query == "haji & umrah") {
      return _allDoas.where((d) => d['judul'].toLowerCase().contains('haji') || d['judul'].toLowerCase().contains('umrah') || d['judul'].toLowerCase().contains('ihram')).toList();
    }
    if (query == "adab & karakter") {
      return _allDoas.where((d) => d['judul'].toLowerCase().contains('marah') || d['judul'].toLowerCase().contains('sombong') || d['judul'].toLowerCase().contains('syukur')).toList();
    }
    
    // Default fallback: search by name
    final filtered = _allDoas.where((d) => d['judul'].toLowerCase().contains(query)).toList();
    return filtered.isNotEmpty ? filtered : _allDoas.take(10).toList();
  }
}
