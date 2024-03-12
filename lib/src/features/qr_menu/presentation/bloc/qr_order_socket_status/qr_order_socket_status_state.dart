part of 'qr_order_socket_status_bloc.dart';

abstract class QROrderSocketStatusState extends Equatable {
  const QROrderSocketStatusState();

  @override
  List<Object> get props => [];
}

// Socket Connection
class QROrderSocketLoadingState extends QROrderSocketStatusState {}

class QROrderSocketConnectedState extends QROrderSocketStatusState {}

class QROrderSocketFailedState extends QROrderSocketStatusState {
  final String errorMessage;
  const QROrderSocketFailedState({required this.errorMessage});

  @override
  List<Object> get props => [errorMessage];
}
