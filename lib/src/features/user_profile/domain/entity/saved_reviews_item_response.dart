import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'saved_reviews_item_response.g.dart';

@HiveType(typeId: 31)
class SavedReviewItemResponse extends Equatable {
  @HiveField(0)
  final String itemId;
  @HiveField(1)
  final String itemName;
  @HiveField(2)
  final double? price;
  @HiveField(3)
  final String? restaurantName;
  @HiveField(4)
  final String? imageUrl;
  @HiveField(5)
  final List<dynamic>? itemImages;
  @HiveField(6)
  final DateTime? createdAt;
  @HiveField(7)
  final ItemCategoriesModel? categories;
  const SavedReviewItemResponse({
    required this.itemId,
    required this.itemName,
    this.price,
    this.restaurantName,
    this.imageUrl,
    this.itemImages,
    this.createdAt,
    this.categories,
  });

  @override
  List<Object?> get props => [
        itemId,
        itemName,
        price,
        restaurantName,
        imageUrl,
        itemImages,
        createdAt,
        categories,
      ];

  SavedReviewItemResponse copyWith({
    String? itemId,
    String? itemName,
    double? price,
    String? restaurantName,
    String? imageUrl,
    List<dynamic>? itemImages,
    DateTime? createdAt,
    ItemCategoriesModel? categories,
  }) {
    return SavedReviewItemResponse(
      itemId: itemId ?? this.itemId,
      itemName: itemName ?? this.itemName,
      price: price ?? this.price,
      restaurantName: restaurantName ?? this.restaurantName,
      imageUrl: imageUrl ?? this.imageUrl,
      itemImages: itemImages ?? this.itemImages,
      createdAt: createdAt ?? this.createdAt,
      categories: categories ?? this.categories,
    );
  }
}

@HiveType(typeId: 32)
class ItemCategoriesModel extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final ItemMenuModel? menu;

  const ItemCategoriesModel({this.id, this.name, this.menu});

  factory ItemCategoriesModel.fromJson(Map<String, dynamic> data) =>
      ItemCategoriesModel(
        id: data['id'] as String?,
        name: data['name'] as String?,
        menu: data['menu'] == null
            ? null
            : ItemMenuModel.fromJson(data['menu'] as Map<String, dynamic>),
      );

  ItemCategoriesModel copyWith({
    String? id,
    String? name,
    ItemMenuModel? menu,
  }) {
    return ItemCategoriesModel(
      id: id ?? this.id,
      name: name ?? this.name,
      menu: menu ?? this.menu,
    );
  }

  @override
  List<Object?> get props => [id, name, menu];
}

@HiveType(typeId: 33)
class ItemMenuModel extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final ItemRestaurantModel? restaurant;

  const ItemMenuModel({this.id, this.restaurant});

  factory ItemMenuModel.fromJson(Map<String, dynamic> data) => ItemMenuModel(
        id: data['id'] as String?,
        restaurant: data['restaurant'] == null
            ? null
            : ItemRestaurantModel.fromJson(
                data['restaurant'] as Map<String, dynamic>),
      );

  ItemMenuModel copyWith({
    String? id,
    ItemRestaurantModel? restaurant,
  }) {
    return ItemMenuModel(
      id: id ?? this.id,
      restaurant: restaurant ?? this.restaurant,
    );
  }

  @override
  List<Object?> get props => [id, restaurant];
}

@HiveType(typeId: 34)
class ItemRestaurantModel {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? name;

  const ItemRestaurantModel({this.id, this.name});

  @override
  String toString() => 'Restaurant(id: $id, name: $name)';

  factory ItemRestaurantModel.fromJson(Map<String, dynamic> data) =>
      ItemRestaurantModel(
        id: data['id'] as String?,
        name: data['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };
  ItemRestaurantModel copyWith({
    String? id,
    String? name,
  }) {
    return ItemRestaurantModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
