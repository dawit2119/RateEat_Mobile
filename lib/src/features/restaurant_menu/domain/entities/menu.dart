import 'package:equatable/equatable.dart';
import '../../../homepage/domain/entities/item.dart';

class Menu extends Equatable {
  final String id;
  final List<Item> items;
  final int? totalItemsCount;
  final int? loadedItemsCount;
  const Menu({
    required this.id,
    required this.items,
    required this.totalItemsCount,
    this.loadedItemsCount = 0,
  });
  @override
  List<Object?> get props => [id, items];
}
