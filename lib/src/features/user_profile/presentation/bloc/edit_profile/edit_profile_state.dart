import 'package:equatable/equatable.dart';

import '../../../domain/entity/user.dart';

class EditProfileState extends Equatable {
  @override
  List<Object?> get props => [];
}

class EditProfileInitial extends EditProfileState {}

class EditProfileLoading extends EditProfileState {}

class EditProfileLoaded extends EditProfileState {
  final User user;
  EditProfileLoaded({required this.user});
  @override
  List<Object?> get props => [user];
}

class EditProfileError extends EditProfileState {
  final String error;
  EditProfileError({required this.error});
  @override
  List<Object?> get props => [error];
}
