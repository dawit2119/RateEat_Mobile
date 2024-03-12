part of 'username_availability_bloc.dart';

abstract class UsernameAvailabilityState extends Equatable {
  final String status;
  const UsernameAvailabilityState({required this.status});

  @override
  List<Object> get props => [status];
}

final class UsernameAvailabilityInitial extends UsernameAvailabilityState {
  const UsernameAvailabilityInitial({required super.status});
}

class UsernameAvailabilityLoading extends UsernameAvailabilityState {
  const UsernameAvailabilityLoading({required super.status});
}

class UsernameAvailabilitySuccess extends UsernameAvailabilityState {
  const UsernameAvailabilitySuccess({required super.status});
}

class UsernameAvailabilityFailed extends UsernameAvailabilityState {
  const UsernameAvailabilityFailed({required super.status});
  @override
  List<Object> get props => [];
}
