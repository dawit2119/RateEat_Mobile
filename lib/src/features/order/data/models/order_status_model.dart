// lib/domain/entities/order_status.dart
import '../../domain/entities/order_status.dart';

class OrderStatusModel extends Order {
  const OrderStatusModel({
    required super.orderId,
    required super.time,
    required super.title,
    required super.isCompleted,
    required super.isCurrent,
  });
  factory OrderStatusModel.fromMap(Map<String, dynamic> json) {
    return OrderStatusModel(
      orderId: json['id'],
      time: json['time'],
      title: json['title'],
      isCompleted: json['isCompleted'],
      isCurrent: json['isCurrent'],
    );
  }
}
