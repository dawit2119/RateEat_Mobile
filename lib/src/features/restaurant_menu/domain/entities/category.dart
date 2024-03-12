import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class CategoryEntity extends Equatable {
  final String? id;
  final String? name;
  final List<ItemModel> items;

  const CategoryEntity({
    this.id,
    this.name,
    this.items = const [],
  });

  @override
  List<Object> get props => [
        id ?? "",
        name ?? "",
        items,
      ];
}
