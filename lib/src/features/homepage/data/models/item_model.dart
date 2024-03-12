// ignore_for_file: overridden_fields

import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/categories.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

import '../../../../core/utils/map_tag_to_image.dart';

part 'item_model.g.dart';

@HiveType(typeId: 24)
class ItemModel extends Item {
  @override
  @HiveField(0)
  final String itemId;

  @override
  @HiveField(1)
  final String itemName;

  @override
  @HiveField(2)
  final int numberOfReviews;

  @override
  @HiveField(3)
  final double averageRating;

  @override
  @HiveField(4)
  final String description;

  @override
  @HiveField(5)
  final String restaurantName;

  @override
  @HiveField(6)
  final double price;

  @override
  @HiveField(7)
  final String imageUrl;

  @override
  @HiveField(8)
  final List<ItemMedia> itemImages;

  @override
  @HiveField(9)
  final List<ItemMedia> itemVideos;

  @override
  @HiveField(10)
  final List<String> tags;

  @override
  @HiveField(11)
  final String categoryId;

  @override
  @HiveField(12)
  final bool fasting;

  @override
  @HiveField(13)
  final DateTime? priceUpdatedAt;

  @override
  @HiveField(14)
  final DateTime? createdAt;

  @override
  @HiveField(15)
  final DateTime? updatedAt;

  @override
  @HiveField(16)
  final List<Ingredient> ingredients;

  @override
  @HiveField(17)
  final Categories? categories;

  @override
  @HiveField(18)
  final int minutes;

  @override
  @HiveField(19)
  final bool isOpen;

  @override
  @HiveField(20)
  final bool isFavorite;

  @override
  @HiveField(21)
  final String distance;

  @override
  @HiveField(22)
  final String walkingTime;

  @override
  @HiveField(23)
  final String ridingTime;
  @override
  @HiveField(24, defaultValue: 'ETB')
  final String currencyCode;

  // Constructor with default values for fields if not provided
  const ItemModel({
    required this.itemId,
    required this.itemName,
    required this.numberOfReviews,
    this.averageRating = 0.0,
    this.description = '',
    this.restaurantName = '',
    this.price = 0.0,
    this.imageUrl = '',
    this.itemImages = const [],
    this.itemVideos = const [],
    this.tags = const [],
    this.categoryId = '',
    this.fasting = false,
    this.priceUpdatedAt,
    this.createdAt,
    this.updatedAt,
    this.ingredients = const [],
    this.categories,
    this.minutes = 0,
    this.isOpen = true, // Assuming true as default
    this.isFavorite = false,
    this.distance = '0.0',
    this.walkingTime = '',
    this.ridingTime = '',
    this.currencyCode = 'ETB',
  }) : super(
          itemId: itemId,
          itemName: itemName,
          numberOfReviews: numberOfReviews,
          averageRating: averageRating,
          description: description,
          restaurantName: restaurantName,
          price: price,
          imageUrl: imageUrl,
          itemImages: itemImages,
          itemVideos: itemVideos,
          tags: tags,
          categoryId: categoryId,
          fasting: fasting,
          priceUpdatedAt: priceUpdatedAt,
          createdAt: createdAt,
          updatedAt: updatedAt,
          ingredients: ingredients,
          categories: categories,
          minutes: minutes,
          isOpen: isOpen,
          isFavorite: isFavorite,
          distance: distance,
          walkingTime: walkingTime,
          ridingTime: ridingTime,
          currencyCode: currencyCode,
        );

  factory ItemModel.fromEntity(Item item) {
    return ItemModel(
      itemId: item.itemId,
      itemName: item.itemName,
      numberOfReviews: item.numberOfReviews,
      averageRating: item.averageRating ?? 0.0,
      description: item.description ?? "",
      restaurantName: item.restaurantName ?? "",
      price: item.price ?? 0.0,
      imageUrl: item.imageUrl ?? "",
      itemImages: item.itemImages ?? [],
      itemVideos: item.itemVideos ?? [],
      tags: item.tags ?? [],
      categoryId: item.categoryId ?? "",
      fasting: item.fasting ?? false,
      priceUpdatedAt: item.priceUpdatedAt,
      createdAt: item.createdAt,
      updatedAt: item.updatedAt,
      ingredients: item.ingredients ?? [],
      categories: item.categories,
      minutes: item.minutes ?? 0,
      isOpen: item.isOpen ?? true,
      isFavorite: item.isFavorite ?? false,
      distance: item.distance,
      walkingTime: item.walkingTime,
      ridingTime: item.ridingTime,
      currencyCode: item.currencyCode,
    );
  }

