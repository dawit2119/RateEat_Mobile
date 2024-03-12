import 'dart:developer';

import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';

import '../../domain/repositories/categories_repository.dart';
import '../data_sources/catagories_data_provider.dart';
import '../models/catagory_model.dart';

class CategoriesRepositoryImpl implements CategoriesRepository {
  final CatagoriesDataProvider getCategoriesDataProvider;

  CategoriesRepositoryImpl({required this.getCategoriesDataProvider});

  @override
  Future<Either<Failure, List<Category>>> getCategories({
    required String restaurantId,
  }) async {
    try {
      final response =
          await getCategoriesDataProvider.getCatagories(restaurantId);
      log(response.toString(), name: 'CategoriesRepositoryImpl');
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
