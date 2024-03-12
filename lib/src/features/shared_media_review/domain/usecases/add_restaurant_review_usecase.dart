import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../repositories/add_restaurant_review_repository.dart';

class AddRestaurantReviewUsecase
    extends UseCase<void, AddRestaurantReviewParams> {
  final AddRestaurantReviewRepository repository;

  AddRestaurantReviewUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(AddRestaurantReviewParams params) async {
    return await repository.addRestaurantReview(
      restaurantId: params.restaurantId,
      rating: params.rating,
      reviewMessage: params.reviewMessage,
      reviewMedia: params.reviewMedia,
    );
  }
}

class AddRestaurantReviewParams {
  final String restaurantId;
  final String reviewMessage;
  final double rating;
  final List<File> reviewMedia;

  AddRestaurantReviewParams({
    required this.restaurantId,
    required this.reviewMessage,
    required this.rating,
    required this.reviewMedia,
  });
}
