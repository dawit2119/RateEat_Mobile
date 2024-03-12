import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

abstract class RecommendationEvent {}

class GetMyRecommendations extends RecommendationEvent {
  final int page;
  final List<UserRecommendation> recommendations;

  GetMyRecommendations({required this.page, required this.recommendations});
}
