import 'package:rateeat_mobile/src/features/user_profile/domain/entity/user_stat.dart';

class UserStatModel extends UserStat {
  const UserStatModel(
      {super.followers = 0,
      super.following = 0,
      super.contributions = 0,
      super.favoritesCount = 0,
      super.draftsCount,
      super.reviewsCount,
      super.recommendations});

  factory UserStatModel.fromMap(json) {
    return UserStatModel(
        followers: json['followers'] ?? 0,
        following: json['following'] ?? 0,
        contributions: json['contributions'] ?? 0,
        favoritesCount: json['number_of_favorites'] ?? 0,
        draftsCount: json['number_of_draft_reviews'] ?? 0,
        reviewsCount: json['number_of_reviews'] ?? 0,
        recommendations: json['number_of_recommendations'] ?? 0);
  }

  Map<String, int?> toJson() {
    return {
      'followers': followers,
      'following': following,
      'contributions': contributions,
      'number_of_favorites': favoritesCount,
      'number_of_draft_reviews': draftsCount,
      'number_of_reviews': reviewsCount,
      'number_of_recommendations': recommendations,
    };
  }
}
