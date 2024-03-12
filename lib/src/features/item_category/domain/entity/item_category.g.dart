// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'item_category.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class ItemCategoryAdapter extends TypeAdapter<ItemCategory> {
  @override
  final int typeId = 5;

  @override
  ItemCategory read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ItemCategory(
      id: fields[0] as String?,
      name: fields[1] as String?,
      itemId: fields[2] as String?,
      createdAt: fields[3] as DateTime?,
      updatedAt: fields[4] as DateTime?,
      iconUrl: fields[5] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ItemCategory obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.itemId)
      ..writeByte(3)
      ..write(obj.createdAt)
      ..writeByte(4)
      ..write(obj.updatedAt)
      ..writeByte(5)
      ..write(obj.iconUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ItemCategoryAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
