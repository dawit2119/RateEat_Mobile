import '../../../homepage/data/models/item_model.dart';
import '../../domain/entities/menu.dart';
import 'category_model.dart';

class MenuModel extends Menu {
  const MenuModel({
    required super.id,
    required super.items,
    required super.totalItemsCount,
    super.loadedItemsCount,
  });
  factory MenuModel.fromJson(Map<String, dynamic> data) => MenuModel(
      id: data['id'],
      items: data['category']?.isNotEmpty ?? false
          ? data['category']
              .map<MenuModel>(
                (category) => CategoryModel.fromJson(
                  category,
                ),
              )
              .toList()
          : [],
      totalItemsCount: data["total_count"]);

  MenuModel copyWith({
    String? id,
    List<ItemModel>? items,
    int? totalItemsCount,
  }) {
    return MenuModel(
        id: id ?? this.id,
        items: items ?? this.items,
        totalItemsCount: totalItemsCount ?? this.totalItemsCount);
  }
}
