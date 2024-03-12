part of 'username_availability_bloc.dart';

abstract class UsernameAvailabilityEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class CheckUserNameAvailability extends UsernameAvailabilityEvent {
  final String userName;
  CheckUserNameAvailability({required this.userName});
}

class ResetUserNameToInitial extends UsernameAvailabilityEvent {
  ResetUserNameToInitial();
}
