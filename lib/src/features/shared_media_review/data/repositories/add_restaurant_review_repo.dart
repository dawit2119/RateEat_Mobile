import 'dart:io';

import 'package:dartz/dartz.dart';

import '../../../../core/core.dart';
import '../../domain/repositories/add_restaurant_review_repository.dart';
import '../datasources/add_restaurant_review_dp.dart';

class AddRestaurantReviewRepoImpl extends AddRestaurantReviewRepository {
  final AddRestaurantReviewDp addRestaurantReviewDataSource;

  AddRestaurantReviewRepoImpl({required this.addRestaurantReviewDataSource});

  @override
  Future<Either<Failure, void>> addRestaurantReview({
    required String restaurantId,
    required String reviewMessage,
    required double rating,
    required List<File> reviewMedia,
  }) async {
    try {
      await addRestaurantReviewDataSource.addRestaurantReview(
        restaurantId: restaurantId,
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
