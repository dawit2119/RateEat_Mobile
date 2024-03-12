import 'package:rateeat_mobile/src/features/features.dart';

class QRMenuModel extends QRMenu {
  const QRMenuModel({
    required super.restaurantName,
    required super.restaurantId,
    required super.restaurantImageUrl,
    required super.backgroundColor,
    required super.itemBackgroundColor,
    required super.categories,
    required super.totalCategories,
    required super.items,
    required super.restaurant,
  });

  factory QRMenuModel.fromMap(Map<String, dynamic> data) {
    if (data["data"] == null) {
      throw Exception("unable to parse data");
    }
    var itemCategories = data["data"];
    final Map<QRCategoryModel, List<QRItemModel>> items = {};
    final List<QRCategory> categories = [];
    if (itemCategories is Map<String, dynamic>) {
      itemCategories = itemCategories.values.toList();
    }
    for (var entry in itemCategories) {
      var category = QRCategoryModel.fromMap(entry);
      categories.add(category);
      if (!items.keys.contains(category)) {
        items[category] = [];
      }

      items[category]!.addAll((entry["items"] as List?)
              ?.map<QRItemModel>((itemmap) => QRItemModel.fromMap(itemmap))
              .toList() ??
          []);
    }
    final menu = QRMenuModel(
      totalCategories: data['count'],
      restaurantName: data['restaurant']?['name'] as String? ?? "",
      restaurantId: data['restaurant']?['id'] as String? ?? "",
      restaurantImageUrl:
          data['restaurant']?['restaurantImage']?['url'] as String? ?? "",
      backgroundColor: data['background_color'] as String? ?? "",
      itemBackgroundColor: data['item_background_color'] as String? ?? "",
      categories: categories,
      items: items,
      restaurant: RestaurantModel.fromMap(data['restaurant']),
    );
    return menu;
  }

  QRMenuModel copyWith({
    String? restaurantName,
    String? restaurantId,
    String? restaurantImageUrl,
    String? backgroundColor,
    String? itemBackgroundColor,
    List<QRCategory>? categories,
    Map<QRCategory, List<QRItem>>? items,
    int? totalCategories,
    Restaurant? restaurant,
  }) {
    return QRMenuModel(
      restaurantName: restaurantName ?? this.restaurantName,
      restaurantId: restaurantId ?? this.restaurantId,
      restaurantImageUrl: restaurantImageUrl ?? this.restaurantImageUrl,
      backgroundColor: backgroundColor ?? this.backgroundColor,
      itemBackgroundColor: itemBackgroundColor ?? this.itemBackgroundColor,
      categories: categories ?? this.categories,
      items: items ?? this.items,
      totalCategories: totalCategories ?? this.totalCategories,
      restaurant: restaurant ?? this.restaurant,
    );
  }

  factory QRMenuModel.fromSingleCategoryMap(data, category) {
    final Map<QRCategoryModel, List<QRItemModel>> items = {};
    items[category] = [];
    for (var map in data["data"]) {
      items[category]?.add(QRItemModel.fromMap(map));
    }
    return QRMenuModel(
      restaurantId: data?["restaurant"]?["id"] ?? "",
      restaurantName: data?["restaurant"]?["name"] ?? "",
      restaurantImageUrl: (data?["restaurant"]?["restaurantImage"] != null &&
              (data?["restaurant"]?["restaurantImage"] as Map).isNotEmpty &&
              data?["restaurant"] != null)
          ? data?["restaurant"]["restaurantImage"]?["url"] ?? ""
          : "",
      backgroundColor: data?['style']?['backgroundColor'] ?? "",
      itemBackgroundColor: data?['style']?['itemBackGroundColor'] ?? "",
      categories: const [],
      items: items,
      totalCategories: data?["count"] ?? 0,
      restaurant: RestaurantModel.fromMap(data?["restaurant"]),
    );
  }
}
