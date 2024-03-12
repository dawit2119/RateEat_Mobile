import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../../core/core.dart';

import '../../domain.dart';

class GetUserReviewsUseCase
    extends UseCase<List<UserReview>, GetUserReviewsUseCaseParams> {
  final ProfileRepository profileRepository;

  GetUserReviewsUseCase({
    required this.profileRepository,
  });

  @override
  Future<Either<Failure, List<UserReview>>> call(
      GetUserReviewsUseCaseParams params) async {
    return await profileRepository.getUserReviews(
      userId: params.userId,
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetUserReviewsUseCaseParams extends Equatable {
  final String userId;
  final int page;
  final int limit;
  const GetUserReviewsUseCaseParams({
    required this.userId,
    this.page = 1,
    this.limit = 4,
  });

  @override
  List<Object?> get props => [userId, page, limit];
}
