// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_item_reviews_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PopularItemReviewsResponseAdapter
    extends TypeAdapter<PopularItemReviewsResponse> {
  @override
  final int typeId = 38;

  @override
  PopularItemReviewsResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PopularItemReviewsResponse(
      ratingsCount: (fields[0] as List).cast<int>(),
      reviews: (fields[1] as List).cast<PopularItemReviewResponse>(),
      averageRating: fields[2] as double,
      numberOfReviews: fields[3] as int,
    );
  }

  @override
  void write(BinaryWriter writer, PopularItemReviewsResponse obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.ratingsCount)
      ..writeByte(1)
      ..write(obj.reviews)
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
      other is PopularItemReviewsResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
