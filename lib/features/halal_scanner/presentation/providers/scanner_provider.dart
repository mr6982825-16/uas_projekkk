import 'package:flutter/material.dart';
import '../../domain/ai_ocr_processor.dart';
import '../../data/datasources/halal_api_client.dart';
import '../../data/models/product_model.dart';

class ScannerProvider extends ChangeNotifier {
  final HalalApiClient _apiClient = HalalApiClient();

  ProductHalal? _currentProduct;
  bool _isLoading = false;
  String _errorMessage = '';

  ProductHalal? get currentProduct => _currentProduct;
  bool get isLoading => _isLoading;
  String get errorMessage => _errorMessage;

  void reset() {
    _currentProduct = null;
    _isLoading = false;
    _errorMessage = '';
    notifyListeners();
  }

  Future<void> scanBarcode(String barcode) async {
    _isLoading = true;
    _errorMessage = '';
    _currentProduct = null;
    notifyListeners();

    try {
      final product = await _apiClient.checkBarcode(barcode);
      _currentProduct = product;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat memverifikasi barcode: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> scanCertificate(String noSertifikat) async {
    _isLoading = true;
    _errorMessage = '';
    _currentProduct = null;
    notifyListeners();

    try {
      final product = await _apiClient.checkCertificate(noSertifikat);
      _currentProduct = product;
    } catch (e) {
      _errorMessage = 'Terjadi kesalahan saat memverifikasi sertifikat: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  // ==== SPRINT 3: AI OCR ====
  OcrAnalysisResult? _ocrResult;
  final AiOcrProcessor _ocrProcessor = AiOcrProcessor();

  OcrAnalysisResult? get ocrResult => _ocrResult;

  Future<void> analyzeIngredientsImage(String imagePath) async {
    _isLoading = true;
    _errorMessage = '';
    _ocrResult = null;
    notifyListeners();

    try {
      final result = await _ocrProcessor.analyzeImage(imagePath);
      _ocrResult = result;
    } catch (e) {
      _errorMessage = 'Gagal menganalisis teks: $e';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  @override
  void dispose() {
    _ocrProcessor.dispose();
    super.dispose();
  }
}
