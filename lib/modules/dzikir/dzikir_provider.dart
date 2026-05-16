import 'package:flutter/material.dart';
import 'package:dio/dio.dart';
import 'package:uas_projekk/modules/dzikir/dzikir_model.dart';

class DzikirProvider with ChangeNotifier {
  final Dio _dio = Dio();
  List<Dzikir> _dzikirPagi = [];
  List<Dzikir> _dzikirPetang = [];
  bool _isLoading = false;
  String? _error;

  List<Dzikir> get dzikirPagi => _dzikirPagi;
  List<Dzikir> get dzikirPetang => _dzikirPetang;
  bool get isLoading => _isLoading;
  String? get error => _error;

  Future<void> fetchDzikirData() async {
    _isLoading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await _dio.get(
        'https://raw.githubusercontent.com/hudamnhd/dzikir-pagi-petang/main/data.json'
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = response.data is String 
            ? Map<String, dynamic>.from(response.data as Map) 
            : response.data;
            
        // The raw.githubusercontent usually returns string if not configured, 
        // but Dio handles it if Content-Type is application/json.
        // If it's a string, we might need to jsonDecode. 
        // But Dio usually handles it.

        if (data.containsKey('pagi')) {
          _dzikirPagi = (data['pagi'] as List)
              .map((item) => Dzikir.fromJson(item, 'pagi'))
              .toList();
        }

        if (data.containsKey('petang')) {
          _dzikirPetang = (data['petang'] as List)
              .map((item) => Dzikir.fromJson(item, 'petang'))
              .toList();
        }
      }
    } catch (e) {
      _error = "Gagal memuat data dzikir: $e";
      debugPrint(_error);
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
