import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/data/data.dart';
import 'package:rateeat_mobile/src/features/homepage/data/models/models.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/data_sources/restaurant_menu_data_provider.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/menu.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/restaurant_category.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/repositories/restaurant_menu_repository_impl.dart';

import '../../../restaurant_detail/widgettest/restaurant_detail_widget_test.dart';
import 'restaurant_menu_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RestaurantMenuDataProvider>(),
])
void main() {
  late RestaurantMenuRepositoryImpl restaurantMenuRepositoryImpl;
  late MockRestaurantMenuDataProvider mockRestaurantMenuDataProvider;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;
  final token = LocalUserModel(token: 'token');

  setUp(() {
    mockRestaurantMenuDataProvider = MockRestaurantMenuDataProvider();
    restaurantMenuRepositoryImpl = RestaurantMenuRepositoryImpl(
      restaurantDataProvider: mockRestaurantMenuDataProvider,
    );
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => mockAuthenticationLocalSource);
  });

  const String restaurantId = '1';
  const int limit = 10;
  const int page = 1;
  const menuId = '1';
  const String categoryName = 'categoryName';

  final testRestaurantMenuItemsResponse = [
    ItemModel(
      itemId: '1',
      itemName: 'name',
      description: 'description',
      price: 10.0,
      categoryId: '1',
      numberOfReviews: 0,
    ),
  ];

  const testRestaurantMenuCategoryItemsResponse =
      MenuModel(id: '1', items: [], totalItemsCount: 10);

  final testAddItemCandidateResponse = ItemModel(
    itemId: '1',
    itemName: 'name',
    description: 'description',
    price: 1.0,
    imageUrl: 'imageUrl',
    numberOfReviews: 0,
  );

  const testMenuCategoriesResponse = [
    RestaurantMenuCategoryModel(
      id: '1',
      name: 'name',
      menuId: '1',
      isApproved: false,
    ),
  ];

  group('get restaurant menu items', () {
    test('should return a list of items', () async {
      // arrange
      when(
        mockRestaurantMenuDataProvider.getRestaurantMenuItems(
          restaurantId: restaurantId,
          limit: limit,
          page: page,
        ),
      ).thenAnswer(
        (_) async => testRestaurantMenuItemsResponse,
      );

      // act
      final result = await restaurantMenuRepositoryImpl.getRestaurantMenuItems(
        restaurantId: restaurantId,
        limit: limit,
        page: page,
      );

      // assert
      expect(result, equals(Right(testRestaurantMenuItemsResponse)));
    });

    test('should return a failure when the server fails', () async {
      // arrange
      when(
        mockRestaurantMenuDataProvider.getRestaurantMenuItems(
          restaurantId: restaurantId,
          limit: limit,
          page: page,
        ),
      ).thenThrow(ServerException(errorMessage: 'Server error'));

      // act
      final result = await restaurantMenuRepositoryImpl.getRestaurantMenuItems(
        restaurantId: restaurantId,
        limit: limit,
        page: page,
      );

      // assert
      expect(
        result,
        equals(Left(ServerFailure(errorMessage: 'Server error'))),
      );
    });
  });

  group('get restaurant menu category items', () {
    test('should return a list of items', () async {
      // arrange
      when(
        mockRestaurantMenuDataProvider.getRestaurantMenuCategoryItems(
          restaurantId: restaurantId,
          limit: limit,
          page: page,
          categoryId: categoryName,
          query: '',
          sortBy: 'name',
        ),
      ).thenAnswer(
        (_) async => testRestaurantMenuCategoryItemsResponse,
      );

      // act
      final result =
          await restaurantMenuRepositoryImpl.getRestaurantMenuCategoryItems(
        restaurantId: restaurantId,
        categoryName: categoryName,
        limit: limit,
        page: page,
        query: '',
        sortBy: 'name',
      );

      // assert
      expect(
          result, equals(const Right(testRestaurantMenuCategoryItemsResponse)));
    });

    test('should return a failure when the server fails', () async {
      // arrange
      when(
        mockRestaurantMenuDataProvider.getRestaurantMenuCategoryItems(
          restaurantId: restaurantId,
          categoryId: categoryName,
          limit: limit,
          page: page,
          query: '',
          sortBy: 'name',
        ),
      ).thenThrow(ServerException(errorMessage: 'Server error'));

      // act
      final result =
          await restaurantMenuRepositoryImpl.getRestaurantMenuCategoryItems(
        restaurantId: restaurantId,
        categoryName: categoryName,
        limit: limit,
        page: page,
        query: '',
        sortBy: 'name',
      );

      // assert
      expect(
        result,
        equals(Left(ServerFailure(errorMessage: 'Server error'))),
      );
    });
  });

  group('add candidate item', () {
    setUp(() {
      when(mockAuthenticationLocalSource.getUserCredential()).thenReturn(token);
    });

    test('should return a success message', () async {
      // arrange
      when(
        mockRestaurantMenuDataProvider.addCandidateItem(
          menuId: anyNamed('menuId'),
          itemImages: anyNamed('itemImages'),
          itemName: anyNamed('itemName'),
          price: anyNamed('price'),
          categoryName: anyNamed('categoryName'),
        ),
      ).thenAnswer(
        (_) async => testAddItemCandidateResponse,
      );

      // act
      final result = await restaurantMenuRepositoryImpl.addCandidateItem(
        menuId: menuId,
        categoryName: categoryName,
        itemName: testAddItemCandidateResponse.itemName,
        price: testAddItemCandidateResponse.price.toString(),
        itemImages: [],
      );

      // assert
      expect(result, equals(Right(testAddItemCandidateResponse)));
      verify(
        mockRestaurantMenuDataProvider.addCandidateItem(
          menuId: menuId,
          categoryName: categoryName,
          itemName: testAddItemCandidateResponse.itemName,
          price: testAddItemCandidateResponse.price.toString(),
          itemImages: [],
        ),
      ).called(1);
    });

    test('should return a failure when the server fails', () async {
      // arrange
      when(
        mockRestaurantMenuDataProvider.addCandidateItem(
          menuId: anyNamed('menuId'),
          categoryName: anyNamed('categoryName'),
          itemName: anyNamed('itemName'),
          price: anyNamed('price'),
          itemImages: anyNamed('itemImages'),
        ),
      ).thenThrow(ServerException(errorMessage: 'Server error'));

      // act
      final result = await restaurantMenuRepositoryImpl.addCandidateItem(
        menuId: menuId,
        categoryName: categoryName,
        itemName: testAddItemCandidateResponse.itemName,
        price: testAddItemCandidateResponse.price.toString(),
        itemImages: [],
      );

      // assert
      expect(
        result,
        equals(Left(ServerFailure(errorMessage: 'Server error'))),
      );
      verify(
        mockRestaurantMenuDataProvider.addCandidateItem(
          menuId: menuId,
          categoryName: categoryName,
          itemName: testAddItemCandidateResponse.itemName,
          price: testAddItemCandidateResponse.price.toString(),
          itemImages: [],
        ),
      ).called(1);
    });
  });

  group('get restaurant menu categories', () {
    test('should return a list of categories', () async {
      // arrange
      when(
        mockRestaurantMenuDataProvider.getRestaurantMenuCategories(
          restaurantId: restaurantId,
        ),
      ).thenAnswer(
        (_) async => testMenuCategoriesResponse,
      );

      // act
      final result =
          await restaurantMenuRepositoryImpl.getRestaurantMenuCategories(
        restaurantId: restaurantId,
      );

      // assert
      expect(result, equals(const Right(testMenuCategoriesResponse)));
    });

    test('should return a failure when the server fails', () async {
      // arrange
      when(
        mockRestaurantMenuDataProvider.getRestaurantMenuCategories(
          restaurantId: restaurantId,
        ),
      ).thenThrow(ServerException(errorMessage: 'Server error'));

      // act
      final result =
          await restaurantMenuRepositoryImpl.getRestaurantMenuCategories(
        restaurantId: restaurantId,
      );

      // assert
      expect(
        result,
        equals(Left(ServerFailure(errorMessage: 'Server error'))),
      );
    });
  });
}
