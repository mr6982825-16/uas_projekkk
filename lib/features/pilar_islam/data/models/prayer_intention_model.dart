class PrayerIntention {
  final String id;
  final String name;
  final String category;
  final String mode;
  final String niatArab;
  final String niatLatin;
  final String niatTranslation;
  final String rakat;
  final String description;
  final String note;
  final bool travelOnly;

  PrayerIntention({
    required this.id,
    required this.name,
    required this.category,
    required this.mode,
    required this.niatArab,
    required this.niatLatin,
    required this.niatTranslation,
    required this.rakat,
    required this.description,
    this.note = '',
    this.travelOnly = false,
  });
}
