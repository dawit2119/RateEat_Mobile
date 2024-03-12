// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_phone_number.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantPhoneNumberAdapter extends TypeAdapter<RestaurantPhoneNumber> {
  @override
  final int typeId = 13;

  @override
  RestaurantPhoneNumber read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantPhoneNumber(
      id: fields[0] as String?,
      phoneNumber: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantPhoneNumber obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.phoneNumber);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantPhoneNumberAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
