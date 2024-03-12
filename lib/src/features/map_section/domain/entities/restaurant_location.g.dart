// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_location.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantLocationAdapter extends TypeAdapter<RestaurantLocation> {
  @override
  final int typeId = 12;

  @override
  RestaurantLocation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantLocation(
      id: fields[0] as String?,
      latitude: fields[1] as double?,
      longitude: fields[2] as double?,
      description: fields[3] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantLocation obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.latitude)
      ..writeByte(2)
      ..write(obj.longitude)
      ..writeByte(3)
      ..write(obj.description);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantLocationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
