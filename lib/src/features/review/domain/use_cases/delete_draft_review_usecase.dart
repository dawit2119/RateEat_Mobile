import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_draft_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/item_review_repository.dart';

class DeleteDraftItemReviewUseCase
    extends UseCase<String, DeleteDraftItemReviewUseCaseParams> {
  final ItemReviewRepository repository;
  DeleteDraftItemReviewUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, String>> call(
      DeleteDraftItemReviewUseCaseParams params) async {
    return await repository.deleteDraftItemReview(
        deleteDraftItemReviewRequestModel:
            params.deleteDraftItemReviewRequestModel);
  }
}

class DeleteDraftItemReviewUseCaseParams extends Equatable {
  final DeleteDraftItemReviewRequestModel deleteDraftItemReviewRequestModel;
  const DeleteDraftItemReviewUseCaseParams(
      {required this.deleteDraftItemReviewRequestModel});

  @override
  List<Object> get props => [deleteDraftItemReviewRequestModel];
}
