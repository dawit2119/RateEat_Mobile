import 'package:equatable/equatable.dart';

class RestaurantCategory extends Equatable {
  final String id;
  final String name;
  final String menuId;
  final bool isApproved;

  const RestaurantCategory({
    required this.id,
    required this.name,
    required this.menuId,
    required this.isApproved,
  });

  @override
  List<Object?> get props => [id, name, menuId, isApproved];
}
