import 'package:equatable/equatable.dart';

class OrderDetailEntity extends Equatable {
  final String id;
  final String restaurantId;
  final String restaurantName;
  final String orderStatus;
  final String orderType;
  final int totalPrice;
  final int totalNumberOfItems;
  final int estimatedWaitingTime;
  final String orderMessage;
  final DateTime createdAt;
  final DateTime updatedAt;
  final List<OrderDetailItemEntity> orderItems;
  final DateTime? orderConfirmedAt;
  final DateTime? paymentConfirmedAt;
  final DateTime? orderPlacedAt;
  final DateTime? orderCompletedAt;
  final DateTime? orderRejectedAt;
  final DateTime? orderCanceledAt;

  const OrderDetailEntity({
    required this.id,
    required this.restaurantId,
    required this.restaurantName,
    required this.orderStatus,
    required this.orderType,
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
        restaurantId,
        restaurantName,
        orderStatus,
        orderType,
        totalPrice,
        orderMessage,
        totalNumberOfItems,
        estimatedWaitingTime,
        createdAt,
        updatedAt,
        orderItems,
        orderConfirmedAt,
        paymentConfirmedAt,
        orderPlacedAt,
        orderCompletedAt,
        orderRejectedAt,
        orderCanceledAt,
      ];
}

class OrderDetailItemEntity extends Equatable {
  final String id;
  final String itemId;
  final int quantity;
  final OrderItemInfoEntity item;

  const OrderDetailItemEntity({
    required this.id,
    required this.itemId,
    required this.quantity,
    required this.item,
  });

  @override
  List<Object?> get props => [
        id,
        itemId,
        quantity,
        item,
      ];
}

class OrderItemInfoEntity extends Equatable {
  final String name;
  final int price;
  final List<OrderItemImageEntity> itemImages;

  const OrderItemInfoEntity(
      {required this.name, required this.price, required this.itemImages});

  @override
  List<Object?> get props => [
        name,
        price,
        itemImages,
      ];
}

class OrderItemImageEntity extends Equatable {
  final String url;

  const OrderItemImageEntity({
    required this.url,
  });

  @override
  List<Object?> get props => [
        url,
      ];
}
