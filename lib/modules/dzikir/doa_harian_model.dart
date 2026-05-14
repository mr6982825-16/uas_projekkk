class DoaHarian {
  final String judul;
  final String arab;
  final String latin;
  final String artinya;
  final String source;

  DoaHarian({
    required this.judul,
    required this.arab,
    required this.latin,
    required this.artinya,
    required this.source,
  });

  factory DoaHarian.fromJson(Map<String, dynamic> json) {
    return DoaHarian(
      judul: json['judul'] ?? '',
      arab: json['doa'] ?? '',
      latin: json['latin'] ?? '',
      artinya: json['artinya'] ?? '',
      source: json['source'] ?? '',
    );
  }
}
