import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/catagory_model.dart';

abstract class CategoriesRepository {
  Future<Either<Failure, List<Category>>> getCategories({
    required String restaurantId,
  });
}
