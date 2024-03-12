import 'package:equatable/equatable.dart';

class OrderItem extends Equatable {
  final String itemId;
  final int quantity;

  const OrderItem({
    required this.itemId,
    required this.quantity,
  });

  @override
  List<Object?> get props => [itemId, quantity];
}
