import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/draft_to_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/item_review_repository.dart';

class SendDraftToReviewUSeCase
    extends UseCase<String, SendDraftToReviewUSeCaseParams> {
  final ItemReviewRepository repository;
  SendDraftToReviewUSeCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, String>> call(
      SendDraftToReviewUSeCaseParams params) async {
    return await repository.addDraftToReview(
        draftToReviewRequestModel: params.draftToReviewRequestModel);
  }
}

class SendDraftToReviewUSeCaseParams extends Equatable {
  final DraftToReviewRequestModel draftToReviewRequestModel;
  const SendDraftToReviewUSeCaseParams(
      {required this.draftToReviewRequestModel});

  @override
  List<Object> get props => [draftToReviewRequestModel];
}
