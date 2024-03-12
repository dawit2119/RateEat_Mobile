import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../../../features.dart';

class SearchFoodCategoryUseCase
    extends UseCase<List<ItemCategoryModel>, SearchFoodCategoryUseCaseParams> {
  final FoodCategoryRepository repository;
  SearchFoodCategoryUseCase({required this.repository});

  @override
  Future<Either<Failure, List<ItemCategoryModel>>> call(
      SearchFoodCategoryUseCaseParams params) async {
    return await repository.searchFoodCategory(
      params.query,
      params.pageNumber,
    );
  }
}

class SearchFoodCategoryUseCaseParams extends Equatable {
  final String query;
  final int pageNumber;

  const SearchFoodCategoryUseCaseParams({
    required this.query,
    required this.pageNumber,
  });

  @override
  List<Object> get props => [query, pageNumber];
}
