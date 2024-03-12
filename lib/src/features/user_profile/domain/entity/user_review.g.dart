// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_review.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserReviewAdapter extends TypeAdapter<UserReview> {
  @override
  final int typeId = 16;

  @override
  UserReview read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserReview(
      id: fields[0] as String?,
      userId: fields[1] as String?,
      rating: fields[2] as double?,
      comment: fields[3] as String?,
      upVote: fields[4] as int?,
      downVote: fields[5] as int?,
      visibility: fields[6] as bool?,
      createdAt: fields[7] as DateTime?,
      updatedAt: fields[8] as DateTime?,
      reviewSubject: fields[9] as ReviewSubject?,
      images: (fields[10] as List).cast<ReviewMedia>(),
      voted: fields[12] as int?,
    );
  }

  @override
  void write(BinaryWriter writer, UserReview obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.userId)
      ..writeByte(2)
      ..write(obj.rating)
      ..writeByte(3)
      ..write(obj.comment)
      ..writeByte(4)
      ..write(obj.upVote)
      ..writeByte(5)
      ..write(obj.downVote)
      ..writeByte(6)
      ..write(obj.visibility)
      ..writeByte(7)
      ..write(obj.createdAt)
      ..writeByte(8)
      ..write(obj.updatedAt)
      ..writeByte(9)
      ..write(obj.reviewSubject)
      ..writeByte(10)
      ..write(obj.images)
      ..writeByte(12)
      ..write(obj.voted);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserReviewAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewSubjectAdapter extends TypeAdapter<ReviewSubject> {
  @override
  final int typeId = 28;

  @override
  ReviewSubject read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewSubject(
      id: fields[0] as String?,
      name: fields[1] as String?,
      isItem: fields[2] as bool?,
      imageUrl: fields[3] as String?,
      itemImages: (fields[4] as List?)?.cast<dynamic>(),
      itemVideos: (fields[5] as List?)?.cast<dynamic>(),
    );
  }

  @override
  void write(BinaryWriter writer, ReviewSubject obj) {
    writer
      ..writeByte(6)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.name)
      ..writeByte(2)
      ..write(obj.isItem)
      ..writeByte(3)
      ..write(obj.imageUrl)
      ..writeByte(4)
      ..write(obj.itemImages)
      ..writeByte(5)
      ..write(obj.itemVideos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewSubjectAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class ReviewMediaAdapter extends TypeAdapter<ReviewMedia> {
  @override
  final int typeId = 29;

  @override
  ReviewMedia read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return ReviewMedia(
      id: fields[0] as String?,
      url: fields[1] as String?,
    );
  }

  @override
  void write(BinaryWriter writer, ReviewMedia obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is ReviewMediaAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
