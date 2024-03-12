abstract class UserPreferenceEvent {}

class UpdateUserPreference extends UserPreferenceEvent {
  final int? preferredWalkingDistance;
  final int? preferredDrivingDistance;
  final int? minNumberOfReviews;

  UpdateUserPreference({
    required this.preferredWalkingDistance,
    required this.preferredDrivingDistance,
    required this.minNumberOfReviews,
  });
}

class GetPreviousPreference extends UserPreferenceEvent {}
