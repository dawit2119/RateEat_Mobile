import 'package:rateeat_mobile/src/features/features.dart';

abstract class QROrderEvent {}

class GetItemsInCart extends QROrderEvent {}

class AddItemToCart extends QROrderEvent {
  final QRItem item;
  AddItemToCart(this.item);
}

class RemoveItemFromCart extends QROrderEvent {
  final QRItem item;
  RemoveItemFromCart(this.item);
}

class ClearCart extends QROrderEvent {}

class CreateQROrder extends QROrderEvent {
  final String restaurantId;
  final String orderNote;
  final Location location;
  final Map<QRItem, int> items;
  final String orderType;

  CreateQROrder({
    required this.restaurantId,
    required this.orderNote,
    required this.location,
    required this.items,
    required this.orderType,
  });
}
