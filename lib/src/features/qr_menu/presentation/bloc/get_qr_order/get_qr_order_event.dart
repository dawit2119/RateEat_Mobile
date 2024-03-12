import 'package:equatable/equatable.dart';

abstract class GetQROrderEvent extends Equatable {
  const GetQROrderEvent();

  @override
  List<Object> get props => [];
}

class GetQROrder extends GetQROrderEvent {
  final String orderId;

  const GetQROrder({required this.orderId});

  @override
  List<Object> get props => [orderId];
}
