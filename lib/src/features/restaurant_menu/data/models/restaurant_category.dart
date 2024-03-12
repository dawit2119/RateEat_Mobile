import '../../domain/entities/restaurant_category.dart';

class RestaurantMenuCategoryModel extends RestaurantCategory {
  const RestaurantMenuCategoryModel({
    required super.id,
    required super.name,
    required super.menuId,
    required super.isApproved,
  });

  factory RestaurantMenuCategoryModel.fromJson(Map<String, dynamic> map) =>
      RestaurantMenuCategoryModel(
        id: map['id'],
        name: map['name'],
        menuId: map['menu_id'],
        isApproved: map['is_approved'],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "name": name,
        "menu_id": menuId,
        "is_approved": isApproved,
      };

  RestaurantMenuCategoryModel copyWith({
    String? id,
    String? name,
    String? menuId,
    bool? isApproved,
  }) {
    return RestaurantMenuCategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      menuId: menuId ?? this.menuId,
      isApproved: isApproved ?? this.isApproved,
    );
  }
}
