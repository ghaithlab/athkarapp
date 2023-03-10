// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'habitsModel.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class HabitRecordAdapter extends TypeAdapter<HabitRecord> {
  @override
  final int typeId = 0;

  @override
  HabitRecord read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return HabitRecord(
      id: fields[0] as String,
      name: fields[1] as String,
      isBasicHabit: fields[7] as bool?,
      isDefaultHabit: fields[6] as bool?,
      creationDate: fields[9] as DateTime?,
      maxValue: fields[10] == null ? 1 : fields[10] as int,
    )..records = (fields[8] as Map?)?.cast<DateTime, int>();
  }

  @override
  void write(BinaryWriter writer, HabitRecord obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(8)
      ..write(obj.records)
      ..writeByte(9)
      ..write(obj.creationDate)
      ..writeByte(6)
      ..write(obj.isDefaultHabit)
      ..writeByte(7)
      ..write(obj.isBasicHabit)
      ..writeByte(10)
      ..write(obj.maxValue);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is HabitRecordAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
