import 'package:dio/dio.dart';
import 'package:flutter/material.dart';

class Surah {
  final int number;
  final String name;
  final String englishName;
  final String englishNameTranslation;
  final int numberOfAyahs;
  final String revelationType;

  Surah({
    required this.number,
    required this.name,
    required this.englishName,
    required this.englishNameTranslation,
    required this.numberOfAyahs,
    required this.revelationType,
  });

  factory Surah.fromJson(Map<String, dynamic> json) {
    return Surah(
      number: json['nomor'],
      name: json['nama'],
      englishName: json['namaLatin'],
      englishNameTranslation: json['arti'],
      numberOfAyahs: json['jumlahAyat'],
      revelationType: json['tempatTurun'],
    );
  }
}

class Ayah {
  final int number;
  final String text;
  final String translation;
  final String transliteration;

  Ayah({
    required this.number,
    required this.text,
    required this.translation,
    required this.transliteration,
  });

  factory Ayah.fromJson(Map<String, dynamic> json) {
    return Ayah(
      number: json['nomorAyat'],
      text: json['teksArab'],
      translation: json['teksIndonesia'],
      transliteration: json['teksLatin'],
    );
  }
}

class QuranProvider extends ChangeNotifier {
  final Dio _dio = Dio();
  List<Surah> _surahs = [];
  List<Ayah> _ayahs = [];
  bool _isLoading = false;

  List<Surah> get surahs => _surahs;
  List<Ayah> get ayahs => _ayahs;
  bool get isLoading => _isLoading;

  Future<void> fetchSurahs() async {
    _isLoading = true;
    notifyListeners();

    try {
      final response = await _dio.get("https://equran.id/api/v2/surat");
      if (response.statusCode == 200) {
        final List data = response.data['data'];
        _surahs = data.map((json) => Surah.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching surahs: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }

  Future<void> fetchAyahs(int surahNumber) async {
    _isLoading = true;
    _ayahs = [];
    notifyListeners();

    try {
      final response = await _dio.get("https://equran.id/api/v2/surat/$surahNumber");
      if (response.statusCode == 200) {
        final List data = response.data['data']['ayat'];
        _ayahs = data.map((json) => Ayah.fromJson(json)).toList();
      }
    } catch (e) {
      debugPrint("Error fetching ayahs: $e");
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
