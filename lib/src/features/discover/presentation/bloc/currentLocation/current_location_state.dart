import 'package:equatable/equatable.dart';

import '../../../../features.dart';

class UserLocationState extends Equatable {
  const UserLocationState();

  @override
  List<Object> get props => [];
}

class UserLocationInitial extends UserLocationState {
  const UserLocationInitial();
}

class UserLocationLoading extends UserLocationState {
  const UserLocationLoading();
}

class UserLocationLoaded extends UserLocationState {
  final Location location;

  const UserLocationLoaded({required this.location});

  @override
  List<Object> get props => [location];
}

class UserLocationError extends UserLocationState {
  final String message;

  const UserLocationError({required this.message});

  @override
  List<Object> get props => [message];
}