  static String _resolveImageUrl(Map<String, dynamic> json) {
    if (json['item_images'] is List && (json['item_images'] as List).isNotEmpty) {
      for (final image in json['item_images']) {
        if (image is! Map) continue;
        final url = image['url']?.toString().trim();
        if (url == null || url.isEmpty) continue;
        if (image['is_leading'] == true) return url;
      }
      final firstUrl = json['item_images'][0]?['url']?.toString().trim();
      if (firstUrl != null && firstUrl.isNotEmpty) return firstUrl;
    }
    return ImageMapping.getRestaurantImage(json);
  }

  factory ItemModel.fromCacheJson(json) {
    return ItemModel(
      itemId: json['itemId'] ?? '',
      itemName: json['itemName'] ?? '',
      numberOfReviews: json['numberOfReviews'] ?? 0,
      averageRating: json['averageRating'] ?? 0.0,
      price: json['price'] ?? 0.0,
      imageUrl: json['imageUrl'] ?? '',
      itemImages: json['itemImages'] != null
          ? List<ItemMedia>.from(
              (json['itemImages'] as List).map((e) => ItemMedia.fromJson(e)))
          : [],
      itemVideos: json['itemVideos'] != null
          ? List<ItemMedia>.from(
              (json['itemVideos'] as List).map((e) => ItemMedia.fromJson(e)))
          : [],
      restaurantName: json['restaurantName'] ?? '',
      tags: json['tags'] != null ? List<String>.from(json['tags']) : [],
      categoryId: json['categoryId'] ?? '',
      fasting: json['fasting'] ?? false,
      priceUpdatedAt: json['priceUpdatedAt'] != null
          ? DateTime.parse(json['priceUpdatedAt'])
          : null,
      createdAt:
          json['createdAt'] != null ? DateTime.parse(json['createdAt']) : null,
      updatedAt:
          json['updatedAt'] != null ? DateTime.parse(json['updatedAt']) : null,
      ingredients: json['ingredients'] != null
          ? List<Ingredient>.from(
              json['ingredients'].map((x) => Ingredient.fromJson(x)))
          : [],
      categories: json['categories'] != null
          ? Categories.fromMap(json['categories'])
          : null,
      minutes: json['minutes'] ?? 0,
      isOpen: json['isOpen'] ?? false,
      isFavorite: json['isFavorite'] ?? false,
      distance: json['distance'].toString(),
      walkingTime: json['walkingTime']?.toString() ?? "",
      ridingTime: json['ridingTime']?.toString() ?? "",
      description: json['description'] ?? '',
      currencyCode: json['currencyCode']?.toString() ?? "CAF",
    );
  }

