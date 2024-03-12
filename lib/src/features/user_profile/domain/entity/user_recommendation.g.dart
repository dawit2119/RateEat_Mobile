// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_recommendation.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserRecommendationAdapter extends TypeAdapter<UserRecommendation> {
  @override
  final int typeId = 20;

  @override
  UserRecommendation read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserRecommendation(
      item: fields[0] as RecommendationItem?,
      restaurant: fields[1] as RecommendationRestaurant?,
      recommendationContent: fields[2] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, UserRecommendation obj) {
    writer
      ..writeByte(3)
      ..writeByte(0)
      ..write(obj.item)
      ..writeByte(1)
      ..write(obj.restaurant)
      ..writeByte(2)
      ..write(obj.recommendationContent);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserRecommendationAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecommendationRestaurantAdapter
    extends TypeAdapter<RecommendationRestaurant> {
  @override
  final int typeId = 21;

  @override
  RecommendationRestaurant read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecommendationRestaurant(
      imageUrl: fields[3] as String,
      name: fields[0] as String,
      review: fields[1] as double,
      id: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecommendationRestaurant obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.review)
      ..writeByte(2)
      ..write(obj.id)
      ..writeByte(3)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationRestaurantAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class RecommendationItemAdapter extends TypeAdapter<RecommendationItem> {
  @override
  final int typeId = 22;

  @override
  RecommendationItem read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return RecommendationItem(
      imageUrl: fields[4] as String,
      id: fields[3] as String,
      name: fields[0] as String,
      review: fields[1] as double,
      restaurantName: fields[2] as String,
    );
  }

  @override
  void write(BinaryWriter writer, RecommendationItem obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.name)
      ..writeByte(1)
      ..write(obj.review)
      ..writeByte(2)
      ..write(obj.restaurantName)
      ..writeByte(3)
      ..write(obj.id)
      ..writeByte(4)
      ..write(obj.imageUrl);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is RecommendationItemAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
