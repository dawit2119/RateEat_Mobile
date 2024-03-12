import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/delete_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/restaurant_review_repository.dart';

class DeleteRestaurantReviewUseCase
    extends UseCase<String, DeleteRestaurantReviewUseCaseParams> {
  final RestaurantReviewRepository repository;
  DeleteRestaurantReviewUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, String>> call(
      DeleteRestaurantReviewUseCaseParams params) async {
    return await repository.deleteRestaurantReview(
        deleteRestaurantReviewRequestModel:
            params.deleteRestaurantReviewRequestModel);
  }
}

class DeleteRestaurantReviewUseCaseParams extends Equatable {
  final DeleteRestaurantReviewRequestModel deleteRestaurantReviewRequestModel;
  const DeleteRestaurantReviewUseCaseParams(
      {required this.deleteRestaurantReviewRequestModel});

  @override
  List<Object> get props => [deleteRestaurantReviewRequestModel];
}
