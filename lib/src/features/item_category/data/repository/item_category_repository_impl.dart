import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class FoodCategoryRepositoryImpl implements FoodCategoryRepository {
  FoodCategoryDataProvider searchDataProvider;

  FoodCategoryRepositoryImpl({required this.searchDataProvider});

  @override
  Future<Either<Failure, List<ItemCategoryModel>>> searchFoodCategory(
      String query, int pageNumber) async {
    try {
      return Right(
          await searchDataProvider.searchFoodCategory(query, pageNumber));
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<ItemCategoryModel>>> getTagSuggestion() async {
    try {
      final result = await searchDataProvider.getTagSuggestion();
      return Right(result);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    } on NetworkException catch (e) {
      return Left(NetworkFailure(errorMessage: e.toString()));
    } catch (e) {
      return Left(DefaultFailure(errorMessage: e.toString()));
    }
  }
}
