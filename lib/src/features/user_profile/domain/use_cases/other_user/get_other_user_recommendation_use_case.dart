import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/repository/others_profile_repository.dart';

class GetOtherUserRecommendationUseCase extends UseCase<
    List<UserRecommendation>, GetOtherUserRecommendationParams> {
  final OthersProfileRepository repository;

  GetOtherUserRecommendationUseCase({required this.repository});

  @override
  Future<Either<Failure, List<UserRecommendation>>> call(
      GetOtherUserRecommendationParams params) {
    return repository.getOtherUserRecommendations(
        id: params.id, page: params.page);
  }
}

class GetOtherUserRecommendationParams {
  final String id;
  final int page;
  GetOtherUserRecommendationParams({required this.id, required this.page});
}
