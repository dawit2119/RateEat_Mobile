import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/user.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';

class QROrderModel extends QROrder {
  const QROrderModel({
    required super.id,
    required super.userId,
    required super.restaurantId,
    required super.orderStatus,
    required super.orderType,
    required super.billingType,
    required super.totalPrice,
    required super.totalNumberOfItems,
    required super.estimatedWaitingTime,
    required super.orderMessage,
    super.orderConfirmedAt,
    super.paymentConfirmedAt,
    super.orderPlacedAt,
    super.orderCompletedAt,
    super.orderRejectedAt,
    super.orderCancelledAt,
    required super.createdAt,
    required super.updatedAt,
    required super.restaurant,
    required super.orderItems,
    required super.user,
    required super.orderNumber,
  });

  factory QROrderModel.fromMap(Map<String, dynamic> map) {
    return QROrderModel(
      id: map['id'] ?? "",
      userId: map['user_id'] ?? "",
      restaurantId: map['restaurant_id'] ?? "",
      orderStatus: map['order_status'] ?? "",
      orderType: map['order_type'] ?? "",
      billingType: map['billing_type'] ?? "",
      totalPrice: map['total_price'] ?? 0,
      totalNumberOfItems: map['total_number_of_items'] ?? 0,
      estimatedWaitingTime: map['estimated_waiting_time'] ?? 0,
      orderMessage: map['order_message'] ?? "",
      orderConfirmedAt: map['order_confirmed_at'] != null
          ? DateTime.parse(map['order_confirmed_at']).toLocal()
          : null,
      paymentConfirmedAt: map['payment_confirmed_at'] != null
          ? DateTime.parse(map['payment_confirmed_at']).toLocal()
          : null,
      orderPlacedAt: map['order_placed_at'] != null
          ? DateTime.parse(map['order_ placed_at']).toLocal()
          : null,
      orderCompletedAt: map['order_completed_at'] != null
          ? DateTime.parse(map['order_completed_at']).toLocal()
          : null,
      orderRejectedAt: map['order_rejected_at'] != null
          ? DateTime.parse(map['order_rejected_at']).toLocal()
          : null,
      orderCancelledAt: map['order_cancelled_at'] != null
          ? DateTime.parse(map['order_cancelled_at']).toLocal()
          : null,
      createdAt: DateTime.parse(map['createdAt'] ?? DateTime.now().toString())
          .toLocal(),
      updatedAt: DateTime.parse(map['updatedAt'] ?? DateTime.now().toString())
          .toLocal(),
      restaurant: RestaurantModel.fromMap(map['restaurant'] ?? {}),
      orderItems: Map.fromEntries(
        (map['order_items'] as List<dynamic>? ?? []).map((itemData) {
          final itemMap = itemData as Map<String, dynamic>;
          return MapEntry(
            QRItemModel.fromMap(itemMap["item"] ?? itemMap),
            itemMap['quantity'] as int? ?? 0,
          );
        }),
      ),
      user: map['user'] != null
          ? UserModel.fromJson({"user": map['user']})
          : null,
      orderNumber: map['order_number'] ?? "",
    );
  }

  @override
  QROrder copyWith(
      {String? id,
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
      String? orderNumber}) {
    return QROrderModel(
      id: id ?? this.id,
      userId: userId ?? this.userId,
      restaurantId: restaurantId ?? this.restaurantId,
      orderConfirmedAt: orderConfirmedAt ?? this.orderConfirmedAt,
      paymentConfirmedAt: paymentConfirmedAt ?? this.paymentConfirmedAt,
      orderPlacedAt: orderPlacedAt ?? this.orderPlacedAt,
      orderCompletedAt: orderCompletedAt ?? this.orderCompletedAt,
      orderRejectedAt: orderRejectedAt ?? this.orderRejectedAt,
      orderCancelledAt: orderCancelledAt ?? this.orderCancelledAt,
      orderStatus: orderStatus ?? this.orderStatus,
      orderType: orderType ?? this.orderType,
      billingType: billingType ?? this.billingType,
      totalPrice: totalPrice ?? this.totalPrice,
      totalNumberOfItems: totalNumberOfItems ?? this.totalNumberOfItems,
      estimatedWaitingTime: estimatedWaitingTime ?? this.estimatedWaitingTime,
      orderMessage: orderMessage ?? this.orderMessage,
      createdAt: createdAt ?? this.createdAt,
      updatedAt: updatedAt ?? this.updatedAt,
      restaurant: restaurant ?? this.restaurant,
      orderItems: orderItems ?? this.orderItems,
      user: user ?? this.user,
      orderNumber: orderNumber ?? this.orderNumber,
    );
  }
}
