// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_engagement_analytics.dart';

// **************************************************************************
// TypeAdapterGenerator
// **************************************************************************

class UserEngagementAnalyticsAdapter
    extends TypeAdapter<UserEngagementAnalytics> {
  @override
  final int typeId = 1;

  @override
  UserEngagementAnalytics read(BinaryReader reader) {
    final numOfFields = reader.readByte();
    final fields = <int, dynamic>{
      for (int i = 0; i < numOfFields; i++) reader.readByte(): reader.read(),
    };
    return UserEngagementAnalytics(
      homepage: fields[0] as int,
      discoverRestaurant: fields[1] as int,
      discoverItem: fields[2] as int,
      quickReview: fields[3] as int,
      searchPage: fields[4] as int,
      leaderBoard: fields[5] as int,
      itemReview: fields[6] as int,
      restaurantReviews: fields[7] as int,
      itemShare: fields[8] as int,
      restaurantShare: fields[9] as int,
      itemSearchPage: fields[10] as int,
      restaurantSearchPage: fields[11] as int,
    );
  }

  @override
  void write(BinaryWriter writer, UserEngagementAnalytics obj) {
    writer
      ..writeByte(12)
      ..writeByte(0)
      ..write(obj.homepage)
      ..writeByte(1)
      ..write(obj.discoverRestaurant)
      ..writeByte(2)
      ..write(obj.discoverItem)
      ..writeByte(3)
      ..write(obj.quickReview)
      ..writeByte(4)
      ..write(obj.searchPage)
      ..writeByte(5)
      ..write(obj.leaderBoard)
      ..writeByte(6)
      ..write(obj.itemReview)
      ..writeByte(7)
      ..write(obj.restaurantReviews)
      ..writeByte(8)
      ..write(obj.itemShare)
      ..writeByte(9)
      ..write(obj.restaurantShare)
      ..writeByte(10)
      ..write(obj.itemSearchPage)
      ..writeByte(11)
      ..write(obj.restaurantSearchPage);
  }

  @override
  int get hashCode => typeId.hashCode;

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is UserEngagementAnalyticsAdapter &&
          runtimeType == other.runtimeType &&
          typeId == other.typeId;
}
