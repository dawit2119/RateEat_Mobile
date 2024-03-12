// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'restaurant.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class RestaurantAdapter extends TypeAdapter<Restaurant> {
  @override
  final int typeId = 9;

  @override
  Restaurant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return Restaurant(
      id: fields[0] as String?,
      name: fields[1] as String?,
      openingHour: fields[2] as String?,
      closingHour: fields[3] as String?,
      isOpen: fields[4] as bool?,
      averagePrice: fields[5] as double?,
      averageRating: fields[6] as double?,
      numberOfReviews: fields[7] as int?,
      popularityIndex: fields[8] as int?,
      userId: fields[12] as String?,
      createdAt: fields[13] as DateTime?,
      updatedAt: fields[14] as DateTime?,
      restaurantTags: (fields[15] as List?)?.cast<RestaurantTag>(),
      restaurantImages: (fields[16] as List?)?.cast<RestaurantMedia>(),
      restaurantVideos: (fields[17] as List?)?.cast<RestaurantMedia>(),
      restaurantLocations: (fields[18] as List?)?.cast<RestaurantLocation>(),
      restaurantPhoneNumbers:
          (fields[19] as List?)?.cast<RestaurantPhoneNumber>(),
      lastPriceUpdate: fields[24] as DateTime?,
      distance: fields[9] as String,
      walkingTime: fields[10] as String,
      ridingTime: fields[11] as String,
      doShowAvailabilityAlert: fields[20] as bool,
      currencyCode: fields[21] as String,
      restaurantOrderServiceAvailable: fields[22] as bool,
      restaurantOrderServiceOnline: fields[23] as bool,
      isFavorite: fields[25] as bool?,
    );
  }

  @override
  void write(BinaryWriter writer, Restaurant obj) {
    writer
      ..writeByte(26)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.openingHour)
      ..writeByte(3)
      ..write(obj.closingHour)
      ..writeByte(4)
      ..write(obj.isOpen)
      ..writeByte(5)
      ..write(obj.averagePrice)
      ..writeByte(6)
      ..write(obj.averageRating)
      ..writeByte(7)
      ..write(obj.numberOfReviews)
      ..writeByte(8)
      ..write(obj.popularityIndex)
      ..writeByte(9)
      ..write(obj.distance)
      ..writeByte(10)
      ..write(obj.walkingTime)
      ..writeByte(11)
      ..write(obj.ridingTime)
      ..writeByte(12)
      ..write(obj.userId)
      ..writeByte(13)
      ..write(obj.createdAt)
      ..writeByte(14)
      ..write(obj.updatedAt)
      ..writeByte(15)
      ..write(obj.restaurantTags)
      ..writeByte(16)
      ..write(obj.restaurantImages)
      ..writeByte(17)
      ..write(obj.restaurantVideos)
      ..writeByte(18)
      ..write(obj.restaurantLocations)
      ..writeByte(19)
      ..write(obj.restaurantPhoneNumbers)
      ..writeByte(20)
      ..write(obj.doShowAvailabilityAlert)
      ..writeByte(21)
      ..write(obj.currencyCode)
      ..writeByte(22)
      ..write(obj.restaurantOrderServiceAvailable)
      ..writeByte(23)
      ..write(obj.restaurantOrderServiceOnline)
      ..writeByte(24)
      ..write(obj.lastPriceUpdate)
      ..writeByte(25)
      ..write(obj.isFavorite);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RestaurantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RestaurantMediaAdapter extends TypeAdapter<RestaurantMedia> {
  @override
  final int typeId = 11;

  @override
  RestaurantMedia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RestaurantMedia(
      id: fields[0] as String,
      url: fields[1] as String,
      isLeading: fields[2] as bool,
    );
  }

  @override
  void write(BinaryWriter writer, RestaurantMedia obj) {
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
      other is RestaurantMediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
