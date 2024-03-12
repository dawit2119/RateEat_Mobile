import 'dart:io';

import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';

import 'package:rateeat_mobile/src/features/homepage/data/models/models.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/menu.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/restaurant_category.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/repositories/restaurant_menu_repository.dart';

import 'restaurant_menu_repository_impl.mocks.dart';

@GenerateNiceMocks([MockSpec<RestaurantMenuRepository>()])
void main() {
  late MockRestaurantMenuRepository repository;

  setUp(() {
    repository = MockRestaurantMenuRepository();
  });

  group('getRestaurantMenuItems', () {
    final tRestaurantId = 'restaurant123';
    final tLimit = 10;
    final tPage = 1;
    final tItems = [
      ItemModel(
          itemId: '1', itemName: 'Item 1', price: 10.0, numberOfReviews: 0),
      ItemModel(
          itemId: '2', itemName: 'Item 2', price: 15.0, numberOfReviews: 0),
    ];

    test('should return a list of items on success', () async {
      // arrange
      when(repository.getRestaurantMenuItems(
        restaurantId: tRestaurantId,
        limit: tLimit,
        page: tPage,
      )).thenAnswer((_) async => Right(tItems));

      // act
      final result = await repository.getRestaurantMenuItems(
        restaurantId: tRestaurantId,
        limit: tLimit,
        page: tPage,
      );

      // assert
      expect(result, Right(tItems));
      verify(repository.getRestaurantMenuItems(
        restaurantId: tRestaurantId,
        limit: tLimit,
        page: tPage,
      ));
    });

    test('should return a Failure on error', () async {
      // arrange
      final tFailure = ServerFailure(errorMessage: 'Server error');
      when(repository.getRestaurantMenuItems(
        restaurantId: tRestaurantId,
        limit: tLimit,
        page: tPage,
      )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await repository.getRestaurantMenuItems(
        restaurantId: tRestaurantId,
        limit: tLimit,
        page: tPage,
      );

      // assert
      expect(result, Left(tFailure));
      verify(repository.getRestaurantMenuItems(
        restaurantId: tRestaurantId,
        limit: tLimit,
        page: tPage,
      ));
    });
  });

  group('getRestaurantMenuCategoryItems', () {
    final tRestaurantId = 'restaurant123';
    final tCategoryName = 'Category 1';
    final tPage = 1;
    final tLimit = 10;
    final tQuery = '';
    final tSortBy = 'name';
    final tMenu =
        Menu(id: 'menu1', items: [], totalItemsCount: 0, loadedItemsCount: 0);

    test('should return a Menu on success', () async {
      // arrange
      when(repository.getRestaurantMenuCategoryItems(
        restaurantId: tRestaurantId,
        categoryName: tCategoryName,
        page: tPage,
        limit: tLimit,
        query: tQuery,
        sortBy: tSortBy,
      )).thenAnswer((_) async => Right(tMenu));

      // act
      final result = await repository.getRestaurantMenuCategoryItems(
        restaurantId: tRestaurantId,
        categoryName: tCategoryName,
        page: tPage,
        limit: tLimit,
        query: tQuery,
        sortBy: tSortBy,
      );

      // assert
      expect(result, Right(tMenu));
      verify(repository.getRestaurantMenuCategoryItems(
        restaurantId: tRestaurantId,
        categoryName: tCategoryName,
        page: tPage,
        limit: tLimit,
        query: tQuery,
        sortBy: tSortBy,
      ));
    });

    test('should return a Failure on error', () async {
      // arrange
      final tFailure = ServerFailure(errorMessage: 'Server error');
      when(repository.getRestaurantMenuCategoryItems(
        restaurantId: tRestaurantId,
        categoryName: tCategoryName,
        page: tPage,
        limit: tLimit,
        query: tQuery,
        sortBy: tSortBy,
      )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await repository.getRestaurantMenuCategoryItems(
        restaurantId: tRestaurantId,
        categoryName: tCategoryName,
        page: tPage,
        limit: tLimit,
        query: tQuery,
        sortBy: tSortBy,
      );

      // assert
      expect(result, Left(tFailure));
      verify(repository.getRestaurantMenuCategoryItems(
        restaurantId: tRestaurantId,
        categoryName: tCategoryName,
        page: tPage,
        limit: tLimit,
        query: tQuery,
        sortBy: tSortBy,
      ));
    });
  });

  group('addCandidateItem', () {
    final tItemName = 'New Item';
    final tPrice = '9.99';
    final tItemImages = [File('test_image.jpg')];
    final tMenuId = 'menu123';
    final tCategoryName = 'Category 1';
    final tItem = ItemModel(
        itemId: '1', itemName: tItemName, price: 9.99, numberOfReviews: 0);

    test('should return an Item on success', () async {
      // arrange
      when(repository.addCandidateItem(
        itemName: tItemName,
        price: tPrice,
        itemImages: tItemImages,
        menuId: tMenuId,
        categoryName: tCategoryName,
      )).thenAnswer((_) async => Right(tItem));

      // act
      final result = await repository.addCandidateItem(
        itemName: tItemName,
        price: tPrice,
        itemImages: tItemImages,
        menuId: tMenuId,
        categoryName: tCategoryName,
      );

      // assert
      expect(result, Right(tItem));
      verify(repository.addCandidateItem(
        itemName: tItemName,
        price: tPrice,
        itemImages: tItemImages,
        menuId: tMenuId,
        categoryName: tCategoryName,
      ));
    });

    test('should return a Failure on error', () async {
      // arrange
      final tFailure = ServerFailure(errorMessage: 'Server error');
      when(repository.addCandidateItem(
        itemName: tItemName,
        price: tPrice,
        itemImages: tItemImages,
        menuId: tMenuId,
        categoryName: tCategoryName,
      )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await repository.addCandidateItem(
        itemName: tItemName,
        price: tPrice,
        itemImages: tItemImages,
        menuId: tMenuId,
        categoryName: tCategoryName,
      );

      // assert
      expect(result, Left(tFailure));
      verify(repository.addCandidateItem(
        itemName: tItemName,
        price: tPrice,
        itemImages: tItemImages,
        menuId: tMenuId,
        categoryName: tCategoryName,
      ));
    });
  });

  group('getRestaurantMenuCategories', () {
    final tRestaurantId = 'restaurant123';
    final tCategories = [
      RestaurantCategory(
          id: '1', name: 'Category 1', menuId: 'menu1', isApproved: true),
      RestaurantCategory(
          id: '2', name: 'Category 2', menuId: 'menu1', isApproved: true),
    ];

    test('should return a list of RestaurantCategory on success', () async {
      // arrange
      when(repository.getRestaurantMenuCategories(
        restaurantId: tRestaurantId,
      )).thenAnswer((_) async => Right(tCategories));

      // act
      final result = await repository.getRestaurantMenuCategories(
        restaurantId: tRestaurantId,
      );

      // assert
      expect(result, Right(tCategories));
      verify(repository.getRestaurantMenuCategories(
        restaurantId: tRestaurantId,
      ));
    });

    test('should return a Failure on error', () async {
      // arrange
      final tFailure = ServerFailure(errorMessage: 'Server error');
      when(repository.getRestaurantMenuCategories(
        restaurantId: tRestaurantId,
      )).thenAnswer((_) async => Left(tFailure));

      // act
      final result = await repository.getRestaurantMenuCategories(
        restaurantId: tRestaurantId,
      );

      // assert
      expect(result, Left(tFailure));
      verify(repository.getRestaurantMenuCategories(
        restaurantId: tRestaurantId,
      ));
    });
  });
}
