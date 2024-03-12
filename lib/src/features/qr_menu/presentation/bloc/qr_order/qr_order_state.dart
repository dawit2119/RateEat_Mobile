import 'package:rateeat_mobile/src/features/features.dart';

abstract class QROrderState {
  final Map<QRItem, int> items;
  QROrderState({required this.items});
}

class QROrderInitial extends QROrderState {
  QROrderInitial() : super(items: <QRItem, int>{});
}

class QRItemsInCart extends QROrderState {
  QRItemsInCart({required super.items});
}

class CreateQROrderLoading extends QROrderState {
  CreateQROrderLoading({required super.items});
}

class CreateQROrderSuccess extends QROrderState {
  final QROrder qrOrder;
  CreateQROrderSuccess({required super.items, required this.qrOrder});
}

class CreateQROrderFailure extends QROrderState {
  final String errorMessage;
  CreateQROrderFailure({required super.items, required this.errorMessage});
}
