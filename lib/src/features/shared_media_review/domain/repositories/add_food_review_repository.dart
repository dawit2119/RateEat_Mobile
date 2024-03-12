import 'dart:io';

import 'package:dartz/dartz.dart';
import '../../../../core/core.dart';

abstract class AddFoodReviewRepository {
  Future<Either<Failure, void>> addFoodReview({
    required String foodId,
    required String reviewMessage,
    required double rating,
    required List<File> reviewMedia,
  });
}
