part of 'qr_order_socket_status_bloc.dart';

abstract class QROrderSocketStatusEvent extends Equatable {
  const QROrderSocketStatusEvent();

  @override
  List<Object> get props => [];
}

// Socket Connection
class QROrderConnectSocket extends QROrderSocketStatusEvent {}

class QROrderSocketFailed extends QROrderSocketStatusEvent {
  final String errorMessage;

  const QROrderSocketFailed({required this.errorMessage});
}

class QROrderSocketConnected extends QROrderSocketStatusEvent {
  const QROrderSocketConnected();
}
