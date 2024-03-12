import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

import '../../../../core/core.dart';

abstract class FilterItemsRepository {
  Future<Either<Failure, List<Item>>> getRestaurantItems({
    required String restaurantId,
    required String maxPrice,
    required bool fasting,
    required String sortingQuery,
    required String searchQuery,
    String? categoryId,
    required int page,
    required int limit,
  });
}
