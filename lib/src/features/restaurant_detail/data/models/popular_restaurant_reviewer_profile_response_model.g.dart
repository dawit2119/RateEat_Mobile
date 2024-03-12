// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_restaurant_reviewer_profile_response_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PopularRestaurantReviewerProfileResponseModelAdapter
    extends TypeAdapter<PopularRestaurantReviewerProfileResponseModel> {
  @override
  final int typeId = 42;

  @override
  PopularRestaurantReviewerProfileResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PopularRestaurantReviewerProfileResponseModel(
      id: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      image: fields[3] as String,
      verified: fields[4] as int?,
      numberOfReviews: fields[5] as int?,
    );
  }

  @override
  void write(
      BinaryWriter writer, PopularRestaurantReviewerProfileResponseModel obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.firstName)
      ..writeByte(2)
      ..write(obj.lastName)
      ..writeByte(3)
      ..write(obj.image)
      ..writeByte(4)
      ..write(obj.verified)
      ..writeByte(5)
      ..write(obj.numberOfReviews);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PopularRestaurantReviewerProfileResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
