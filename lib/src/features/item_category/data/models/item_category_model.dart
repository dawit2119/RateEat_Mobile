import 'package:rateeat_mobile/src/features/features.dart';

class ItemCategoryModel extends ItemCategory {
  const ItemCategoryModel({
    super.id,
    super.name,
    super.itemId,
    super.createdAt,
    super.updatedAt,
    super.iconUrl,
  });

  factory ItemCategoryModel.fromEntity(ItemCategory entity) =>
      ItemCategoryModel(
        id: entity.id,
        name: entity.name,
        itemId: entity.itemId,
        createdAt: entity.createdAt,
        updatedAt: entity.updatedAt,
        iconUrl: entity.iconUrl,
      );

  factory ItemCategoryModel.fromJson(Map<String, dynamic> data) =>
      ItemCategoryModel(
        id: data['id'] as String?,
        name: data['name'] as String?,
        itemId: data['item_id'] as String?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        iconUrl: data['icon'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'name': name,
        'item_id': itemId,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'icon': iconUrl,
      };

  ItemCategoryModel copyWith({
    String? id,
    String? name,
    String? itemId,
    DateTime? createdAt,
    DateTime? updatedAt,
    String? iconUrl,
  }) {
    return ItemCategoryModel(
        id: id ?? this.id,
        name: name ?? this.name,
        itemId: itemId ?? this.itemId,
        createdAt: createdAt ?? this.createdAt,
        updatedAt: updatedAt ?? this.updatedAt,
        iconUrl: iconUrl ?? this.iconUrl);
  }

  @override
  List<Object?> get props => [id, name, itemId, createdAt, updatedAt, iconUrl];
}
