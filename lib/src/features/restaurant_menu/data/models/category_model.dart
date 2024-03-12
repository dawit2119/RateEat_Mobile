import 'package:rateeat_mobile/src/features/features.dart';
import '../../domain/entities/entities.dart' as en;

class CategoryModel extends en.CategoryEntity {
  const CategoryModel({
    super.id,
    super.name,
    super.items,
  });

  factory CategoryModel.fromJson(Map<String, dynamic> data) => CategoryModel(
        id: data['id'] as String?,
        name: data['name'] as String?,
        items: data['item'].isNotEmpty
            ? data['item']
                .map<ItemModel>((item) => ItemModel.fromJson(item))
                .toList()
            : [],
      );

  CategoryModel copyWith({
    String? id,
    String? name,
    List<ItemModel>? items,
  }) {
    return CategoryModel(
      id: id ?? this.id,
      name: name ?? this.name,
      items: items ?? this.items,
    );
  }
}
