// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'details_analytics_data.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class DetailsAnalyticsDataAdapter extends TypeAdapter<DetailsAnalyticsData> {
  @override
  final int typeId = 0;

  @override
  DetailsAnalyticsData read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return DetailsAnalyticsData(
      eventName: (fields[0] as String?) ?? '',
      eventData: fields[1] is Set
          ? (fields[1] as Set).map((e) => e.toString()).toSet()
          : fields[1] is List
              ? (fields[1] as List).map((e) => e.toString()).toSet()
              : <String>{},
    );
  }

  @override
  void write(BinaryWriter writer, DetailsAnalyticsData obj) {
    writer
      ..writeByte(2)
      ..writeByte(0)
      ..write(obj.eventName)
      ..writeByte(1)
      ..write(obj.eventData.toList());
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is DetailsAnalyticsDataAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
