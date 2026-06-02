class DoaModel {
  final String id;
  final String title;
  final String arabicText;
  final String transliteration;
  final String translation;
  final String category;
  final int target;
  final String? source;
  final String? note;

  DoaModel({
    required this.id,
    required this.title,
    required this.arabicText,
    required this.transliteration,
    required this.translation,
    required this.category,
    this.target = 1,
    this.source,
    this.note,
  });

  factory DoaModel.fromJson(Map<String, dynamic> json) {
    return DoaModel(
      id: json['id'] as String,
      title: json['title'] as String,
      arabicText: json['arabicText'] as String,
      transliteration: json['transliteration'] as String,
      translation: json['translation'] as String,
      category: json['category'] as String,
      target: json['target'] != null ? json['target'] as int : 1,
      source: json['source'] as String?,
      note: json['note'] as String?,
    );
  }
}
