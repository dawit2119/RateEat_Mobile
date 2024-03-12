import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/saved_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class GetSavedReviewsUseCase extends UseCase<List<SavedReviewsResponseModel>,
    GetSavedReviewsUseCaseParams> {
  final ProfileRepository profileRepository;

  GetSavedReviewsUseCase({
    required this.profileRepository,
  });

  @override
  Future<Either<Failure, List<SavedReviewsResponseModel>>> call(
      GetSavedReviewsUseCaseParams params) async {
    return await profileRepository.getSavedReviews(
      page: params.page,
      limit: params.limit,
    );
  }
}

class GetSavedReviewsUseCaseParams extends Equatable {
  final int page;
  final int limit;
  const GetSavedReviewsUseCaseParams({
    required this.page,
    required this.limit,
  });

  @override
  // TODO: implement props
  List<Object?> get props => [page, limit];
}
