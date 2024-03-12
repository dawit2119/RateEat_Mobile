import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'item_category.g.dart';

@HiveType(typeId: 5)
class ItemCategory extends Equatable {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? name;

  @HiveField(2)
  final String? itemId;

  @HiveField(3)
  final DateTime? createdAt;

  @HiveField(4)
  final DateTime? updatedAt;

  @HiveField(5)
  final String? iconUrl;

  const ItemCategory({
    this.id,
    this.name,
    this.itemId,
    this.createdAt,
    this.updatedAt,
    this.iconUrl,
  });

  @override
  List<Object?> get props => [id, name, itemId, createdAt, updatedAt, iconUrl];
}
