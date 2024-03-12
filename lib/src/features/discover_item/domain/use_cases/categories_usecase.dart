import 'package:dartz/dartz.dart';

import '../../../../core/error/failure.dart';
import '../../data/models/catagory_model.dart';
import '../repositories/categories_repository.dart';

class CategoriesUsecase {
  final CategoriesRepository repository;

  CategoriesUsecase({required this.repository});

  Future<Either<Failure, List<Category>>> getCategories(
      String retaurantId) async {
    return await repository.getCategories(restaurantId: retaurantId);
  }
}
