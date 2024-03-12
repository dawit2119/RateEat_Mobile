// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_item_reviewer_profile_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class PopularItemReviewerProfileResponseAdapter
    extends TypeAdapter<PopularItemReviewerProfileResponse> {
  @override
  final int typeId = 40;

  @override
  PopularItemReviewerProfileResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return PopularItemReviewerProfileResponse(
      id: fields[0] as String,
      firstName: fields[1] as String,
      lastName: fields[2] as String,
      image: fields[3] as String,
      verified: fields[4] as int?,
      numberOfReviews: fields[5] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, PopularItemReviewerProfileResponse obj) {
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
      other is PopularItemReviewerProfileResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
