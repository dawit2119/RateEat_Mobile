// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_stat.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserStatAdapter extends TypeAdapter<UserStat> {
  @override
  final int typeId = 17;

  @override
  UserStat read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserStat(
      favoritesCount: fields[3] as int?,
      reviewsCount: fields[4] as int?,
      draftsCount: fields[5] as int?,
      followers: fields[0] as int?,
      following: fields[1] as int?,
      contributions: fields[2] as int?,
      recommendations: fields[6] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserStat obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.followers)
      ..writeByte(1)
      ..write(obj.following)
      ..writeByte(2)
      ..write(obj.contributions)
      ..writeByte(3)
      ..write(obj.favoritesCount)
      ..writeByte(4)
      ..write(obj.reviewsCount)
      ..writeByte(5)
      ..write(obj.draftsCount)
      ..writeByte(6)
      ..write(obj.recommendations);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserStatAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
