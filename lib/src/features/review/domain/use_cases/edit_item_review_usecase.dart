import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/item_review_repository.dart';

class EditItemReviewUseCase
    extends UseCase<String, EditItemReviewUseCaseParams> {
  final ItemReviewRepository repository;
  EditItemReviewUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, String>> call(
      EditItemReviewUseCaseParams params) async {
    return await repository.editItemReview(
        editItemReviewRequestModel: params.editItemReviewRequestModel);
  }
}

class EditItemReviewUseCaseParams extends Equatable {
  final EditItemReviewRequestModel editItemReviewRequestModel;
  const EditItemReviewUseCaseParams({required this.editItemReviewRequestModel});

  @override
  List<Object> get props => [editItemReviewRequestModel];
}
