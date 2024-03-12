import 'dart:convert';

import 'package:rateeat_mobile/src/features/search_result/domain/entities/restaurant_item.dart';

import '../../../homepage/domain/entities/categories.dart';

class RestaurantItemModel extends RestaurantItem {
  const RestaurantItemModel({
    super.id,
    super.name,
    super.description,
    super.numberOfReviews,
    super.restaurantName,
    super.itemTags,
    super.averageRating,
    super.price,
    super.categoryId,
    super.categories,
    super.fasting,
    super.popularityIndex,
    super.createdAt,
    super.updatedAt,
  });

  factory RestaurantItemModel.fromMap(Map<String, dynamic> data) =>
      RestaurantItemModel(
        id: data['id'] as String?,
        name: data['name'] as String?,
        description: data['description'] as String?,
        numberOfReviews: data['number_of_reviews'] as int?,
        restaurantName: data[''],
        itemTags: (data['item_tags'] != null)
            ? List<ItemTag>.from(
                data['item_tags'].map((x) => ItemTag.fromJson(x)))
            : [],
        averageRating: data['average_rating'].toDouble(),
        price: data['price'].toDouble(),
        categoryId: data['category_id'] as String?,
        categories: Categories.fromMap(data["categories"]),
        fasting: data['fasting'] as bool?,
        popularityIndex: data['popularity_index'] as int?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'description': description,
        'number_of_reviews': numberOfReviews,
        'item_tags': itemTags,
        'average_rating': averageRating,
        'price': price,
        'category_id': categoryId,
        'fasting': fasting,
        'popularity_index': popularityIndex,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
      };

  /// dart:convert
  ///
  /// Parses the string and returns the resulting Json object as [ItemModel].
  factory RestaurantItemModel.fromJson(String data) {
    return RestaurantItemModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// dart:convert
  ///
  /// Converts [RestaurantItemModel] to a JSON string.
  String toJson() => json.encode(toMap());

  RestaurantItemModel copyWith({
    String? id,
    String? name,
    String? description,
    int? numberOfReviews,
    // List<ItemTag>? itemTags,
    double? averageRating,
    double? price,
    String? categoryId,
    bool? fasting,
    int? popularityIndex,
    DateTime? createdAt,
    DateTime? updatedAt,
  }) {
    return RestaurantItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      description: description ?? this.description,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      itemTags: itemTags,
      averageRating: averageRating ?? this.averageRating,
      price: price ?? this.price,
      categoryId: categoryId ?? this.categoryId,
      fasting: fasting ?? this.fasting,
      popularityIndex: popularityIndex ?? this.popularityIndex,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props {
    return [
      id,
      name,
      description,
      numberOfReviews,
      itemTags,
      averageRating,
      price,
      categoryId,
      fasting,
      popularityIndex,
      createdAt,
      updatedAt,
    ];
  }
}
