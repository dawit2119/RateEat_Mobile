import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/add_restaurant_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/restaurant_review_repository.dart';

class AddRestaurantReviewUseCase
    extends UseCase<String, AddRestaurantReviewUseCaseParams> {
  final RestaurantReviewRepository repository;
  AddRestaurantReviewUseCase({
    required this.repository,
  });

  @override
  Future<Either<Failure, String>> call(
      AddRestaurantReviewUseCaseParams params) async {
    return await repository.addRestaurantReview(
        addRestaurantReviewRequestModel:
            params.addRestaurantReviewRequestModel);
  }
}

class AddRestaurantReviewUseCaseParams extends Equatable {
  final AddRestaurantReviewRequestModel addRestaurantReviewRequestModel;
  const AddRestaurantReviewUseCaseParams(
      {required this.addRestaurantReviewRequestModel});

  @override
  List<Object> get props => [addRestaurantReviewRequestModel];
}
