// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'debt_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DebtModelAdapter extends TypeAdapter<DebtModel> {
  @override
  final int typeId = 0;

  @override
  DebtModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DebtModel(
      id: fields[0] as String,
      name: fields[1] as String,
      amount: fields[2] as double,
      isDebt: fields[3] as bool,
      dueDate: fields[4] as DateTime?,
      isPaid: fields[5] as bool,
      createdAt: fields[6] as DateTime,
      category: fields[7] as String,
    );
  }

  @override
  void write(BinaryWriter writer, DebtModel obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.amount)
      ..writeByte(3)
      ..write(obj.isDebt)
      ..writeByte(4)
      ..write(obj.dueDate)
      ..writeByte(5)
      ..write(obj.isPaid)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.category);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DebtModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
