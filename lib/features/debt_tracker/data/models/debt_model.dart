import 'package:hive/hive.dart';

part 'debt_model.g.dart';

@HiveType(typeId: 0)
class DebtModel extends HiveObject {
  @HiveField(0)
  final String id;

  @HiveField(1)
  String name;

  @HiveField(2)
  double amount;

  @HiveField(3)
  bool isDebt; // true = Utang (Kewajiban), false = Piutang (Hak)

  @HiveField(4)
  DateTime? dueDate;

  @HiveField(5)
  bool isPaid;

  @HiveField(6)
  DateTime createdAt;

  @HiveField(7)
  String category; // E.g., 'Uang', 'Barang', dll.

  DebtModel({
    required this.id,
    required this.name,
    required this.amount,
    required this.isDebt,
    this.dueDate,
    this.isPaid = false,
    required this.createdAt,
    this.category = 'Uang',
  });

  // Factory untuk membuat entri baru dengan mudah
  factory DebtModel.create({
    required String name,
    required double amount,
    required bool isDebt,
    DateTime? dueDate,
    String category = 'Uang',
  }) {
    return DebtModel(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      name: name,
      amount: amount,
      isDebt: isDebt,
      dueDate: dueDate,
      createdAt: DateTime.now(),
      category: category,
    );
  }
}
