import 'package:dartz/dartz.dart';
import '../../../../../core/core.dart';
import '../../domain.dart';
import '../../repository/others_profile_repository.dart';

class GetOtherUserReviewsUseCase
    extends UseCase<List<UserReview>, OtherReviewParams> {
  final OthersProfileRepository othersProfileRepository;

  GetOtherUserReviewsUseCase({
    required this.othersProfileRepository,
  });
  @override
  Future<Either<Failure, List<UserReview>>> call(
      OtherReviewParams params) async {
    return await othersProfileRepository.getUserReviews(
        params.userId, params.page);
  }
}

class OtherReviewParams {
  final String userId;
  final int page;
  OtherReviewParams({required this.userId, required this.page});
}
