import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class UserPreferenceModel extends UserPreference {
  UserPreferenceModel(
      {super.drivingDistance, super.minNumberOfReviews, super.walkingDistance});

  factory UserPreferenceModel.fromMap(Map<String, dynamic> data) {
    return UserPreferenceModel(
      drivingDistance: data["preferred_driving_distance"] as int?,
      minNumberOfReviews: data["min_number_of_reviews"] as int?,
      walkingDistance: data["preferred_walking_distance"] as int?,
    );
  }
}
