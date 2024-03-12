import 'package:rateeat_mobile/src/features/order_history/domain/domain.dart';

class OrderDetailModel extends OrderDetailEntity {
  const OrderDetailModel({
    required super.id,
    required super.restaurantId,
    required super.restaurantName,
    required super.orderStatus,
    required super.orderType,
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

  factory OrderDetailModel.fromJson(Map<String, dynamic> json) {
    var orderItemsFromJson = json['order_items'] as List;
    List<OrderDetailItemModel> orderItemList = orderItemsFromJson
        .map((i) => OrderDetailItemModel.fromJson(i))
        .toList();

    return OrderDetailModel(
      id: json['id'] ?? "",
      restaurantId: json["restaurant_id"] ?? "",
      restaurantName: json["restaurant_name"] ?? "",
      orderStatus: json['order_status'] ?? "",
      orderType: json['order_type'] ?? "",
      totalPrice: json['total_price'] ?? 0,
      totalNumberOfItems: json['total_number_of_items'] ?? "",
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
}

class OrderDetailItemModel extends OrderDetailItemEntity {
  const OrderDetailItemModel({
    required super.id,
    required super.itemId,
    required super.quantity,
    required super.item,
  });

  factory OrderDetailItemModel.fromJson(Map<String, dynamic> json) {
    return OrderDetailItemModel(
      id: json['id'] ?? "",
      itemId: json['item_id'] ?? "",
      quantity: json['quantity'] ?? 0,
      item: OrderItemInfoModel.fromJson(json['item']),
    );
  }
}

class OrderItemInfoModel extends OrderItemInfoEntity {
  const OrderItemInfoModel(
      {required super.name, required super.price, required super.itemImages});

  factory OrderItemInfoModel.fromJson(Map<String, dynamic> json) {
    return OrderItemInfoModel(
      name: json['name'],
      price: json['price'],
      itemImages: List<OrderItemImageModel>.from(
        json["item_images"].map(
          (x) => OrderItemImageModel.fromJson(x),
        ),
      ),
    );
  }
}

class OrderItemImageModel extends OrderItemImageEntity {
  const OrderItemImageModel({
    required super.url,
  });

  factory OrderItemImageModel.fromJson(Map<String, dynamic> json) =>
      OrderItemImageModel(
        url: json["url"],
      );
}
