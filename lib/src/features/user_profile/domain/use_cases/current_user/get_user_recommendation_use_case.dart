import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class GetUserRecommendationUseCase
    extends UseCase<List<UserRecommendation>, int> {
  final ProfileRepository repository;

  GetUserRecommendationUseCase({required this.repository});

  @override
  Future<Either<Failure, List<UserRecommendation>>> call(params) {
    return repository.getUserRecommendations(params);
  }
}
