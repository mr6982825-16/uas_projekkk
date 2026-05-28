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
      // Dibagi rata per istri
      for (int i = 1; i <= heirs.wifeCount; i++) {
        results.add(HeirShare(
          name: heirs.wifeCount > 1 ? "Istri ke-$i" : "Istri", 
          relation: "Istri", 
          portion: wifePortion / heirs.wifeCount, 
          amount: amount / heirs.wifeCount
        ));
      }
      remainingAssets -= amount;
    }

    // 2. Hitung porsi Ayah
    if (heirs.isFatherAlive) {
      double fatherPortion = 0;
      if (hasChildren) {
        fatherPortion = 1 / 6;
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
      double totalAmount = totalAssets * daughterPortion;
      
      // Dibagi rata per anak perempuan
      for (int i = 1; i <= heirs.daughterCount; i++) {
        results.add(HeirShare(
          name: heirs.daughterCount > 1 ? "Anak Perempuan ke-$i" : "Anak Perempuan", 
          relation: "Anak Pr", 
          portion: daughterPortion / heirs.daughterCount, 
          amount: totalAmount / heirs.daughterCount
        ));
      }
      remainingAssets -= totalAmount;
      
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
        double sonAmountPerPerson = sharePerUnit * 2;
        for (int i = 1; i <= heirs.sonCount; i++) {
          results.add(HeirShare(
            name: heirs.sonCount > 1 ? "Anak Laki-Laki ke-$i" : "Anak Laki-Laki", 
            relation: "Anak Lk", 
            portion: sonAmountPerPerson / totalAssets, 
            amount: sonAmountPerPerson
          ));
        }
      }
      
      if (heirs.daughterCount > 0) {
        double daughterAmountPerPerson = sharePerUnit;
        for (int i = 1; i <= heirs.daughterCount; i++) {
          results.add(HeirShare(
            name: heirs.daughterCount > 1 ? "Anak Perempuan ke-$i" : "Anak Perempuan", 
            relation: "Anak Pr", 
            portion: daughterAmountPerPerson / totalAssets, 
            amount: daughterAmountPerPerson
          ));
        }
      }
      remainingAssets = 0;
    } else if (heirs.isFatherAlive && remainingAssets > 0 && !hasChildren) {
      // Ayah sebagai Ashabah murni karena tidak ada keturunan
      results.add(HeirShare(name: "Ayah (Ashabah)", relation: "Ayah", portion: remainingAssets / totalAssets, amount: remainingAssets));
      remainingAssets = 0;
    } else if (heirs.siblingCount > 0 && remainingAssets > 0) {
      // Logika Hijab: Saudara mendapat sisa HANYA jika TIDAK ADA Anak Laki-Laki dan TIDAK ADA Ayah.
      double sharePerUnit = remainingAssets / heirs.siblingCount;
      for (int i = 1; i <= heirs.siblingCount; i++) {
        results.add(HeirShare(
          name: heirs.siblingCount > 1 ? "Saudara Kandung ke-$i" : "Saudara Kandung", 
          relation: "Saudara", 
          portion: sharePerUnit / totalAssets, 
          amount: sharePerUnit
        ));
      }
      remainingAssets = 0;
    }

    // 6. Radd / Baitul Mal (Jika masih ada sisa harta dan tidak ada ashabah)
    if (remainingAssets > 0.01) { // 0.01 for floating point precision safety
      results.add(HeirShare(
        name: "Sisa Harta (Radd/Baitul Mal)", 
        relation: "Dikembalikan / Disumbangkan", 
        portion: remainingAssets / totalAssets, 
        amount: remainingAssets
      ));
      remainingAssets = 0;
    }

    return results;
  }
}
