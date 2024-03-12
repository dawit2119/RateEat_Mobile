import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/models.dart';

class EditProfileEvent extends Equatable {
  @override
  List<Object?> get props => throw UnimplementedError();
}

class SubmitEditProfileEvent extends EditProfileEvent {
  final UserModel user;
  final Map<String, dynamic> updateData;

  SubmitEditProfileEvent({
    required this.user,
    required this.updateData,
  });
  @override
  List<Object?> get props => [user, updateData];
}

class ResetToInitialEvent extends EditProfileEvent {
  ResetToInitialEvent();
  @override
  List<Object?> get props => [];
}
