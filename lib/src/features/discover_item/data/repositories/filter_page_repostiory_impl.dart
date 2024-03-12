import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/data_sources/filter_page_data_provider.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/repositories/filter_page_repository.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

import '../../../discover/discover.dart';

class FilterItemsRepoImpl implements FilterItemsRepository {
  final FilterItemsDataProvider filterItemsDataProvider;

  FilterItemsRepoImpl({required this.filterItemsDataProvider});
  @override
  Future<Either<Failure, List<Item>>> getRestaurantItems({
    required String restaurantId,
    required String maxPrice,
    required bool fasting,
    required String sortingQuery,
    required String searchQuery,
    required int page,
    required int limit,
    Location? location,
    String? categoryId,
  }) async {
    try {
      var response = await filterItemsDataProvider.getRestaurantItems(
        restaurantId: restaurantId,
        maxPrice: maxPrice,
        fasting: fasting,
        sortingQuery: sortingQuery,
        searchQuery: searchQuery,
        categoryId: categoryId,
        page: page,
        limit: limit,
      );
      return Right(response);
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
