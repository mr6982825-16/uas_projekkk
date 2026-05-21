class AssetModel {
  String name;
  double value;
  String category; // "Uang", "Properti", "Emas", "Lainnya"

  AssetModel({
    required this.name,
    required this.value,
    this.category = 'Lainnya',
  });
}

class HeirModel {
  // Ahli waris inti
  bool isHusbandAlive;
  bool isWifeAlive; // In islam, can be more than 1, but for v1 we simplify to boolean or count
  int wifeCount;
  int sonCount;
  int daughterCount;
  bool isFatherAlive;
  bool isMotherAlive;

  HeirModel({
    this.isHusbandAlive = false,
    this.isWifeAlive = false,
    this.wifeCount = 0,
    this.sonCount = 0,
    this.daughterCount = 0,
    this.isFatherAlive = false,
    this.isMotherAlive = false,
  });

  // Reset state
  void reset() {
    isHusbandAlive = false;
    isWifeAlive = false;
    wifeCount = 0;
    sonCount = 0;
    daughterCount = 0;
    isFatherAlive = false;
    isMotherAlive = false;
  }
}

class HeirShare {
  final String name;
  final String relation;
  final double portion; // Bentuk desimal/pecahan dari total
  final double amount; // Nilai uang riil

  HeirShare({
    required this.name,
    required this.relation,
    required this.portion,
    required this.amount,
  });
}
