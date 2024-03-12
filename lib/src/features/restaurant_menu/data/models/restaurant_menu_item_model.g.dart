// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant_menu_item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantMenuItemModelAdapter
    extends TypeAdapter<RestaurantMenuItemModel> {
  @override
  final int typeId = 27;

  @override
  RestaurantMenuItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantMenuItemModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      description: fields[2] as String?,
      imageUrl: fields[3] as String?,
      numberOfReviews: fields[4] as int?,
      averageRating: fields[5] as double?,
      price: fields[6] as double?,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantMenuItemModel obj) {
    writer
      ..writeByte(7)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.description)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.numberOfReviews)
      ..writeByte(5)
      ..write(obj.averageRating)
      ..writeByte(6)
      ..write(obj.price);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantMenuItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
