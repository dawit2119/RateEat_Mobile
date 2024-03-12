import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/repository/others_profile_repository.dart';

class GetOtherUserFollowersUseCase
    extends UseCase<List<FollowUser>, GetOtherUserFollowersParams> {
  final OthersProfileRepository othersProfileRepository;

  GetOtherUserFollowersUseCase({required this.othersProfileRepository});

  @override
  Future<Either<Failure, List<FollowUser>>> call(params) async {
    return await othersProfileRepository.getFollowers(
        params.userId, params.page, params.query);
  }
}

class GetOtherUserFollowersParams {
  final String userId;
  final int page;
  final String query;

  GetOtherUserFollowersParams(
      {required this.userId, required this.page, required this.query});
}
