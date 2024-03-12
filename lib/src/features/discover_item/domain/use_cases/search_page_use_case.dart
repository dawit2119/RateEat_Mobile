import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/repositories/search_page_repostiory.dart';

class SearchPageUseCase {
  final SearchPageRepository searchPageRepository;
  SearchPageUseCase({required this.searchPageRepository});

  Future<Either<Failure, List<RestaurantResult>>> searchRestaurants(
      String query) async {
    return await searchPageRepository.searchRestaurants(query);
  }
}

// class SearchParams {
//   final String query;

//   SearchParams({
//     required this.query,
//   });
//}
