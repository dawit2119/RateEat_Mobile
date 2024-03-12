// order_model.dart
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';

class OrderEntity extends Equatable {
  final String? id;
  final String? restaurantId;
  final String? restaurantName;
  final String? orderStatus;
  final String? orderType;
  final double totalPrice;
  final int totalNumberOfItems;
  final int estimatedWaitingTime;
  final String orderMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderItemModel> orderItems;
  final DateTime? orderConfirmedAt;
  final DateTime? paymentConfirmedAt;
  final DateTime? orderPlacedAt;
  final DateTime? orderCompletedAt;
  final DateTime? orderRejectedAt;
  final DateTime? orderCanceledAt;

  const OrderEntity({
    this.id,
    this.restaurantId,
    this.restaurantName,
    this.orderStatus,
    this.orderType,
    required this.totalPrice,
    required this.totalNumberOfItems,
    required this.estimatedWaitingTime,
    required this.orderMessage,
    required this.createdAt,
    required this.updatedAt,
    required this.orderItems,
    this.orderConfirmedAt,
    this.paymentConfirmedAt,
    this.orderPlacedAt,
    this.orderCompletedAt,
    this.orderRejectedAt,
    this.orderCanceledAt,
  });

  @override
  List<Object?> get props => [
        id,
        orderStatus,
        orderType,
        totalNumberOfItems,
        totalPrice,
        estimatedWaitingTime,
        orderMessage,
        restaurantId,
        orderItems,
        createdAt,
        updatedAt,
      ];
}
