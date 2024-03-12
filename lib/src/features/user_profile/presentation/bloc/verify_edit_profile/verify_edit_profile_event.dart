part of 'verify_edit_profile_bloc.dart';

abstract class VerifyEditProfileEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class SubmitVerifyEditProfileEvent extends VerifyEditProfileEvent {
  final UserModel user;
  final Map<String, dynamic> updateData;
  SubmitVerifyEditProfileEvent({
    required this.user,
    required this.updateData,
  });
  @override
  List<Object?> get props => [updateData, user];
}
