import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/repositories/filter_page_repository.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

class FilterItemsUseCase {
  final FilterItemsRepository filterItemsRepository;
  FilterItemsUseCase({required this.filterItemsRepository});

  Future<Either<Failure, List<Item>>> getRestaurantItems(
    String restaurantId,
    String maxPrice,
    bool fasting,
    String sortingQuery,
    String searchQuery,
    String categoryId,
    int page,
    int limit,
  ) async {
    return await filterItemsRepository.getRestaurantItems(
      restaurantId: restaurantId,
      maxPrice: maxPrice,
      fasting: fasting,
      sortingQuery: sortingQuery,
      searchQuery: searchQuery,
      categoryId: categoryId,
      page: page,
      limit: limit,
    );
  }
}

//   @override
//   Future<Either<Failure, List<Item>>> call(FilterParams params) async {
//     return await filterItemsRepository.getRestaurantItems(
//       restaurantId: params.restaurantId,
//       maxPrice: params.maxPrice,
//       minRating: params.minRating,
//       fasting: params.fasting,
//       sortingQuery: params.sortingQuery,
//       searchQuery: params.searchQuery,
//       page: params.page,
//       limit: params.limit,
//       location: params.location,
//     );
//   }
// }

// class FilterParams {
//   final String restaurantId;
//   final double maxPrice;
//   final double minRating;
//   final bool fasting;
//   final String sortingQuery;
//   final String searchQuery;
//   final int page;
//   final int limit;
//   final Location location;
//   FilterParams({
//     required this.restaurantId,
//     required this.maxPrice,
//     required this.minRating,
//     required this.fasting,
//     required this.sortingQuery,
//     required this.searchQuery,
//     required this.page,
//     required this.limit,
//     required this.location,
//   });
// }
