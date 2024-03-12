import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

abstract class FoodCategoryRepository {
  Future<Either<Failure, List<ItemCategoryModel>>> searchFoodCategory(
    String query,
    int pageNumber,
  );

  Future<Either<Failure, List<ItemCategoryModel>>> getTagSuggestion();
}
