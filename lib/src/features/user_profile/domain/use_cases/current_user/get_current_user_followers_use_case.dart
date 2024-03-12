import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class GetCurrentUserFollowersUseCase
    extends UseCase<List<FollowUser>, GetCurrentUserFollowersParams> {
  final ProfileRepository profileRepository;

  GetCurrentUserFollowersUseCase({required this.profileRepository});

  @override
  Future<Either<Failure, List<FollowUser>>> call(params) async {
    return await profileRepository.getFollowers(
        params.userId, params.page, params.query);
  }
}

class GetCurrentUserFollowersParams {
  final String userId;
  final int page;
  final String query;

  GetCurrentUserFollowersParams(
      {required this.userId, required this.page, required this.query});
}
