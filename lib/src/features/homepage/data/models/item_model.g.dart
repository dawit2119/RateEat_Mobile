// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemModelAdapter extends TypeAdapter<ItemModel> {
  @override
  final int typeId = 24;

  @override
  ItemModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemModel(
      itemId: (fields[0] as String?) ?? '',
      itemName: (fields[1] as String?) ?? '',
      numberOfReviews: (fields[2] as int?) ?? 0,
      averageRating: (fields[3] as double?) ?? 0.0,
      description: (fields[4] as String?) ?? '',
      restaurantName: (fields[5] as String?) ?? '',
      price: (fields[6] as double?) ?? 0.0,
      imageUrl: (fields[7] as String?) ?? '',
      itemImages: (fields[8] as List?)?.cast<ItemMedia>() ?? [],
      itemVideos: (fields[9] as List?)?.cast<ItemMedia>() ?? [],
      tags: (fields[10] as List?)?.cast<String>() ?? [],
      categoryId: (fields[11] as String?) ?? '',
      fasting: (fields[12] as bool?) ?? false,
      priceUpdatedAt: fields[13] as DateTime?,
      createdAt: fields[14] as DateTime?,
      updatedAt: fields[15] as DateTime?,
      ingredients: (fields[16] as List?)?.cast<Ingredient>() ?? [],
      categories: fields[17] as Categories?,
      minutes: (fields[18] as int?) ?? 0,
      isOpen: (fields[19] as bool?) ?? true,
      isFavorite: (fields[20] as bool?) ?? false,
      distance: (fields[21] as String?) ?? '0.0',
      walkingTime: (fields[22] as String?) ?? '',
      ridingTime: (fields[23] as String?) ?? '',
      currencyCode: (fields[24] as String?) ?? 'ETB',
    );
  }

  @override
  void write(BinaryWriter writer, ItemModel obj) {
    writer
      ..writeByte(25)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.numberOfReviews)
      ..writeByte(3)
      ..write(obj.averageRating)
      ..writeByte(4)
      ..write(obj.description)
      ..writeByte(5)
      ..write(obj.restaurantName)
      ..writeByte(6)
      ..write(obj.price)
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
      ..write(obj.categories)
      ..writeByte(18)
      ..write(obj.minutes)
      ..writeByte(19)
      ..write(obj.isOpen)
      ..writeByte(20)
      ..write(obj.isFavorite)
      ..writeByte(21)
      ..write(obj.distance)
      ..writeByte(22)
      ..write(obj.walkingTime)
      ..writeByte(23)
      ..write(obj.ridingTime)
      ..writeByte(24)
      ..write(obj.currencyCode);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
