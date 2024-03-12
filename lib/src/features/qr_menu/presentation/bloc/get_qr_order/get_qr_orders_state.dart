import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

abstract class GetQROrderState extends Equatable {
  const GetQROrderState();
  @override
  List<Object> get props => [];
}

class GetQROrderSuccess extends GetQROrderState {
  final QROrder qrOrder;
  const GetQROrderSuccess({required this.qrOrder});
}

class GetQROrderFailure extends GetQROrderState {
  final String message;
  const GetQROrderFailure({required this.message});
}

class GetQROrderLoading extends GetQROrderState {
  const GetQROrderLoading();
}

class GetQROrderInitial extends GetQROrderState {
  const GetQROrderInitial();
}
