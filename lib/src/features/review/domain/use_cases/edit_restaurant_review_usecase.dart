import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/edit_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/restaurant_review_repository.dart';

class EditRestaurantReviewUseCase
    extends UseCase<String, EditRestaurantReviewUseCaseParams> {
  final RestaurantReviewRepository repository;
  EditRestaurantReviewUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, String>> call(
      EditRestaurantReviewUseCaseParams params) async {
    return await repository.editRestaurantReview(
        editRestaurantReviewRequestModel:
            params.editRestaurantReviewRequestModel);
  }
}

class EditRestaurantReviewUseCaseParams extends Equatable {
  final EditRestaurantReviewRequestModel editRestaurantReviewRequestModel;
  const EditRestaurantReviewUseCaseParams(
      {required this.editRestaurantReviewRequestModel});

  @override
  List<Object> get props => [editRestaurantReviewRequestModel];
}
