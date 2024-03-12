import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

abstract class EditQROrderEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class GetPreviousOrder extends EditQROrderEvent {
  final String orderId;
  GetPreviousOrder({required this.orderId});
  @override
  List<Object> get props => [orderId];
}

class AddItemToOrder extends EditQROrderEvent {
  final QRItem item;
  AddItemToOrder({required this.item});
}

class RemoveItemFromOrder extends EditQROrderEvent {
  final QRItem item;
  RemoveItemFromOrder({required this.item});
}

class ClearOrder extends EditQROrderEvent {
  ClearOrder();
}

class PlaceUpdatedOrder extends EditQROrderEvent {
  final String orderId;
  final String orderNote;
  final Map<QRItem, int> items;
  final String orderType;
  final String restaurantId;

  PlaceUpdatedOrder({
    required this.orderId,
    required this.orderNote,
    required this.items,
    required this.orderType,
    required this.restaurantId,
  });
}
