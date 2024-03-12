// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_favorite.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserFavoriteAdapter extends TypeAdapter<UserFavorite> {
  @override
  final int typeId = 18;

  @override
  UserFavorite read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserFavorite(
      id: fields[0] as String?,
      userId: fields[1] as String?,
      date: fields[2] as String?,
      itemId: fields[3] as String?,
      createdAt: fields[4] as DateTime?,
      updatedAt: fields[5] as DateTime?,
      item: fields[6] as FavoriteItem?,
      restaurant: fields[7] as FavoriteRestaurant?,
    );
  }

  @override
  void write(BinaryWriter writer, UserFavorite obj) {
    writer
      ..writeByte(8)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.date)
      ..writeByte(3)
      ..write(obj.itemId)
      ..writeByte(4)
      ..write(obj.createdAt)
      ..writeByte(5)
      ..write(obj.updatedAt)
      ..writeByte(6)
      ..write(obj.item)
      ..writeByte(7)
      ..write(obj.restaurant);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserFavoriteAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FavoriteItemAdapter extends TypeAdapter<FavoriteItem> {
  @override
  final int typeId = 36;

  @override
  FavoriteItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteItem(
      id: fields[0] as String?,
      name: fields[1] as String?,
      averageRating: fields[2] as double?,
      ratingCount: fields[3] as int?,
      price: fields[4] as double?,
      description: fields[5] as String?,
      imageUrl: fields[6] as String?,
      itemImages: (fields[7] as List?)?.cast<dynamic>(),
      itemVideos: (fields[8] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteItem obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.averageRating)
      ..writeByte(3)
      ..write(obj.ratingCount)
      ..writeByte(4)
      ..write(obj.price)
      ..writeByte(5)
      ..write(obj.description)
      ..writeByte(6)
      ..write(obj.imageUrl)
      ..writeByte(7)
      ..write(obj.itemImages)
      ..writeByte(8)
      ..write(obj.itemVideos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class FavoriteRestaurantAdapter extends TypeAdapter<FavoriteRestaurant> {
  @override
  final int typeId = 37;

  @override
  FavoriteRestaurant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return FavoriteRestaurant(
      id: fields[0] as String?,
      name: fields[1] as String?,
      averageRating: fields[2] as double?,
      averagePrice: fields[3] as double?,
      numberOfReviews: fields[4] as int?,
      averageItemsRating: fields[5] as double?,
      totalItemReviews: fields[6] as int?,
      restaurantImages: (fields[7] as List?)?.cast<dynamic>(),
      imageUrl: fields[8] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, FavoriteRestaurant obj) {
    writer
      ..writeByte(9)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.averageRating)
      ..writeByte(3)
      ..write(obj.averagePrice)
      ..writeByte(4)
      ..write(obj.numberOfReviews)
      ..writeByte(5)
      ..write(obj.averageItemsRating)
      ..writeByte(6)
      ..write(obj.totalItemReviews)
      ..writeByte(7)
      ..write(obj.restaurantImages)
      ..writeByte(8)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is FavoriteRestaurantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
