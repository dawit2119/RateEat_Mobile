import 'dart:convert';

import 'package:equatable/equatable.dart';

import 'order_item.dart';

class OrderHistory extends Equatable {
  final String? id;
  final String? userId;
  final String? restaurantId;
  final String? orderStatus;
  final String? orderType;
  final int? totalPrice;
  final int? totalNumberOfItems;
  final int? estimatedWaitingTime;
  final String? orderMessage;
  final DateTime? createdAt;
  final DateTime? updatedAt;
  final List<OrderItem>? orderItems;

  const OrderHistory({
    this.id,
    this.userId,
    this.restaurantId,
    this.orderStatus,
    this.orderType,
    this.totalPrice,
    this.totalNumberOfItems,
    this.estimatedWaitingTime,
    this.orderMessage,
    this.createdAt,
    this.updatedAt,
    this.orderItems,
  });

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

  /// `dart:convert`
  ///
  /// Converts [OrderHistory] to a JSON string.
  String toJson() => json.encode(toMap());

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
