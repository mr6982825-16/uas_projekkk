import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';
import '../models/product_model.dart';

class HalalApiClient {
  final Dio _dio = Dio();
  
  // Menggunakan API Gateway Publik yang terhubung ke data nasional BPJPH
  final String _apiUrl = "https://halalcheck-api.p.rapidapi.com/v1/verify";
  // Ganti dengan API key RapidAPI Anda
  final String _apiKey = "SEMATKAN_API_KEY_RAPIDAPI_ANDA_DI_SINI"; 
  final String _apiHost = "halalcheck-api.p.rapidapi.com";

  Future<ProductHalal> checkProductStatus({required String query, required String type}) async {
    try {
      final response = await _dio.post(
        _apiUrl,
        options: Options(
          headers: {
            "X-RapidAPI-Key": _apiKey,
            "X-RapidAPI-Host": _apiHost,
            "Content-Type": "application/json",
          },
        ),
        data: {
          "query": query,
          "type": type, // "barcode" atau "cert_number"
          "fetch_detail": true,
          "include_ingredients_analysis": false
        },
      );

      if (response.statusCode == 200 && response.data != null) {
        return ProductHalal.fromJson(response.data);
      }
    } catch (e) {
      debugPrint("Error fetching halal data dari API: $e");
    }

    // FASE 3 Fallback: Jika API gagal, tidak ditemukan, atau API Key belum diisi
    return ProductHalal(
      barcode: type == 'barcode' ? query : '-',
      namaProduk: 'Produk Tidak Ditemukan',
      produsen: '-',
      nomorSertifikat: type == 'cert_number' ? query : '-',
      status: HalalStatus.notFound,
      keterangan: 'Produk belum terdaftar di database BPJPH/MUI. Silakan gunakan fitur Scan Komposisi untuk menganalisis kandungan bahan secara mandiri.'
    );
  }
}
