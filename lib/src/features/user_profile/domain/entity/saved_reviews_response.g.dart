// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'saved_reviews_response.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class SavedReviewsResponseAdapter extends TypeAdapter<SavedReviewsResponse> {
  @override
  final int typeId = 30;

  @override
  SavedReviewsResponse read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return SavedReviewsResponse(
      draftId: fields[0] as String?,
      item: fields[1] as SavedReviewItemResponse?,
      createdAt: fields[2] as DateTime?,
      images: (fields[3] as List?)?.cast<DraftFileContent>(),
      videos: (fields[4] as List?)?.cast<DraftFileContent>(),
    );
  }

  @override
  void write(BinaryWriter writer, SavedReviewsResponse obj) {
    writer
      ..writeByte(5)
      ..writeByte(0)
      ..write(obj.draftId)
      ..writeByte(1)
      ..write(obj.item)
      ..writeByte(2)
      ..write(obj.createdAt)
      ..writeByte(3)
      ..write(obj.images)
      ..writeByte(4)
      ..write(obj.videos);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is SavedReviewsResponseAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}

class DraftFileContentAdapter extends TypeAdapter<DraftFileContent> {
  @override
  final int typeId = 49;

  @override
  DraftFileContent read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DraftFileContent(
      id: fields[0] as String?,
      url: fields[1] as String?,
      itemReviewId: fields[2] as String?,
      createdAt: fields[3] as DateTime?,
    );
  }

  @override
  void write(BinaryWriter writer, DraftFileContent obj) {
    writer
      ..writeByte(4)
      ..writeByte(0)
      ..write(obj.id)
      ..writeByte(1)
      ..write(obj.url)
      ..writeByte(2)
      ..write(obj.itemReviewId)
      ..writeByte(3)
      ..write(obj.createdAt);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DraftFileContentAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
