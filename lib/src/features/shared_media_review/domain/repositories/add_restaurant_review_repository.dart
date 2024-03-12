import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';

abstract class AddRestaurantReviewRepository {
  Future<Either<Failure, void>> addRestaurantReview({
    required String restaurantId,
    required String reviewMessage,
    required double rating,
    required List<File> reviewMedia,
  });
}
