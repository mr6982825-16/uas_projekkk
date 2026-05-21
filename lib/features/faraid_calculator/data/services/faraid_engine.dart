import '../models/faraid_models.dart';

class FaraidEngine {
  /// Kalkulator utama untuk menghitung porsi waris (V1 - Ahli Waris Utama)
  static List<HeirShare> calculate(double totalAssets, HeirModel heirs) {
    List<HeirShare> results = [];
    double remainingAssets = totalAssets;

    bool hasChildren = heirs.sonCount > 0 || heirs.daughterCount > 0;
    
    // 1. Hitung porsi Suami / Istri (Dzawil Furudh)
    if (heirs.isHusbandAlive) {
      double husbandPortion = hasChildren ? 1 / 4 : 1 / 2;
      double amount = totalAssets * husbandPortion;
      results.add(HeirShare(name: "Suami", relation: "Suami", portion: husbandPortion, amount: amount));
      remainingAssets -= amount;
    } else if (heirs.isWifeAlive && heirs.wifeCount > 0) {
      double wifePortion = hasChildren ? 1 / 8 : 1 / 4;
      double amount = totalAssets * wifePortion;
      // Jika lebih dari 1 istri, dibagi rata
      results.add(HeirShare(name: "Istri", relation: "Istri (${heirs.wifeCount})", portion: wifePortion, amount: amount));
      remainingAssets -= amount;
    }

    // 2. Hitung porsi Ayah
    if (heirs.isFatherAlive) {
      double fatherPortion = 0;
      if (hasChildren) {
        fatherPortion = 1 / 6;
      } else {
        // Jika tidak ada anak, ayah mengambil Ashabah (Sisa). Kita tangani nanti di akhir
        // Namun sebagai Dzawil Furudh, beliau juga bisa mendapat 1/6 + sisa jika hanya ada anak perempuan
      }
      
      if (fatherPortion > 0) {
        double amount = totalAssets * fatherPortion;
        results.add(HeirShare(name: "Ayah", relation: "Ayah", portion: fatherPortion, amount: amount));
        remainingAssets -= amount;
      }
    }

    // 3. Hitung porsi Ibu
    if (heirs.isMotherAlive) {
      double motherPortion = hasChildren ? 1 / 6 : 1 / 3;
      double amount = totalAssets * motherPortion;
      results.add(HeirShare(name: "Ibu", relation: "Ibu", portion: motherPortion, amount: amount));
      remainingAssets -= amount;
    }

    // 4. Hitung Anak Perempuan (jika tidak ada anak laki-laki)
    if (heirs.daughterCount > 0 && heirs.sonCount == 0) {
      double daughterPortion = heirs.daughterCount == 1 ? 1 / 2 : 2 / 3;
      double amount = totalAssets * daughterPortion;
      results.add(HeirShare(name: "Anak Perempuan", relation: "Anak Pr (${heirs.daughterCount})", portion: daughterPortion, amount: amount));
      remainingAssets -= amount;
      
      // Jika Ayah masih hidup dan hanya ada anak perempuan, ayah dapat tambahan sisa (Ashabah)
      if (heirs.isFatherAlive && remainingAssets > 0) {
        results.add(HeirShare(name: "Ayah (Ashabah)", relation: "Ayah", portion: remainingAssets / totalAssets, amount: remainingAssets));
        remainingAssets = 0;
      }
    }

    // 5. Ashabah (Sisa Harta)
    // Anak Laki-Laki & Anak Perempuan (Jika ada anak laki-laki)
    if (heirs.sonCount > 0 && remainingAssets > 0) {
      int totalShares = (heirs.sonCount * 2) + heirs.daughterCount;
      double sharePerUnit = remainingAssets / totalShares;
      
      if (heirs.sonCount > 0) {
        double sonAmount = sharePerUnit * 2 * heirs.sonCount;
        results.add(HeirShare(name: "Anak Laki-Laki", relation: "Anak Lk (${heirs.sonCount})", portion: sonAmount / totalAssets, amount: sonAmount));
      }
      
      if (heirs.daughterCount > 0) {
        double daughterAmount = sharePerUnit * heirs.daughterCount;
        results.add(HeirShare(name: "Anak Perempuan", relation: "Anak Pr (${heirs.daughterCount})", portion: daughterAmount / totalAssets, amount: daughterAmount));
      }
      remainingAssets = 0;
    } else if (heirs.isFatherAlive && remainingAssets > 0 && !hasChildren) {
      // Ayah sebagai Ashabah murni karena tidak ada keturunan
      results.add(HeirShare(name: "Ayah (Ashabah)", relation: "Ayah", portion: remainingAssets / totalAssets, amount: remainingAssets));
      remainingAssets = 0;
    }

    return results;
  }
}
