import 'package:equatable/equatable.dart';

class Menu extends Equatable {
  final String? id;
  final String? restaurantId;
  final DateTime? createdAt;
  final DateTime? updatedAt;

  const Menu({
    this.id,
    this.restaurantId,
    this.createdAt,
    this.updatedAt,
  });

  @override
  List<Object?> get props => [id, restaurantId, createdAt, updatedAt];
}
