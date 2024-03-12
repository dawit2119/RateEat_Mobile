import 'package:equatable/equatable.dart';

import '../../../../../core/utils/map_tag_to_image.dart';
import 'item_image.dart';
import 'item_tag.dart';

class DiscoverRestaurantItem extends Equatable {
  final String? id;
  final String? name;
  final double? price;
  final double? averageRating;
  final int? numberOfReviews;
  final double? popularityIndex;
  final List<ItemTag>? itemTags;
  final List<ItemImage>? itemImages;
  const DiscoverRestaurantItem({
    this.id,
    this.name,
    this.price,
    this.averageRating,
    this.numberOfReviews,
    this.popularityIndex,
    this.itemTags,
    this.itemImages,
  });

  factory DiscoverRestaurantItem.fromJson(
          Map<String, dynamic> data, Map<String, dynamic> restaurant) =>
      DiscoverRestaurantItem(
        id: data['id'] as String?,
        name: data['name'] as String?,
        price: double.tryParse(data['price'].toString()) ?? 0.0,
        averageRating:
            double.tryParse(data['average_rating'].toString()) ?? 0.0,
        numberOfReviews: data['number_of_reviews'] as int?,
        popularityIndex:
            double.tryParse(data['popularity_index'].toString()) ?? 0.0,
        itemTags: (data['item_tags'] as List<dynamic>?)
            ?.map((e) => ItemTag.fromJson(e as Map<String, dynamic>))
            .toList(),
        itemImages: (data['item_images'] as List<dynamic>?)
            ?.map((e) => ItemImage.fromJson(e as Map<String, dynamic>))
            .toList()
          ?..add(
            ItemImage(
              url: ImageMapping.getItemFromRestaurantImage(
                restaurant,
              ),
            ),
          ),
      );

  DiscoverRestaurantItem copyWith({
    String? id,
    String? name,
    double? price,
    double? averageRating,
    int? numberOfReviews,
    double? popularityIndex,
    List<ItemTag>? itemTags,
    List<ItemImage>? itemImages,
  }) {
    return DiscoverRestaurantItem(
      id: id ?? this.id,
      name: name ?? this.name,
      price: price ?? this.price,
      averageRating: averageRating ?? this.averageRating,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      popularityIndex: popularityIndex ?? this.popularityIndex,
      itemTags: itemTags ?? this.itemTags,
      itemImages: itemImages ?? this.itemImages,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      price,
      averageRating,
      numberOfReviews,
      popularityIndex,
      itemTags,
      itemImages,
    ];
  }
}
