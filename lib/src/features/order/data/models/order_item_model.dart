import 'package:rateeat_mobile/src/features/order/order.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({
    required super.itemId,
    required super.quantity,
  });

  factory OrderItemModel.fromJson(Map<String, dynamic> json) {
    return OrderItemModel(
      itemId: json['item_id'] ?? "",
      quantity: json['quantity'] ?? 0,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'quantity': quantity,
    };
  }
}
