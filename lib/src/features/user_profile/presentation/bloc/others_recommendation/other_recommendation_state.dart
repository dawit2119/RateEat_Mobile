import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

abstract class OtherRecommendationState {}

class OtherRecommendationSuccess extends OtherRecommendationState {
  final List<UserRecommendation> recommendations;
  final int page;
  final bool hasReachedMax;

  OtherRecommendationSuccess(
      {required this.recommendations,
      required this.page,
      required this.hasReachedMax});
}

class OtherRecommendationNextLoading extends OtherRecommendationState {
  final List<UserRecommendation> recommendations;

  OtherRecommendationNextLoading({required this.recommendations});
}

class OtherRecommendationFailed extends OtherRecommendationState {}

class OtherRecommendationInitial extends OtherRecommendationState {}

class OtherRecommendationLoading extends OtherRecommendationState {}
