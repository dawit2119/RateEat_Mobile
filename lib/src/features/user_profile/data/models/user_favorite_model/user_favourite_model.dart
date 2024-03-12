import 'dart:convert';

import 'package:rateeat_mobile/src/features/user_profile/data/models/user_favorite_model/favorite_item.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/user_favorite_model/favorite_restaurant_model.dart';

import '../../../domain/domain.dart';

class UserFavoriteModel extends UserFavorite {
  const UserFavoriteModel({
    super.id,
    super.userId,
    super.date,
    super.itemId,
    super.createdAt,
    super.updatedAt,
    super.item,
    super.restaurant,
  });

  factory UserFavoriteModel.fromMap(Map<String, dynamic> data) =>
      UserFavoriteModel(
        id: data['id'] as String?,
        userId: data['user_id'] as String?,
        date: data['date'] as String?,
        itemId: data['item_id'] as String?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        item: data['item'] == null
            ? null
            : FavoriteItemModel.fromMap(data['item'] as Map<String, dynamic>),
        restaurant: data['restaurant'] == null
            ? null
            : FavoriteRestaurantModel.fromMap(
                data['restaurant'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'date': date,
        'item_id': itemId,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'item': (item as FavoriteItemModel).toMap(),
        'restaurant': (restaurant as FavoriteRestaurantModel).toMap(),
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [UserFavoriteModel].
  factory UserFavoriteModel.fromJson(String data) {
    return UserFavoriteModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [UserFavoriteModel] to a JSON string.
  String toJson() => json.encode(toMap());

  UserFavoriteModel copyWith({
    String? id,
    String? userId,
    String? date,
    String? itemId,
    DateTime? createdAt,
    DateTime? updatedAt,
    FavoriteItemModel? item,
    FavoriteRestaurantModel? restaurant,
  }) {
    return UserFavoriteModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      date: date ?? this.date,
      itemId: itemId ?? this.itemId,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      item: item ?? this.item,
      restaurant: restaurant ?? this.restaurant,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      date,
      itemId,
      createdAt,
      updatedAt,
      item,
      restaurant,
    ];
  }
}
