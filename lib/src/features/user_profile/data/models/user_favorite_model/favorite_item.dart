import 'dart:convert';

import 'package:rateeat_mobile/src/core/utils/map_tag_to_image.dart';

import '../../../domain/domain.dart';

class FavoriteItemModel extends FavoriteItem {
  const FavoriteItemModel({
    super.id,
    super.name,
    super.averageRating,
    super.ratingCount,
    super.price,
    super.description,
    super.imageUrl,
    super.itemImages,
    super.itemVideos,
  });

  factory FavoriteItemModel.fromMap(Map<String, dynamic> data) =>
      FavoriteItemModel(
        id: data['id'] as String?,
        name: data['name'] as String?,
        averageRating: double.parse(
          (data['average_rating'].toDouble() ?? 0.0).toStringAsFixed(2),
        ),
        ratingCount: data['number_of_reviews'] ?? 0,
        price: double.parse(data['price'].toDouble().toStringAsFixed(2)),
        description: data['description'] as String?,
        imageUrl:
            (data['item_images'] != null && data['item_images'].isNotEmpty)
                ? data['item_images'][0]['url']
                : ImageMapping.getRestaurantImage(data),
        itemImages: data['item_images'] != null
            ? data['item_images'].map((item) => item["url"]).toList()
                as List<dynamic>?
            : [],
        itemVideos: data['item_videos'] != null
            ? data['item_videos'].map((item) => item["url"]).toList()
                as List<dynamic>?
            : [],
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'average_rating': averageRating,
        'number_of_reviews': ratingCount,
        'price': price,
        'description': description,
        'item_images': itemImages,
        'item_videos': itemVideos,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [FavoriteItemModel].
  factory FavoriteItemModel.fromJson(String data) {
    return FavoriteItemModel.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [FavoriteItemModel] to a JSON string.
  String toJson() => json.encode(toMap());

  FavoriteItemModel copyWith({
    String? id,
    String? name,
    double? averageRating,
    int? ratingCount,
    double? price,
    String? description,
    List<dynamic>? itemImages,
    List<dynamic>? itemVideos,
  }) {
    return FavoriteItemModel(
      id: id ?? this.id,
      name: name ?? this.name,
      averageRating: averageRating ?? this.averageRating,
      ratingCount: ratingCount ?? this.ratingCount,
      price: price ?? this.price,
      description: description ?? this.description,
      itemImages: itemImages ?? this.itemImages,
      itemVideos: itemVideos ?? this.itemVideos,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      name,
      averageRating,
      ratingCount,
      price,
      description,
      itemImages,
      itemVideos,
    ];
  }
}
