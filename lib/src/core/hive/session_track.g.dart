// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'session_track.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserSessionAdapter extends TypeAdapter<UserSession> {
  @override
  final int typeId = 4;

  @override
  UserSession read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserSession(
      startTime: fields[0] as DateTime,
      totalSessionTime: fields[2] as int,
      endTime: fields[1] as DateTime?,
      sessionStartDate: fields[3] as DateTime,
    );
  }

  @override
  void write(BinaryWriter writer, UserSession obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.startTime)
      ..writeByte(1)
      ..write(obj.endTime)
      ..writeByte(2)
      ..write(obj.totalSessionTime)
      ..writeByte(3)
      ..write(obj.sessionStartDate);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserSessionAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
