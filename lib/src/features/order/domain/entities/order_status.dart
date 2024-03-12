// lib/domain/entities/order_status.dart
import 'package:equatable/equatable.dart';

class Order extends Equatable {
  final String orderId;
  final String time;
  final String title;
  final bool isCompleted;
  final bool isCurrent;

  const Order({
    required this.orderId,
    required this.time,
    required this.title,
    required this.isCompleted,
    required this.isCurrent,
  });

  @override
  List<Object> get props => [orderId, time, title, isCompleted, isCurrent];
}
