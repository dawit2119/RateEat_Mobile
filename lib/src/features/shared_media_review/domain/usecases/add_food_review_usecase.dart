import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../repositories/add_food_review_repository.dart';

class AddFoodReviewUsecase extends UseCase<void, AddFoodReviewParams> {
  final AddFoodReviewRepository repository;

  AddFoodReviewUsecase({required this.repository});

  @override
  Future<Either<Failure, void>> call(AddFoodReviewParams params) async {
    return await repository.addFoodReview(
      foodId: params.foodId,
      rating: params.rating,
      reviewMessage: params.reviewMessage,
      reviewMedia: params.reviewMedia,
    );
  }
}

class AddFoodReviewParams {
  final String foodId;
  final String reviewMessage;
  final double rating;
  final List<File> reviewMedia;

  AddFoodReviewParams({
    required this.foodId,
    required this.reviewMessage,
    required this.rating,
    required this.reviewMedia,
  });
}
