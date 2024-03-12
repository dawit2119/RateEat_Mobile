import 'package:rateeat_mobile/src/features/order_history/data/models/order_history_model/order_item_model.dart';

import '../../../domain/entities/order_history/order_history.dart';

class OrderHistoryModel extends OrderHistory {
  const OrderHistoryModel({
    super.id,
    super.userId,
    super.restaurantId,
    super.orderStatus,
    super.orderType,
    super.totalPrice,
    super.totalNumberOfItems,
    super.estimatedWaitingTime,
    super.orderMessage,
    super.createdAt,
    super.updatedAt,
    super.orderItems,
  });

  factory OrderHistoryModel.fromMap(Map<String, dynamic> data) =>
      OrderHistoryModel(
        id: data['id'] as String?,
        userId: data['user_id'] as String?,
        restaurantId: data['restaurant_id'] as String?,
        orderStatus: data['order_status'] as String?,
        orderType: data['order_type'] as String?,
        totalPrice: data['total_price'] as int?,
        totalNumberOfItems: data['total_number_of_items'] as int?,
        estimatedWaitingTime: data['estimated_waiting_time'] as int?,
        orderMessage: data['order_message'] as String?,
        createdAt: data['createdAt'] == null
            ? null
            : DateTime.parse(data['createdAt'] as String),
        updatedAt: data['updatedAt'] == null
            ? null
            : DateTime.parse(data['updatedAt'] as String),
        orderItems: (data['order_items'] as List<dynamic>?)
            ?.map((e) => OrderItemModel.fromMap(e as Map<String, dynamic>))
            .toList(),
      );

  @override
  Map<String, dynamic> toMap() => {
        'id': id,
        'user_id': userId,
        'restaurant_id': restaurantId,
        'order_status': orderStatus,
        'order_type': orderType,
        'total_price': totalPrice,
        'total_number_of_items': totalNumberOfItems,
        'estimated_waiting_time': estimatedWaitingTime,
        'order_message': orderMessage,
        'createdAt': createdAt?.toIso8601String(),
        'updatedAt': updatedAt?.toIso8601String(),
        'order_items': orderItems?.map((e) => e.toMap()).toList(),
      };

  OrderHistoryModel copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? orderStatus,
    String? orderType,
    int? totalPrice,
    int? totalNumberOfItems,
    int? estimatedWaitingTime,
    String? orderMessage,
    DateTime? createdAt,
    DateTime? updatedAt,
    List<OrderItemModel>? orderItems,
  }) {
    return OrderHistoryModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      orderStatus: orderStatus ?? this.orderStatus,
      orderType: orderType ?? this.orderType,
      totalPrice: totalPrice ?? this.totalPrice,
      totalNumberOfItems: totalNumberOfItems ?? this.totalNumberOfItems,
      estimatedWaitingTime: estimatedWaitingTime ?? this.estimatedWaitingTime,
      orderMessage: orderMessage ?? this.orderMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      orderItems: orderItems ?? this.orderItems,
    );
  }

  @override
  List<Object?> get props {
    return [
      id,
      userId,
      restaurantId,
      orderStatus,
      orderType,
      totalPrice,
      totalNumberOfItems,
      estimatedWaitingTime,
      orderMessage,
      createdAt,
      updatedAt,
      orderItems,
    ];
  }
}
