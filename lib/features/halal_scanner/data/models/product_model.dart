enum HalalStatus { halal, syubhat, haram, notFound }

class ProductHalal {
  final String barcode;
  final String namaProduk;
  final String produsen;
  final String nomorSertifikat;
  final HalalStatus status;
  final String? keterangan;

  ProductHalal({
    required this.barcode,
    required this.namaProduk,
    required this.produsen,
    required this.nomorSertifikat,
    required this.status,
    this.keterangan,
  });

  factory ProductHalal.fromJson(Map<String, dynamic> json) {
    return ProductHalal(
      barcode: json['barcode'] ?? '',
      namaProduk: json['namaProduk'] ?? 'Produk Tidak Dikenal',
      produsen: json['produsen'] ?? '-',
      nomorSertifikat: json['nomorSertifikat'] ?? '-',
      status: _parseStatus(json['status']),
      keterangan: json['keterangan'],
    );
  }

  static HalalStatus _parseStatus(String? statusStr) {
    switch (statusStr?.toLowerCase()) {
      case 'halal':
        return HalalStatus.halal;
      case 'syubhat':
        return HalalStatus.syubhat;
      case 'haram':
        return HalalStatus.haram;
      default:
        return HalalStatus.notFound;
    }
  }
}
