import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/repository/others_profile_repository.dart';

class GetOtherUserFollowingsUseCase
    extends UseCase<List<FollowUser>, GetOtherUserFollowingsParams> {
  final OthersProfileRepository othersProfileRepository;

  GetOtherUserFollowingsUseCase({required this.othersProfileRepository});

  @override
  Future<Either<Failure, List<FollowUser>>> call(params) async {
    return await othersProfileRepository.getFollowings(
        params.userId, params.page, params.query);
  }
}

class GetOtherUserFollowingsParams {
  final String userId;
  final int page;
  final String query;

  GetOtherUserFollowingsParams(
      {required this.userId, required this.page, required this.query});
}
