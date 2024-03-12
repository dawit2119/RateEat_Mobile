// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_reviews_item_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedReviewItemResponseAdapter
    extends TypeAdapter<SavedReviewItemResponse> {
  @override
  final int typeId = 31;

  @override
  SavedReviewItemResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedReviewItemResponse(
      itemId: fields[0] as String,
      itemName: fields[1] as String,
      price: fields[2] as double?,
      restaurantName: fields[3] as String?,
      imageUrl: fields[4] as String?,
      itemImages: (fields[5] as List?)?.cast<dynamic>(),
      createdAt: fields[6] as DateTime?,
      categories: fields[7] as ItemCategoriesModel?,
    );
  }

  @override
  void write(BinaryWriter writer, SavedReviewItemResponse obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.itemId)
      ..writeByte(1)
      ..write(obj.itemName)
      ..writeByte(2)
      ..write(obj.price)
      ..writeByte(3)
      ..write(obj.restaurantName)
      ..writeByte(4)
      ..write(obj.imageUrl)
      ..writeByte(5)
      ..write(obj.itemImages)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.categories);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedReviewItemResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItemCategoriesModelAdapter extends TypeAdapter<ItemCategoriesModel> {
  @override
  final int typeId = 32;

  @override
  ItemCategoriesModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemCategoriesModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
      menu: fields[2] as ItemMenuModel?,
    );
  }

  @override
  void write(BinaryWriter writer, ItemCategoriesModel obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.menu);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemCategoriesModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItemMenuModelAdapter extends TypeAdapter<ItemMenuModel> {
  @override
  final int typeId = 33;

  @override
  ItemMenuModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemMenuModel(
      id: fields[0] as String?,
      restaurant: fields[1] as ItemRestaurantModel?,
    );
  }

  @override
  void write(BinaryWriter writer, ItemMenuModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.restaurant);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemMenuModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ItemRestaurantModelAdapter extends TypeAdapter<ItemRestaurantModel> {
  @override
  final int typeId = 34;

  @override
  ItemRestaurantModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemRestaurantModel(
      id: fields[0] as String?,
      name: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ItemRestaurantModel obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemRestaurantModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
