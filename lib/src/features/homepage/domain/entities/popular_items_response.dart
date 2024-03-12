import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

class PopularItemsResponse extends Equatable {
  final List<Item> items;
  final int? totalItems;

  const PopularItemsResponse({required this.items, required this.totalItems});

  @override
  List<Object?> get props => [items, totalItems];
}
