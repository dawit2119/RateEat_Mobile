// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_level.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserLevelAdapter extends TypeAdapter<UserLevel> {
  @override
  final int typeId = 19;

  @override
  UserLevel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserLevel(
      level: fields[0] as int?,
      levelName: fields[1] as String?,
      nextLevelMinimum: fields[2] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserLevel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.level)
      ..writeByte(1)
      ..write(obj.levelName)
      ..writeByte(2)
      ..write(obj.nextLevelMinimum);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserLevelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
