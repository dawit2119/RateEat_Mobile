import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

abstract class EditQROrderState extends Equatable {
  final Map<QRItem, int> items;
  final QROrder? order;
  const EditQROrderState({this.items = const <QRItem, int>{}, this.order});
}

class GetPreviousQROrderLoading extends EditQROrderState {
  const GetPreviousQROrderLoading({required super.items, super.order});

  @override
  List<Object> get props => [items, order ?? ''];
}

class GetPreviousQROrderFailed extends EditQROrderState {
  const GetPreviousQROrderFailed({required super.items, super.order});

  @override
  List<Object> get props => [items, order ?? ''];
}

class EditQROrderInitial extends EditQROrderState {
  @override
  List<Object> get props => [];
}

///State for accessing items in the order locally and reflect changes
class EditQROrderItemsInOrder extends EditQROrderState {
  const EditQROrderItemsInOrder({required super.items});

  @override
  List<Object> get props => [items];
}

class EditQROrderLoading extends EditQROrderState {
  const EditQROrderLoading({required super.items});

  @override
  List<Object> get props => [items];
}

class EditQROrderSuccess extends EditQROrderState {
  const EditQROrderSuccess({required super.items});

  @override
  List<Object> get props => [items];
}

class EditQROrderFailure extends EditQROrderState {
  final String errorMessage;
  const EditQROrderFailure({required super.items, required this.errorMessage});

  @override
  List<Object> get props => [items, errorMessage];
}
