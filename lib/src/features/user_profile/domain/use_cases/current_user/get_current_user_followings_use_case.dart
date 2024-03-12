import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class GetCurrentUserFollowingsUseCase
    extends UseCase<List<FollowUser>, GetCurrentUserFollowingsParams> {
  final ProfileRepository profileRepository;

  GetCurrentUserFollowingsUseCase({required this.profileRepository});

  @override
  Future<Either<Failure, List<FollowUser>>> call(params) async {
    return await profileRepository.getFollowings(
        params.userId, params.page, params.query);
  }
}

class GetCurrentUserFollowingsParams {
  final String userId;
  final int page;
  final String query;
  GetCurrentUserFollowingsParams(
      {required this.userId, required this.page, required this.query});
}
