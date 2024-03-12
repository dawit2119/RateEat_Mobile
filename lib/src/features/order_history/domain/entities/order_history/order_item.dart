import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';

class OrderItem extends Equatable {
  final String? id;
  final String? itemId;
  final int? quantity;
  final ItemInfoEntity? item;

  const OrderItem({this.id, this.itemId, this.quantity, this.item});

  Map<String, dynamic> toMap() => {
        'id': id,
        'item_id': itemId,
        'quantity': quantity,
        'item': item?.toMap(),
      };

  @override
  List<Object?> get props => [id, itemId, quantity, item];
}
