part of 'verify_edit_profile_bloc.dart';

abstract class VerifyEditProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class VerifyEditProfileInitial extends VerifyEditProfileState {}

class VerifyEditProfileLoading extends VerifyEditProfileState {}

class VerifyEditProfileSuccess extends VerifyEditProfileState {
  final User user;
  VerifyEditProfileSuccess({required this.user});
  @override
  List<Object?> get props => [user];
}

class VerifyEditProfileError extends VerifyEditProfileState {
  final String error;
  VerifyEditProfileError({required this.error});
  @override
  List<Object?> get props => [error];
}
