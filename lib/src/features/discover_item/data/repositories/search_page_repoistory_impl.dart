import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/data_sources/search_page_data_provider.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/repositories/search_page_repostiory.dart';

import '../../../../core/core.dart';

class SearchPageRepositoryImpl extends SearchPageRepository {
  final SearchPageDataProvider searchPageDataProvider;
  SearchPageRepositoryImpl({required this.searchPageDataProvider});
  @override
  Future<Either<Failure, List<RestaurantResult>>> searchRestaurants(
      String query) async {
    try {
      var response = await searchPageDataProvider.searchRestaurants(query);
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
