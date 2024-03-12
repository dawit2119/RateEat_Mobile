import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/categories.dart';

part 'item.g.dart';

@HiveType(typeId: 6)
class Item extends Equatable {
  @HiveField(0)
  final String itemId;

  @HiveField(1)
  final String itemName;

  @HiveField(2)
  final int numberOfReviews;

  @HiveField(3)
  final String? description;

  @HiveField(4)
  final double? averageRating;

  @HiveField(5)
  final double? price;

  @HiveField(6)
  final String? restaurantName;

  @HiveField(7)
  final String? imageUrl;

  @HiveField(8)
  final List<ItemMedia>? itemImages;

  @HiveField(9)
  final List<ItemMedia>? itemVideos;

  @HiveField(10)
  final List<String>? tags;

  @HiveField(11)
  final String? categoryId;

  @HiveField(12)
  final bool? fasting;

  @HiveField(13)
  final DateTime? priceUpdatedAt;

  @HiveField(14)
  final DateTime? createdAt;

  @HiveField(15)
  final DateTime? updatedAt;

  @HiveField(16)
  final List<Ingredient>? ingredients;

  @HiveField(17)
  final int? minutes;

  @HiveField(18)
  final bool? isOpen;

  @HiveField(19)
  final bool? isFavorite;

  @HiveField(20)
  final String walkingTime;

  @HiveField(21)
  final String ridingTime;

  @HiveField(22)
  final String distance;
  @HiveField(23, defaultValue: 'ETB')
  final String currencyCode;

  final Categories? categories;
  const Item({
    required this.itemId,
    required this.itemName,
    required this.numberOfReviews,
    this.description,
    this.averageRating,
    this.price,
    this.restaurantName,
    this.imageUrl,
    this.itemImages,
    this.itemVideos,
    this.tags,
    this.categoryId,
    this.fasting,
    this.priceUpdatedAt,
    this.createdAt,
    this.updatedAt,
    this.ingredients,
    this.categories,
    this.minutes,
    this.isOpen,
    this.isFavorite,
    this.distance = "",
    this.ridingTime = "",
    this.walkingTime = "",
    this.currencyCode = 'ETB',
  });

  @override
  List<Object?> get props => [
        itemId,
        itemName,
        numberOfReviews,
        description,
        averageRating,
        price,
        restaurantName,
        imageUrl,
        itemImages,
        itemVideos,
        tags,
        categoryId,
        fasting,
        priceUpdatedAt,
        createdAt,
        updatedAt,
        ingredients,
        categories,
        minutes,
        isOpen,
        isFavorite,
        distance,
        ridingTime,
        walkingTime,
        currencyCode,
      ];
  Map<String, dynamic> toMap() => {
        "itemId": itemId,
        "itemName": itemName,
        "numberOfReviews": numberOfReviews,
        "averageRating": averageRating,
        "description": description,
        "price": price,
        "restaurantName": restaurantName,
        "imageUrl": imageUrl,
        "itemImages": itemImages?.map((e) => e.toJson()).toList(),
        "itemVideos": itemVideos?.map((e) => e.toJson()).toList(),
        "tags": tags,
        "categoryId": categoryId,
        "fasting": fasting,
        "priceUpdatedAt": priceUpdatedAt?.toIso8601String(),
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
        "ingredients": ingredients,
        "categories": categories,
        "minutes": minutes,
        "isOpen": isOpen,
        "isFavorite": isFavorite,
        "distance": distance,
        "ridingTime": ridingTime,
        "walkingTime": walkingTime,
        "currencyCode": currencyCode,
      };
  String toStringJson() => json.encode(toMap());

  Item copyWith({
    String? itemId,
    String? itemName,
    int? numberOfReviews,
    double? averageRating,
    String? description,
    double? price,
    String? restaurantName,
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
    String? ridingTime,
    String? walkingTime,
    String? currencyCode,
  }) {
    return Item(
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      averageRating: averageRating ?? this.averageRating,
      numberOfReviews: numberOfReviews ?? this.numberOfReviews,
      description: description ?? this.description,
      price: price ?? this.price,
      restaurantName: restaurantName ?? this.restaurantName,
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
}

@HiveType(typeId: 7)
class Ingredient extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String name;

  @HiveField(2)
  final String? itemId;

  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Ingredient({
    required this.id,
    required this.name,
    this.itemId,
    this.createdAt,
    this.updatedAt,
  });

  factory Ingredient.fromJson(Map<String, dynamic> json) => Ingredient(
        id: json["id"],
        name: json["name"],
        itemId: json["item_id"] ?? "",
        createdAt: json["createdAt"] != null
            ? DateTime.parse(json["createdAt"])
            : DateTime.now(),
        updatedAt: json["updatedAt"] != null
            ? DateTime.parse(json["updatedAt"])
            : DateTime.now(),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "item_id": itemId,
        "createdAt": createdAt?.toIso8601String(),
        "updatedAt": updatedAt?.toIso8601String(),
      };

  @override
  List<Object?> get props => [id, name, itemId, createdAt, updatedAt];
}

@HiveType(typeId: 8)
class ItemMedia extends Equatable {
  @HiveField(0)
  final String id;

  @HiveField(1)
  final String url;

  @HiveField(2)
  final bool? isLeading;

  const ItemMedia({
    required this.id,
    required this.url,
    this.isLeading = false,
  });

  ItemMedia copyWith({
    String? id,
    String? url,
    bool? isLeading,
  }) =>
      ItemMedia(
        id: id ?? this.id,
        url: url ?? this.url,
        isLeading: isLeading ?? this.isLeading,
      );

  @override
  List<Object?> get props => [id, url, isLeading];

  factory ItemMedia.fromJson(Map<String, dynamic> json) => ItemMedia(
        id: json["id"] ?? "",
        url: json["url"] ?? "",
        isLeading: json["is_leading"] ?? false,
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "url": url,
        "is_leading": isLeading,
      };
}
