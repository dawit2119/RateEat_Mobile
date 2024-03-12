// order_model.dart
import 'package:rateeat_mobile/src/features/order/order.dart';

class OrderModel extends OrderEntity {
  const OrderModel({
    super.id,
    super.restaurantId,
    super.restaurantName,
    super.orderStatus,
    super.orderType,
    required super.totalPrice,
    required super.totalNumberOfItems,
    required super.estimatedWaitingTime,
    required super.orderMessage,
    required super.createdAt,
    required super.updatedAt,
    required super.orderItems,
    super.orderConfirmedAt,
    super.paymentConfirmedAt,
    super.orderPlacedAt,
    super.orderCompletedAt,
    super.orderRejectedAt,
    super.orderCanceledAt,
  });
  factory OrderModel.fromJson(Map<String, dynamic> json) {
    var orderItemsFromJson = json['order_items'] as List;
    List<OrderItemModel> orderItemList =
        orderItemsFromJson.map((i) => OrderItemModel.fromJson(i)).toList();

    return OrderModel(
      id: json['id'] ?? "",
      restaurantId: json["restaurant_id"] ?? "",
      restaurantName: json["restaurant_name"] ?? "",
      orderStatus: json['order_status'] ?? "",
      orderType: json['order_type'] ?? "",
      totalPrice: double.parse(
        (json['total_price'].toDouble() ?? 0.0).toStringAsFixed(2),
      ),
      totalNumberOfItems: json['total_number_of_items'] ?? 0,
      estimatedWaitingTime: json['estimated_waiting_time'] ?? 30,
      orderMessage: json['order_message'] ?? "",
      createdAt: DateTime.parse(json['createdAt']),
      updatedAt: DateTime.parse(json['updatedAt']),
      orderItems: orderItemList,
      orderConfirmedAt: (json['order_confirmed_at'] != null)
          ? DateTime.parse(json['order_confirmed_at'])
          : null,
      paymentConfirmedAt: (json['payment_confirmed_at'] != null)
          ? DateTime.parse(json['payment_confirmed_at'])
          : null,
      orderPlacedAt: (json['order_placed_at'] != null)
          ? DateTime.parse(json['order_placed_at'])
          : null,
      orderCompletedAt: (json['order_completed_at'] != null)
          ? DateTime.parse(json['order_completed_at'])
          : null,
      orderRejectedAt: (json['order_rejected_at'] != null)
          ? DateTime.parse(json['order_rejected_at'])
          : null,
      orderCanceledAt: (json['order_cancelled_at'] != null)
          ? DateTime.parse(json['order_cancelled_at'])
          : null,
    );
  }
  Map<String, dynamic> toJson() {
    return {
      'orderType': orderType,
      'totalNumberOfItems': totalNumberOfItems,
      'totalPrice': totalPrice,
      'estimatedWaitingTime': estimatedWaitingTime,
      'orderMessage': orderMessage,
      'restaurantId': restaurantId,
      'items': orderItems.map((e) => e.toJson()).toList(),
      "createdAt": createdAt.toString(),
      "updatedAt": updatedAt.toString(),
    };
  }
}
