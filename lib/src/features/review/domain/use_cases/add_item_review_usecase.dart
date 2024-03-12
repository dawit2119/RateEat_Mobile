import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/item_review_repository.dart';

class AddItemReviewUseCase extends UseCase<bool, AddItemReviewUseCaseParams> {
  final ItemReviewRepository repository;
  AddItemReviewUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, bool>> call(AddItemReviewUseCaseParams params) async {
    return await repository.addItemReview(
      addItemReviewRequestModel: params.addItemReviewRequestModel,
      isCandidateItem: params.isCandidateItem,
    );
  }
}

class AddItemReviewUseCaseParams extends Equatable {
  final AddItemReviewRequestModel addItemReviewRequestModel;
  final bool isCandidateItem;

  const AddItemReviewUseCaseParams({
    required this.addItemReviewRequestModel,
    required this.isCandidateItem,
  });

  @override
  List<Object> get props => [addItemReviewRequestModel, isCandidateItem];
}
