import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import '../../data/models/debt_model.dart';

class DebtProvider extends ChangeNotifier {
  static const String _boxName = 'debt_box';
  List<DebtModel> _debts = [];
  bool _isLoading = true;

  List<DebtModel> get debts => _debts;
  bool get isLoading => _isLoading;

  double get totalDebt {
    return _debts
        .where((d) => d.isDebt && !d.isPaid)
        .fold(0.0, (sum, d) => sum + d.amount);
  }

  double get totalReceivable {
    return _debts
        .where((d) => !d.isDebt && !d.isPaid)
        .fold(0.0, (sum, d) => sum + d.amount);
  }

  Future<void> init() async {
    if (!Hive.isAdapterRegistered(0)) {
      Hive.registerAdapter(DebtModelAdapter());
    }

    final box = await Hive.openBox<DebtModel>(_boxName);
    _debts = box.values.toList();
    
    // Sort by newest
    _debts.sort((a, b) => b.createdAt.compareTo(a.createdAt));

    _isLoading = false;
    notifyListeners();
  }

  Future<void> addDebt(DebtModel debt) async {
    final box = Hive.box<DebtModel>(_boxName);
    await box.add(debt);
    _debts.insert(0, debt);
    notifyListeners();
  }

  Future<void> deleteDebt(DebtModel debt) async {
    await debt.delete();
    _debts.remove(debt);
    notifyListeners();
  }

  Future<void> togglePaidStatus(DebtModel debt) async {
    debt.isPaid = !debt.isPaid;
    await debt.save();
    notifyListeners();
  }
}
