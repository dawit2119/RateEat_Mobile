import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/restaurant_category.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/repositories/restaurant_menu_repository.dart';

import '../../../homepage/data/models/models.dart';
import '../../domain/entities/menu.dart';
import '../data_sources/restaurant_menu_data_provider.dart';

class RestaurantMenuRepositoryImpl implements RestaurantMenuRepository {
  final RestaurantMenuDataProvider restaurantDataProvider;

  RestaurantMenuRepositoryImpl({
    required this.restaurantDataProvider,
  });
  @override
  Future<Either<Failure, List<ItemModel>>> getRestaurantMenuItems({
    required String restaurantId,
    required int limit,
    required int page,
  }) async {
    try {
      final restaurantMenuItems =
          await restaurantDataProvider.getRestaurantMenuItems(
              restaurantId: restaurantId, page: page, limit: limit);
      return Right(
        restaurantMenuItems,
      );
    } catch (exception) {
      return Left(
        mapExceptionToFailure(exception: exception),
      );
    }
  }

  @override
  Future<Either<Failure, Menu>> getRestaurantMenuCategoryItems({
    required String restaurantId,
    required String categoryName,
    required int page,
    required int limit,
    required String query,
    required String sortBy,
  }) async {
    try {
      final restaurantMenuItems =
          await restaurantDataProvider.getRestaurantMenuCategoryItems(
              restaurantId: restaurantId,
              categoryId: categoryName,
              page: page,
              limit: limit,
              query: query,
              sortBy: sortBy);
      return Right(
        restaurantMenuItems,
      );
    } catch (exception) {
      return Left(
        mapExceptionToFailure(exception: exception),
      );
    }
  }

  @override
  Future<Either<Failure, Item>> addCandidateItem({
    required String itemName,
    required String price,
    required List<File> itemImages,
    required String menuId,
    required String categoryName,
  }) async {
    try {
      final response = await restaurantDataProvider.addCandidateItem(
        itemName: itemName,
        price: price,
        itemImages: itemImages,
        menuId: menuId,
        categoryName: categoryName,
      );
      return Right(
        response,
      );
    } catch (exception) {
      return Left(
        mapExceptionToFailure(exception: exception),
      );
    }
  }

  @override
  Future<Either<Failure, List<RestaurantCategory>>> getRestaurantMenuCategories(
      {required String restaurantId}) async {
    try {
      final categories =
          await restaurantDataProvider.getRestaurantMenuCategories(
        restaurantId: restaurantId,
      );
      return Right(
        categories,
      );
    } catch (exception) {
      return Left(
        mapExceptionToFailure(exception: exception),
      );
    }
  }
}
