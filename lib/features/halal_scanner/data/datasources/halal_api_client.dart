import 'dart:convert';
import 'package:dio/dio.dart';
import '../models/product_model.dart';

class HalalApiClient {
  final Dio _dio = Dio();

  // Simulasi Mock Database Lokal
  final Map<String, Map<String, dynamic>> _mockDatabase = {
    '8999999123456': {
      'barcode': '8999999123456',
      'namaProduk': 'Indomie Goreng Spesial',
      'produsen': 'PT Indofood CBP',
      'nomorSertifikat': 'LPPOM-00090000300799',
      'status': 'halal',
      'keterangan': 'Sertifikat Aktif'
    },
    '8991234567890': {
      'barcode': '8991234567890',
      'namaProduk': 'Keripik Babi Panggang (Non-Halal)',
      'produsen': 'PT Babi Merah',
      'nomorSertifikat': '-',
      'status': 'haram',
      'keterangan': 'Mengandung Babi (Pork)'
    },
    '1234567890123': {
      'barcode': '1234567890123',
      'namaProduk': 'Permen Karet Import',
      'produsen': 'Overseas Candy Co.',
      'nomorSertifikat': '-',
      'status': 'syubhat',
      'keterangan': 'Mengandung Gelatin yang belum jelas kehalalannya'
    }
  };

  Future<ProductHalal> checkBarcode(String barcode) async {
    // Simulasi delay jaringan (Network Request Simulation)
    await Future.delayed(const Duration(milliseconds: 1500));

    // Jika kita menggunakan API asli, kodenya akan seperti ini:
    /*
    try {
      final response = await _dio.get('https://api.halal.go.id/v1/products?barcode=$barcode');
      if (response.statusCode == 200) {
        return ProductHalal.fromJson(response.data);
      }
    } catch (e) {
      // Tangani error
    }
    */

    // Menggunakan Mock Data
    if (_mockDatabase.containsKey(barcode)) {
      return ProductHalal.fromJson(_mockDatabase[barcode]!);
    } else {
      return ProductHalal(
        barcode: barcode,
        namaProduk: 'Produk Tidak Ditemukan',
        produsen: '-',
        nomorSertifikat: '-',
        status: HalalStatus.notFound,
        keterangan: 'Barcode tidak terdaftar dalam database resmi LPPOM MUI.'
      );
    }
  }

  Future<ProductHalal> checkCertificate(String noSertifikat) async {
    // Simulasi delay jaringan
    await Future.delayed(const Duration(milliseconds: 1500));

    // Mencari di mock database berdasarkan nomorSertifikat
    final entry = _mockDatabase.values.cast<Map<String, dynamic>>().firstWhere(
      (element) => element['nomorSertifikat'] == noSertifikat,
      orElse: () => {},
    );

    if (entry.isNotEmpty) {
      return ProductHalal.fromJson(entry);
    } else {
      // Mock khusus untuk nomor sertifikat dari BPJPH URL
      if (noSertifikat.startsWith('ID')) {
        return ProductHalal(
          barcode: '-',
          namaProduk: 'Produk BPJPH Verified',
          produsen: 'UMKM Indonesia Terdaftar',
          nomorSertifikat: noSertifikat,
          status: HalalStatus.halal,
          keterangan: 'Sertifikat BPJPH Resmi Aktif'
        );
      }

      return ProductHalal(
        barcode: '-',
        namaProduk: 'Sertifikat Tidak Ditemukan',
        produsen: '-',
        nomorSertifikat: noSertifikat,
        status: HalalStatus.notFound,
        keterangan: 'Sertifikat tidak terdaftar di database resmi BPJPH / LPPOM MUI.'
      );
    }
  }
}
