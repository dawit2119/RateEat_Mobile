import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

abstract class OtherRecommendationEvent {}

class GetOtherRecommendation extends OtherRecommendationEvent {
  final String id;
  final int page;
  final List<UserRecommendation> recommendations;

  GetOtherRecommendation(
      {required this.id, required this.page, required this.recommendations});
}
