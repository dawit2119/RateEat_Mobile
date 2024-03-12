import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_favorite.g.dart';

@HiveType(typeId: 18)
class UserFavorite extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? userId;
  @HiveField(2)
  final String? date;
  @HiveField(3)
  final String? itemId;
  @HiveField(4)
  final DateTime? createdAt;
  @HiveField(5)
  final DateTime? updatedAt;
  @HiveField(6)
  final FavoriteItem? item;
  @HiveField(7)
  final FavoriteRestaurant? restaurant;

  const UserFavorite({
    this.id,
    this.userId,
    this.date,
    this.itemId,
    this.createdAt,
    this.updatedAt,
    this.item,
    this.restaurant,
  });

  @override
  List<Object?> get props =>
      [id, userId, date, itemId, createdAt, updatedAt, item];
}

@HiveType(typeId: 36)
class FavoriteItem extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final double? averageRating;
  @HiveField(3)
  final int? ratingCount;
  @HiveField(4)
  final double? price;
  @HiveField(5)
  final String? description;
  @HiveField(6)
  final String? imageUrl;
  @HiveField(7)
  final List<dynamic>? itemImages;
  @HiveField(8)
  final List<dynamic>? itemVideos;

  const FavoriteItem({
    this.id,
    this.name,
    this.averageRating,
    this.ratingCount,
    this.price,
    this.description,
    this.imageUrl,
    this.itemImages,
    this.itemVideos,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        averageRating,
        ratingCount,
        price,
        itemImages,
        itemVideos
      ];
}

@HiveType(typeId: 37)
class FavoriteRestaurant extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final double? averageRating;
  @HiveField(3)
  final double? averagePrice;
  @HiveField(4)
  final int? numberOfReviews;
  @HiveField(5)
  final double? averageItemsRating;
  @HiveField(6)
  final int? totalItemReviews;
  @HiveField(7)
  final List<dynamic>? restaurantImages;
  @HiveField(8)
  final String? imageUrl;

  const FavoriteRestaurant({
    required this.id,
    required this.name,
    required this.averageRating,
    required this.averagePrice,
    required this.numberOfReviews,
    required this.averageItemsRating,
    required this.totalItemReviews,
    required this.restaurantImages,
    required this.imageUrl,
  });

  @override
  List<Object?> get props => [
        id,
        name,
        averageRating,
        averagePrice,
        numberOfReviews,
        averageItemsRating,
        totalItemReviews,
        restaurantImages,
        imageUrl,
      ];
}
