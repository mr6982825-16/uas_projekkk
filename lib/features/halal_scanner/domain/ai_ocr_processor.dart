import 'package:google_mlkit_text_recognition/google_mlkit_text_recognition.dart';

class OcrAnalysisResult {
  final bool isSafe;
  final List<String> detectedCriticalIngredients;
  final String rawText;

  OcrAnalysisResult({
    required this.isSafe,
    required this.detectedCriticalIngredients,
    required this.rawText,
  });
}

class AiOcrProcessor {
  final TextRecognizer _textRecognizer = TextRecognizer(script: TextRecognitionScript.latin);

  // Kamus bahan kritis (Local Dictionary)
  final List<String> _criticalIngredients = [
    'babi', 'pork', 'lard', 'porcine', 'gelatin',
    'emulsifier', 'e471', 'e322', 'e472',
    'wine', 'rum', 'mirin', 'sake', 'alkohol', 'alcohol',
    'pepsin', 'rennet', 'carmine', 'karmin'
  ];

  Future<OcrAnalysisResult> analyzeImage(String imagePath) async {
    final inputImage = InputImage.fromFilePath(imagePath);
    final RecognizedText recognizedText = await _textRecognizer.processImage(inputImage);

    String rawText = recognizedText.text.toLowerCase();
    List<String> foundIngredients = [];

    // Deteksi bahan kritis
    for (String ingredient in _criticalIngredients) {
      if (rawText.contains(ingredient)) {
        foundIngredients.add(ingredient);
      }
    }

    return OcrAnalysisResult(
      isSafe: foundIngredients.isEmpty,
      detectedCriticalIngredients: foundIngredients,
      rawText: recognizedText.text,
    );
  }

  void dispose() {
    _textRecognizer.close();
  }
}
