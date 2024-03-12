import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/repositories/nearby_places_repository.dart';

class AddReviewToDraftUseCase
    extends UseCase<String, DraftReviewUseCaseParams> {
  final NearByPlacesRepository repository;
  AddReviewToDraftUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, String>> call(DraftReviewUseCaseParams params) async {
    return await repository.addReviewToDraft(
        draftReviewRequestModel: params.draftReviewRequestModel);
  }
}

class DraftReviewUseCaseParams {
  final DraftReviewRequestModel draftReviewRequestModel;
  DraftReviewUseCaseParams({required this.draftReviewRequestModel});
}
