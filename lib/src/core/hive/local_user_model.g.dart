// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'local_user_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class LocalUserModelAdapter extends TypeAdapter<LocalUserModel> {
  @override
  final int typeId = 2;

  @override
  LocalUserModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return LocalUserModel(
      id: fields[0] as String?,
      telegramId: fields[1] as String?,
      facebookId: fields[2] as String?,
      userName: fields[3] as String?,
      firstName: fields[4] as String?,
      lastName: fields[5] as String?,
      dateOfBirth: fields[6] as String?,
      email: fields[7] as String?,
      gender: fields[8] as String?,
      roleId: fields[9] as String?,
      phoneNumber: fields[10] as String?,
      image: fields[11] as String?,
      createdAt: fields[12] as DateTime?,
      updatedAt: fields[13] as DateTime?,
      token: fields[14] as String?,
      refreshtoken: fields[18] as String?,
      incentive: fields[15] as Incentive?,
      fcmToken: fields[16] as String?,
      verified: fields[17] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, LocalUserModel obj) {
    writer
      ..writeByte(19)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.telegramId)
      ..writeByte(2)
      ..write(obj.facebookId)
      ..writeByte(3)
      ..write(obj.userName)
      ..writeByte(4)
      ..write(obj.firstName)
      ..writeByte(5)
      ..write(obj.lastName)
      ..writeByte(6)
      ..write(obj.dateOfBirth)
      ..writeByte(7)
      ..write(obj.email)
      ..writeByte(8)
      ..write(obj.gender)
      ..writeByte(9)
      ..write(obj.roleId)
      ..writeByte(10)
      ..write(obj.phoneNumber)
      ..writeByte(11)
      ..write(obj.image)
      ..writeByte(12)
      ..write(obj.createdAt)
      ..writeByte(13)
      ..write(obj.updatedAt)
      ..writeByte(14)
      ..write(obj.token)
      ..writeByte(15)
      ..write(obj.incentive)
      ..writeByte(16)
      ..write(obj.fcmToken)
      ..writeByte(17)
      ..write(obj.verified)
      ..writeByte(18)
      ..write(obj.refreshtoken);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is LocalUserModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
