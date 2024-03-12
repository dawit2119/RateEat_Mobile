// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'incentive.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class IncentiveAdapter extends TypeAdapter<Incentive> {
  @override
  final int typeId = 15;

  @override
  Incentive read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Incentive(
      id: fields[0] as String?,
      totalIncentivized: fields[1] as double?,
      pendingIncentive: fields[2] as double?,
      weeklyRank: fields[3] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, Incentive obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.totalIncentivized)
      ..writeByte(2)
      ..write(obj.pendingIncentive)
      ..writeByte(3)
      ..write(obj.weeklyRank);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IncentiveAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
