import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/item_review_repository.dart';

class DeleteItemReviewUseCase
    extends UseCase<String, DeleteItemReviewUseCaseParams> {
  final ItemReviewRepository repository;
  DeleteItemReviewUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, String>> call(
      DeleteItemReviewUseCaseParams params) async {
    return await repository.deleteItemReview(
        deleteItemReviewRequestModel: params.deleteItemReviewRequestModel);
  }
}

class DeleteItemReviewUseCaseParams extends Equatable {
  final DeleteItemReviewRequestModel deleteItemReviewRequestModel;
  const DeleteItemReviewUseCaseParams(
      {required this.deleteItemReviewRequestModel});

  @override
  List<Object> get props => [deleteItemReviewRequestModel];
}
