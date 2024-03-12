import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/repository/follow_unfollow_repository.dart';

class UnFollowUserUseCase extends UseCase<bool, String> {
  final FollowUnfollowRepository followUnfollowRepository;

  UnFollowUserUseCase({required this.followUnfollowRepository});

  @override
  Future<Either<Failure, bool>> call(String params) async {
    return await followUnfollowRepository.unfollowUser(params);
  }
}
