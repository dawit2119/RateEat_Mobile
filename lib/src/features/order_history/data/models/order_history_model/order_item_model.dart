import 'package:rateeat_mobile/src/features/order_history/order_history.dart';

class OrderItemModel extends OrderItem {
  const OrderItemModel({super.id, super.itemId, super.quantity, super.item});

  factory OrderItemModel.fromMap(Map<String, dynamic> data) {
    var orderItemModel = OrderItemModel(
      id: data['id'] as String?,
      itemId: data['item_id'] as String?,
      quantity: data['quantity'] as int?,
      item: data['item'] != null ? ItemInfoModel.fromMap(data['item']) : null,
    );
    return orderItemModel;
  }
}
