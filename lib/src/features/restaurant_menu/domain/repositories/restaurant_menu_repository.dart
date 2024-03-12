import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../../../homepage/data/models/models.dart';
import '../../../homepage/domain/entities/item.dart';
import '../entities/menu.dart';
import '../entities/restaurant_category.dart';

abstract class RestaurantMenuRepository {
  Future<Either<Failure, List<ItemModel>>> getRestaurantMenuItems({
    required String restaurantId,
    required int limit,
    required int page,
  });

  Future<Either<Failure, Menu>> getRestaurantMenuCategoryItems({
    required String restaurantId,
    required String categoryName,
    required int page,
    required int limit,
    required String query,
    required String sortBy,
  });

  Future<Either<Failure, Item>> addCandidateItem({
    required String itemName,
    required String price,
    required List<File> itemImages,
    required String menuId,
    required String categoryName,
  });

  Future<Either<Failure, List<RestaurantCategory>>>
      getRestaurantMenuCategories({
    required String restaurantId,
  });
}
