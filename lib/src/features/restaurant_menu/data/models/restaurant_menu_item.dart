// ignore_for_file: overridden_fields
// ? TODO: move the hive up to the entity layer

import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/core/utils/map_tag_to_image.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/menu_item.dart';

part 'restaurant_menu_item_model.g.dart';

@HiveType(typeId: 27)
class RestaurantMenuItemModel extends RestaurantMenuItem {
  @override
  @HiveField(0)
  final String? id;
  @override
  @HiveField(1)
  final String? name;
  @override
  @HiveField(2)
  final String? description;
  @override
  @HiveField(3)
  final String? imageUrl;
  @override
  @HiveField(4)
  final int? numberOfReviews;
  @override
  @HiveField(5)
  final double? averageRating;
  @override
  @HiveField(6)
  final double? price;

  const RestaurantMenuItemModel({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.numberOfReviews,
    this.averageRating,
    this.price,
  }) : super(
          id: id,
          name: name,
          description: description,
          imageUrl: imageUrl,
          numberOfReviews: numberOfReviews,
          averageRating: averageRating,
          price: price,
        );

  @override
  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'numberOfReviews': numberOfReviews,
      'averageRating': averageRating,
      'price': price,
    };
  }

  factory RestaurantMenuItemModel.fromJson(Map<String, dynamic> json) {
    return RestaurantMenuItemModel(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      imageUrl: (json['item_images'] != null && json['item_images'].isNotEmpty)
          ? json['item_images'][0]['url']
          : ImageMapping.getRestaurantImage(json),
      numberOfReviews: json['number_of_reviews'] as int?,
      averageRating: (json['average_rating'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
    );
  }
}
