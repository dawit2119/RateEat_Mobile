// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemAdapter extends TypeAdapter<Item> {
  @override
  final int typeId = 6;

  @override
  Item read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Item(
      itemId: fields[0] as String,
      itemName: fields[1] as String,
      numberOfReviews: fields[2] as int,
      description: fields[3] as String?,
      averageRating: fields[4] as double?,
      price: fields[5] as double?,
      restaurantName: fields[6] as String?,
      imageUrl: fields[7] as String?,
      itemImages: (fields[8] as List?)?.cast<ItemMedia>(),
      itemVideos: (fields[9] as List?)?.cast<ItemMedia>(),
      tags: (fields[10] as List?)?.cast<String>(),
      categoryId: fields[11] as String?,
      fasting: fields[12] as bool?,
      priceUpdatedAt: fields[13] as DateTime?,
      createdAt: fields[14] as DateTime?,
      updatedAt: fields[15] as DateTime?,
      ingredients: (fields[16] as List?)?.cast<Ingredient>(),
      minutes: fields[17] as int?,
      isOpen: fields[18] as bool?,
      isFavorite: fields[19] as bool?,
      distance: (fields[22] as String?) ?? '0.0',
      ridingTime: (fields[21] as String?) ?? '',
      walkingTime: (fields[20] as String?) ?? '',
      currencyCode: (fields[23] as String?) ?? 'ETB',
    );
  }

  @override
  void write(BinaryWriter writer, Item obj) {
    writer
      ..writeByte(24)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.numberOfReviews)
      ..writeByte(3)
      ..write(obj.description)
      ..writeByte(4)
      ..write(obj.averageRating)
      ..writeByte(5)
      ..write(obj.price)
      ..writeByte(6)
      ..write(obj.restaurantName)
      ..writeByte(7)
      ..write(obj.imageUrl)
      ..writeByte(8)
      ..write(obj.itemImages)
      ..writeByte(9)
      ..write(obj.itemVideos)
      ..writeByte(10)
      ..write(obj.tags)
      ..writeByte(11)
      ..write(obj.categoryId)
      ..writeByte(12)
      ..write(obj.fasting)
      ..writeByte(13)
      ..write(obj.priceUpdatedAt)
      ..writeByte(14)
      ..write(obj.createdAt)
      ..writeByte(15)
      ..write(obj.updatedAt)
      ..writeByte(16)
      ..write(obj.ingredients)
      ..writeByte(17)
      ..write(obj.minutes)
      ..writeByte(18)
      ..write(obj.isOpen)
      ..writeByte(19)
      ..write(obj.isFavorite)
      ..writeByte(20)
      ..write(obj.walkingTime)
      ..writeByte(21)
      ..write(obj.ridingTime)
      ..writeByte(22)
      ..write(obj.distance)
      ..writeByte(23)
      ..write(obj.currencyCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class IngredientAdapter extends TypeAdapter<Ingredient> {
  @override
  final int typeId = 7;

  @override
  Ingredient read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Ingredient(
      id: fields[0] as String,
      name: fields[1] as String,
      itemId: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, Ingredient obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.itemId);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is IngredientAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItemMediaAdapter extends TypeAdapter<ItemMedia> {
  @override
  final int typeId = 8;

  @override
  ItemMedia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemMedia(
      id: fields[0] as String,
      url: fields[1] as String,
      isLeading: fields[2] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, ItemMedia obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.isLeading);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemMediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
