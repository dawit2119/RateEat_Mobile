import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../domain/repositories/add_food_review_repository.dart';
import '../datasources/add_food_review_dp.dart';

class AddFoodReviewRepoImpl extends AddFoodReviewRepository {
  final AddFoodReviewDp addFoodReviewDataSource;

  AddFoodReviewRepoImpl({required this.addFoodReviewDataSource});

  @override
  Future<Either<Failure, void>> addFoodReview({
    required String foodId,
    required String reviewMessage,
    required double rating,
    required List<File> reviewMedia,
  }) async {
    try {
      await addFoodReviewDataSource.addFoodReview(
        foodId: foodId,
        reviewMessage: reviewMessage,
        rating: rating,
        reviewMedia: reviewMedia,
      );
      return const Right(null);
    } catch (e) {
      return Left(mapExceptionToFailure(exception: e));
    }
  }
}
