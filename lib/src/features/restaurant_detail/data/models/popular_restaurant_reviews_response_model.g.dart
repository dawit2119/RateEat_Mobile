// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_restaurant_reviews_response_model.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PopularRestaurantReviewsResponseModelAdapter
    extends TypeAdapter<PopularRestaurantReviewsResponseModel> {
  @override
  final int typeId = 23;

  @override
  PopularRestaurantReviewsResponseModel read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PopularRestaurantReviewsResponseModel(
      reviews: (fields[0] as List).cast<PopularRestaurantReviewResponseModel>(),
      ratingsCount: (fields[1] as List).cast<int>(),
      averageRating: fields[2] as double,
      numberOfReviews: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PopularRestaurantReviewsResponseModel obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.reviews)
      ..writeByte(1)
      ..write(obj.ratingsCount)
      ..writeByte(2)
      ..write(obj.averageRating)
      ..writeByte(3)
      ..write(obj.numberOfReviews);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PopularRestaurantReviewsResponseModelAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
