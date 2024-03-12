import 'package:flutter_test/flutter_test.dart';
import 'package:hive/hive.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/datasources/local_restaurant_detail_data_provider.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/menu_item.dart';

import 'local_restaurant_detail_data_provider_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Box>(),
])
void main() {
  late RestaurantLocalDataSourceImpl dataSource;
  late MockBox<RestaurantModel> mockRestaurantDetailsBox;
  late MockBox<dynamic> mockRestaurantItemsBox;
  late MockBox<List<dynamic>> mockPopularItemsBox;
  late MockBox<PopularRestaurantReviewsResponse> mockPopularReviewsBox;

  setUp(() {
    mockRestaurantDetailsBox = MockBox<RestaurantModel>();
    mockRestaurantItemsBox = MockBox<dynamic>();
    mockPopularItemsBox = MockBox<List<dynamic>>();
    mockPopularReviewsBox = MockBox<PopularRestaurantReviewsResponse>();
    dataSource = RestaurantLocalDataSourceImpl(
        restaurantDetailsBox: mockRestaurantDetailsBox,
        restaurantItemsBox: mockRestaurantItemsBox,
        popularItemsBox: mockPopularItemsBox,
        popularReviewsBox: mockPopularReviewsBox);
  });

  group('cacheRestaurantDetail', () {
    final tRestaurantModel = RestaurantModel(
      id: '1',
      name: 'Test',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('should call put on the box with the correct values', () async {
      // act
      await dataSource.cacheRestaurantDetail(tRestaurantModel);
      // assert
      verify(
          mockRestaurantDetailsBox.put(tRestaurantModel.id, tRestaurantModel));
    });
  });

  group('getCachedRestaurantDetail', () {
    const tRestaurantId = '1';
    final tRestaurantModel = RestaurantModel(
      id: '1',
      name: 'Test',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
    );

    test('should return RestaurantModel from the box', () async {
      // arrange
      when(mockRestaurantDetailsBox.get(any)).thenReturn(tRestaurantModel);
      // act
      final result = await dataSource.getCachedRestaurantDetail(tRestaurantId);
      // assert
      expect(result, tRestaurantModel);
    });

    test('should return null when the box is empty', () async {
      // arrange
      when(mockRestaurantDetailsBox.get(any)).thenReturn(null);
      // act
      final result = await dataSource.getCachedRestaurantDetail(tRestaurantId);
      // assert
      expect(result, null);
    });
  });

  group('cacheRestaurantItems', () {
    const tRestaurantId = 'restaurant123';
    final tItemModelList = [
      ItemModel(
          itemId: '1',
          itemName: 'Item 1',
          description: 'desc',
          price: 100,
          itemImages: [],
          numberOfReviews: 5),
      ItemModel(
          itemId: '2',
          itemName: 'Item 2',
          description: 'desc',
          price: 200,
          itemImages: [],
          numberOfReviews: 5),
    ];

    test('should call put on the box with the correct values', () async {
      // act
      await dataSource.cacheRestaurantItems(tRestaurantId, tItemModelList);
      // assert
      verify(mockRestaurantItemsBox.put(
          tRestaurantId, tItemModelList.map((item) => item.toJson()).toList()));
    });
  });

  group('getCachedRestaurantItems', () {
    const tRestaurantId = 'restaurant123';
    final tItemModelList = [
      ItemModel(
          itemId: '1',
          itemName: 'Item 1',
          description: 'desc',
          price: 100,
          itemImages: [],
          numberOfReviews: 5,
          imageUrl:
              "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg"),
      ItemModel(
          itemId: '2',
          itemName: 'Item 2',
          description: 'desc',
          price: 200,
          itemImages: [],
          numberOfReviews: 5,
          imageUrl:
              "https://thumbs.dreamstime.com/b/plate-fork-spoon-restaurant-logo-white-background-eps-plate-fork-spoon-restaurant-logo-193685698.jpg"),
    ];
    final tItemModelJsonList =
        tItemModelList.map((item) => item.toJson()).toList();

    test('should return List<ItemModel> from the box', () async {
      // arrange
      when(mockRestaurantItemsBox.get(any)).thenReturn(tItemModelJsonList);
      // act
      final result = await dataSource.getCachedRestaurantItems(tRestaurantId);
      // assert
      expect(result, tItemModelList);
    });

    test('should return empty list when the box is empty', () async {
      // arrange
      when(mockRestaurantItemsBox.get(any)).thenReturn(null);
      // act
      final result = await dataSource.getCachedRestaurantItems(tRestaurantId);
      // assert
      expect(result, []);
    });
  });

  group('cachePopularItems', () {
    const tRestaurantId = 'restaurant123';
    final tRestaurantMenuItemList = [
      RestaurantMenuItem(
        id: '1',
        name: 'Item 1',
        description: 'desc',
        price: 100,
        averageRating: 4.5,
      ),
      RestaurantMenuItem(
        id: '2',
        name: 'Item 2',
        description: 'desc',
        price: 200,
        averageRating: 4.0,
      ),
    ];

    test('should call put on the box with the correct values', () async {
      // act
      await dataSource.cachePopularItems(
          tRestaurantId, tRestaurantMenuItemList);
      // assert
      verify(mockPopularItemsBox.put(tRestaurantId,
          tRestaurantMenuItemList.map((item) => item.toJson()).toList()));
    });
  });

  group('getCachedPopularItems', () {
    const tRestaurantId = 'restaurant123';
    final tRestaurantMenuItemList = [
      RestaurantMenuItem(
        id: '1',
        name: 'Item 1',
        description: 'desc',
        price: 100,
        averageRating: 4.5,
      ),
      RestaurantMenuItem(
        id: '2',
        name: 'Item 2',
        description: 'desc',
        price: 200,
        averageRating: 4.0,
      ),
    ];
    final tRestaurantMenuItemJsonList =
        tRestaurantMenuItemList.map((item) => item.toJson()).toList();
    test('should return List<RestaurantMenuItem> from the box', () async {
      // arrange
      when(mockPopularItemsBox.get(any))
          .thenReturn(tRestaurantMenuItemJsonList);
      // act
      final result = await dataSource.getCachedPopularItems(tRestaurantId);
      // assert
      expect(result, tRestaurantMenuItemList);
    });

    test('should return empty list when the box is empty', () async {
      // arrange
      when(mockPopularItemsBox.get(any)).thenReturn(null);
      // act
      final result = await dataSource.getCachedPopularItems(tRestaurantId);
      // assert
      expect(result, []);
    });
    test('should return empty list when the box data is not null but invalid',
        () async {
      // arrange
      when(mockPopularItemsBox.get(any)).thenReturn(["invalid", 1, true]);
      // act
      final result = await dataSource.getCachedPopularItems(tRestaurantId);
      // assert
      expect(result, []);
    });
  });

  group('cachePopularReviews', () {
    const tRestaurantId = 'restaurant123';
    final tPopularRestaurantReviewsResponse = PopularRestaurantReviewsResponse(
        reviews: [], ratingsCount: [0], averageRating: 0, numberOfReviews: 0);

    test('should call put on the box with the correct values', () async {
      // act
      await dataSource.cachePopularReviews(
          tRestaurantId, tPopularRestaurantReviewsResponse);
      // assert
      verify(mockPopularReviewsBox.put(
          tRestaurantId, tPopularRestaurantReviewsResponse));
    });
  });

  group('getCachedPopularReviews', () {
    const tRestaurantId = 'restaurant123';
    final tPopularRestaurantReviewsResponse = PopularRestaurantReviewsResponse(
        reviews: [], ratingsCount: [0], averageRating: 0, numberOfReviews: 0);
    test('should return PopularRestaurantReviewsResponse from the box',
        () async {
      // arrange
      when(mockPopularReviewsBox.get(any))
          .thenReturn(tPopularRestaurantReviewsResponse);
      // act
      final result = await dataSource.getCachedPopularReviews(tRestaurantId);
      // assert
      expect(result, tPopularRestaurantReviewsResponse);
    });

    test('should return null when the box is empty', () async {
      // arrange
      when(mockPopularReviewsBox.get(any)).thenReturn(null);
      // act
      final result = await dataSource.getCachedPopularReviews(tRestaurantId);
      // assert
      expect(result, null);
    });
  });
}
