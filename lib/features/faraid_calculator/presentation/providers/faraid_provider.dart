import 'package:flutter/material.dart';
import '../../data/models/faraid_models.dart';
import '../../data/services/faraid_engine.dart';

class FaraidProvider extends ChangeNotifier {
  List<AssetModel> _assets = [];
  HeirModel _heirs = HeirModel();
  List<HeirShare> _results = [];

  List<AssetModel> get assets => _assets;
  HeirModel get heirs => _heirs;
  List<HeirShare> get results => _results;

  double get totalAssets => _assets.fold(0.0, (sum, item) => sum + item.value);

  // -- Asset Management --
  void addAsset(AssetModel asset) {
    if (asset.name == "Pelunasan Utang Aktif" || asset.name == "Penambahan Piutang Aktif") {
      _assets.removeWhere((item) => item.name == asset.name);
    }
    _assets.add(asset);
    notifyListeners();
  }

  void removeAsset(int index) {
    _assets.removeAt(index);
    notifyListeners();
  }

  void clearAssets() {
    _assets.clear();
    notifyListeners();
  }

  // -- Heir Management --
  void updateHeirs(HeirModel newHeirs) {
    _heirs = newHeirs;
    notifyListeners();
  }

  // -- Calculation --
  void calculateFaraid() {
    if (totalAssets <= 0) {
      _results = [];
      notifyListeners();
      return;
    }

    _results = FaraidEngine.calculate(totalAssets, _heirs);
    notifyListeners();
  }

  // Reset
  void resetAll() {
    _assets.clear();
    _heirs.reset();
    _results.clear();
    notifyListeners();
  }
}