  factory ItemModel.fromJson(json) {
    DateTime now = DateTime.now();
    int currentHour = now.hour;

    bool isOpen = (currentHour >= 20 ||
            currentHour < 7 ||
            (currentHour == 7 && now.minute < 30))
        ? false
        : true;

    return ItemModel(
        itemId: json['id'] ?? '',
        itemName: json['name'] ?? '',
        numberOfReviews: json['number_of_reviews'] ?? 0,
        description: json["description"] ?? "",
        averageRating: (json['average_rating']?.toDouble() ?? 0.0),
        price: json['price']?.toDouble() ?? 0.0,
        imageUrl: _resolveImageUrl(Map<String, dynamic>.from(json)),
        itemImages: json['item_images'] != null
            ? (json['item_images'] as List)
                .map((image) =>
                    ItemMedia.fromJson(image as Map<String, dynamic>))
                .toList()
            : [],
        itemVideos: json['item_videos'] != null
            ? (json['item_videos'] as List)
                .map((video) =>
                    ItemMedia.fromJson(video as Map<String, dynamic>))
                .toList()
            : [],
        restaurantName:
            json['categories'] != null && json['categories']['menu'] != null
                ? json['categories']['menu']['restaurant']['name']
                : '',
        tags: json['item_tags'] != null
            ? List<String>.from(json['item_tags'].map((tag) => tag['name']))
            : [],
        categoryId: json["category_id"] ?? "",
        fasting: json["fasting"] ?? false,
        priceUpdatedAt: json["price_updated_at"] != null
            ? DateTime.parse(json["price_updated_at"])
            : null,
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : null,
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : null,
        ingredients: json["ingredients"] != null
            ? List<Ingredient>.from(
                json["ingredients"].map((x) => Ingredient.fromJson(x)))
            : [],
        categories: json['categories'] != null
            ? Categories.fromMap(json["categories"])
            : null,
        minutes: json['minutes'] ?? 0,
        isOpen: json['isOpen'] ?? isOpen,
        isFavorite: json['isFavorite'] ?? false,
        distance:
            json['distance'] != null ? json['distance'].toString() : "0.0",
        walkingTime: json['walking_time'] ?? "0.0",
        currencyCode: (json['categories'] != null &&
                json['categories']['menu'] != null &&
                json['categories']['menu']['restaurant'] != null)
            ? json['categories']['menu']['restaurant']['currency']
                    ?.toString() ??
                'ETB'
            : 'USD',
        ridingTime: json['riding_time'] ?? "0.0");
  }

  // Copy method to create a new instance with updated values
  @override
  ItemModel copyWith({
    String? itemId,
    String? itemName,
    int? numberOfReviews,
    double? averageRating,
    String? description,
    String? restaurantName,
    double? price,
    String? imageUrl,
    List<ItemMedia>? itemImages,
    List<ItemMedia>? itemVideos,
    List<String>? tags,
    String? categoryId,
    bool? fasting,
    DateTime? priceUpdatedAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<Ingredient>? ingredients,
    Categories? categories,
    int? minutes,
    bool? isOpen,
    bool? isFavorite,
    String? distance,
    String? walkingTime,
    String? ridingTime,
    String? currencyCode,
  }) {
    return ItemModel(
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      averageRating: averageRating ?? this.averageRating,
      description: description ?? this.description,
      restaurantName: restaurantName ?? this.restaurantName,
      price: price ?? this.price,
      imageUrl: imageUrl ?? this.imageUrl,
      itemImages: itemImages ?? this.itemImages,
      itemVideos: itemVideos ?? this.itemVideos,
      tags: tags ?? this.tags,
      categoryId: categoryId ?? this.categoryId,
      fasting: fasting ?? this.fasting,
      priceUpdatedAt: priceUpdatedAt ?? this.priceUpdatedAt,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      ingredients: ingredients ?? this.ingredients,
      categories: categories ?? this.categories,
      minutes: minutes ?? this.minutes,
      isOpen: isOpen ?? this.isOpen,
      isFavorite: isFavorite ?? this.isFavorite,
      distance: distance ?? this.distance,
      walkingTime: walkingTime ?? this.walkingTime,
      ridingTime: ridingTime ?? this.ridingTime,
      currencyCode: currencyCode ?? this.currencyCode,
    );
  }

  // Convert the model back to JSON
  Map<String, dynamic> toJson() {
    return {
      'id': itemId,
      'name': itemName,
      'number_of_reviews': numberOfReviews,
      'restaurant_name': restaurantName,
      'description': description,
      'average_rating': averageRating,
      'price': price,
      'image_url': imageUrl,
      'item_images': itemImages.map((x) => x.toJson()).toList(),
      'item_videos': itemVideos.map((x) => x.toJson()).toList(),
      'item_tags': tags,
      'category_id': categoryId,
      'fasting': fasting,
      'price_updated_at': priceUpdatedAt?.toIso8601String(),
      'createdAt': createdAt?.toIso8601String(),
      'updatedAt': updatedAt?.toIso8601String(),
      'ingredients': ingredients.map((x) => x.toJson()).toList(),
      'categories': categories?.toJson(),
      'minutes': minutes,
      'isOpen': isOpen,
      'isFavorite': isFavorite,
      'distance': distance,
      'walking_time': walkingTime,
      'riding_time': ridingTime,
      'currencyCode': currencyCode,
    };
  }
}
