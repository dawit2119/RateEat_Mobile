// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_restaurant_review_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PopularRestaurantReviewResponseAdapter
    extends TypeAdapter<PopularRestaurantReviewResponse> {
  @override
  final int typeId = 47;

  @override
  PopularRestaurantReviewResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PopularRestaurantReviewResponse(
      id: fields[0] as String,
      rating: fields[1] as double?,
      comment: fields[2] as String?,
      upVote: fields[3] as int?,
      downVote: fields[4] as int?,
      visibility: fields[5] as bool?,
      createdAt: fields[6] as DateTime?,
      updatedAt: fields[7] as DateTime?,
      user: fields[8] as PopularRestaurantReviewerProfileResponse?,
      images: (fields[9] as List?)?.cast<dynamic>(),
      videos: (fields[10] as List?)?.cast<dynamic>(),
      voted: fields[11] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PopularRestaurantReviewResponse obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.rating)
      ..writeByte(2)
      ..write(obj.comment)
      ..writeByte(3)
      ..write(obj.upVote)
      ..writeByte(4)
      ..write(obj.downVote)
      ..writeByte(5)
      ..write(obj.visibility)
      ..writeByte(6)
      ..write(obj.createdAt)
      ..writeByte(7)
      ..write(obj.updatedAt)
      ..writeByte(8)
      ..write(obj.user)
      ..writeByte(9)
      ..write(obj.images)
      ..writeByte(10)
      ..write(obj.videos)
      ..writeByte(11)
      ..write(obj.voted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is PopularRestaurantReviewResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
