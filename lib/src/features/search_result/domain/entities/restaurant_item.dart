import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/categories.dart';

class RestaurantItem extends Equatable {
  final String? id;
  final String? name;
  final String? description;
  final int? numberOfReviews;
  final String? restaurantName;
  final List<ItemTag>? itemTags;
  final double? averageRating;
  final double? price;
  final String? categoryId;
  final Categories? categories;
  final bool? fasting;
  final int? popularityIndex;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const RestaurantItem({
    this.id,
    this.name,
    this.description,
    this.numberOfReviews,
    this.restaurantName,
    this.itemTags,
    this.averageRating,
    this.price,
    this.categoryId,
    this.categories,
    this.fasting,
    this.popularityIndex,
    this.createdAt,
    this.updatedAt,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [];
}

class ItemTag {
  String id;
  String name;

  ItemTag({
    required this.id,
    required this.name,
  });

  factory ItemTag.fromJson(Map<String, dynamic> data) => ItemTag(
        id: data["id"],
        name: data["name"],
      );
}
