import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

abstract class UserPreferenceState {}

class UserPreferenceInitial extends UserPreferenceState {}

class UserPreferenceUpdateSuccess extends UserPreferenceState {}

class UserPreferenceUpdateFailed extends UserPreferenceState {}

class UserPreferenceUpdateLoading extends UserPreferenceState {}

class PreviousPreferencesFetched extends UserPreferenceState {
  final UserPreference userPreference;
  PreviousPreferencesFetched({required this.userPreference});
}

class PreviousPreferencesFetchFailed extends UserPreferenceState {}
