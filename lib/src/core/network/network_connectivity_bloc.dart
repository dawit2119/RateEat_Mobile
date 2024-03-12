import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

// Events
abstract class NetworkEvent extends Equatable {
  const NetworkEvent();

  @override
  List<Object> get props => [];
}

class NetworkObserve extends NetworkEvent {}

class NetworkNotify extends NetworkEvent {
  final bool isConnected;

  const NetworkNotify({this.isConnected = false});
}

// States
abstract class NetworkState extends Equatable {
  const NetworkState();

  @override
  List<Object> get props => [];
}

class NetworkInitial extends NetworkState {}

class NetworkSuccess extends NetworkState {}

class NetworkFailed extends NetworkState {}

// BLoC
class NetworkBloc extends Bloc<NetworkEvent, NetworkState> {
  NetworkBloc() : super(NetworkInitial()) {
    on<NetworkObserve>(_observe);
    on<NetworkNotify>(_notifyStatus);
  }

  void _observe(event, emit) async {
    List<ConnectivityResult> result = await Connectivity().checkConnectivity();
    if (result.contains(ConnectivityResult.none)) {
      emit(NetworkFailed());
    } else {
      emit(NetworkSuccess());
    }
  }

  void _notifyStatus(NetworkNotify event, emit) {
    event.isConnected ? emit(NetworkSuccess()) : emit(NetworkFailed());
  }
}
