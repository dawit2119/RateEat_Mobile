import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

abstract class QROrder extends Equatable {
  final String id;
  final String userId;
  final String restaurantId;
  final String orderStatus;
  final String orderType;
  final String billingType;
  final int totalPrice;
  final int totalNumberOfItems;
  final int estimatedWaitingTime;
  final String orderMessage;
  final DateTime? orderConfirmedAt;
  final DateTime? paymentConfirmedAt;
  final DateTime? orderPlacedAt;
  final DateTime? orderCompletedAt;
  final DateTime? orderRejectedAt;
  final DateTime? orderCancelledAt;
  final DateTime createdAt;
  final DateTime updatedAt;
  final Restaurant restaurant;
  final Map<QRItem, int> orderItems;
  final User? user;
  final String orderNumber;

  const QROrder({
    required this.id,
    required this.userId,
    required this.restaurantId,
    required this.orderStatus,
    required this.orderType,
    required this.billingType,
    required this.totalPrice,
    required this.totalNumberOfItems,
    required this.estimatedWaitingTime,
    required this.orderMessage,
    this.orderConfirmedAt,
    this.paymentConfirmedAt,
    this.orderPlacedAt,
    this.orderCompletedAt,
    this.orderRejectedAt,
    this.orderCancelledAt,
    required this.createdAt,
    required this.updatedAt,
    required this.restaurant,
    required this.orderItems,
    required this.user,
    required this.orderNumber,
  });
  @override
  List<Object?> get props => [
        id,
        userId,
        restaurantId,
        orderStatus,
        orderType,
        billingType,
        totalPrice,
        totalNumberOfItems,
        estimatedWaitingTime,
        orderMessage,
        orderConfirmedAt,
        paymentConfirmedAt,
        orderPlacedAt,
        orderCompletedAt,
        orderRejectedAt,
        orderCancelledAt,
        createdAt,
        updatedAt,
        restaurant,
        orderItems,
        user,
        orderNumber,
      ];

  QROrder copyWith({
    String? id,
    String? userId,
    String? restaurantId,
    String? orderStatus,
    String? orderType,
    String? billingType,
    int? totalPrice,
    int? totalNumberOfItems,
    int? estimatedWaitingTime,
    String? orderMessage,
    DateTime? orderConfirmedAt,
    DateTime? paymentConfirmedAt,
    DateTime? orderPlacedAt,
    DateTime? orderCompletedAt,
    DateTime? orderRejectedAt,
    DateTime? orderCancelledAt,
    DateTime? createdAt,
    DateTime? updatedAt,
    Restaurant? restaurant,
    Map<QRItem, int>? orderItems,
    User? user,
    String? orderNumber,
  });
}
