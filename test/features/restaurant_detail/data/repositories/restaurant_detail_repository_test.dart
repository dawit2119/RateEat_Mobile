import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/datasources/remote_restaurant_detail_data_provider.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_review_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/repositories/restaurant_detail_repository_impl.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/entities.dart';

import 'restaurant_detail_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RestaurantDetailDataSource>(),
])
void main() {
  late RestaurantRepositoryImpl restaurantRepositoryImpl;
  late MockRestaurantDetailDataSource mockRestaurantDetailDataSource;

  setUp(() {
    mockRestaurantDetailDataSource = MockRestaurantDetailDataSource();
    restaurantRepositoryImpl = RestaurantRepositoryImpl(
      restaurantDataProvider: mockRestaurantDetailDataSource,
    );
  });

  const testRestaurantId = 'restaurantId';
  const testLimit = 10;
  const testPage = 1;

  const testRestaurantModel = RestaurantModel(
    id: 'testRestaurantId',
    numberOfReviews: 0,
  );
  final testItems = [
    ItemModel(
      itemId: 'testItemId',
      itemName: 'testItemName',
      description: 'testItemDescription',
      price: 10.0,
      imageUrl: 'testImageUrl',
      numberOfReviews: 0,
    )
  ];
  const testRestaurantMenuItem = [
    RestaurantMenuItem(
      id: "restaurantId",
      name: "restaurantName",
      price: 0,
      description: "description",
      imageUrl: "imageUrl",
    )
  ];

  final testPopularRestaurantReviewsResponse =
      PopularRestaurantReviewsResponseModel(
    reviews: [
      PopularRestaurantReviewResponseModel(
        id: 'testReviewId',
      ),
    ],
    ratingsCount: [0, 0, 0, 0, 0],
    averageRating: 0,
    numberOfReviews: 0,
  );

  group('Get Restaurant Detail', () {
    test('should call the repository that gets restaurant detail', () async {
      // Arrange
      when(
        mockRestaurantDetailDataSource.getRestaurantDetail(
          restaurantId: testRestaurantId,
        ),
      ).thenAnswer((_) async => testRestaurantModel);
      // Act
      final result = await restaurantRepositoryImpl.getRestaurantDetail(
          testRestaurantId, null, null);
      // Assert
      expect(result, equals(const Right(testRestaurantModel)));
    });

    test(
        'should return a ServerFailure when the call to the repository is unsuccessful',
        () async {
      // Arrange
      when(
        mockRestaurantDetailDataSource.getRestaurantDetail(
          restaurantId: testRestaurantId,
        ),
      ).thenThrow(ServerException());
      // Act
      final result = await restaurantRepositoryImpl.getRestaurantDetail(
          testRestaurantId, null, null);
      // Assert
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('Get Restaurant Items', () {
    test('should call the repository that gets restaurant items', () async {
      // Arrange
      when(
        mockRestaurantDetailDataSource.getRestaurantItems(
          limit: testLimit,
          page: testPage,
          restaurantId: testRestaurantId,
        ),
      ).thenAnswer((_) async => testItems);
      // Act
      final result = await restaurantRepositoryImpl.getRestaurantItems(
        limit: testLimit,
        page: testPage,
        restaurantId: testRestaurantId,
      );
      // Assert
      expect(result, equals(Right(testItems)));
    });

    test(
        'should return a ServerFailure when the call to the repository is unsuccessful',
        () async {
      // Arrange
      when(
        mockRestaurantDetailDataSource.getRestaurantItems(
          limit: testLimit,
          page: testPage,
          restaurantId: testRestaurantId,
        ),
      ).thenThrow(ServerException());
      // Act
      final result = await restaurantRepositoryImpl.getRestaurantItems(
        limit: testLimit,
        page: testPage,
        restaurantId: testRestaurantId,
      );
      // Assert
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('Get Popular Items', () {
    test('should call the repository that gets popular items', () async {
      // Arrange
      when(
        mockRestaurantDetailDataSource.getPopularItems(
          restaurantId: testRestaurantId,
        ),
      ).thenAnswer((_) async => testRestaurantMenuItem);
      // Act
      final result = await restaurantRepositoryImpl.getPopularItems(
        restaurantId: testRestaurantId,
      );
      // Assert
      expect(result, equals(const Right(testRestaurantMenuItem)));
    });

    test(
        'should return a ServerFailure when the call to the repository is unsuccessful',
        () async {
      // Arrange
      when(
        mockRestaurantDetailDataSource.getPopularItems(
          restaurantId: testRestaurantId,
        ),
      ).thenThrow(ServerException());
      // Act
      final result = await restaurantRepositoryImpl.getPopularItems(
        restaurantId: testRestaurantId,
      );
      // Assert
      expect(result, equals(Left(ServerFailure())));
    });
  });

  group('Get Popular Restaurant Reviews', () {
    test('should call the repository that gets popular restaurant reviews',
        () async {
      // Arrange
      when(
        mockRestaurantDetailDataSource.getPopularRestaurantReviews(
          restaurantId: testRestaurantId,
        ),
      ).thenAnswer((_) async => testPopularRestaurantReviewsResponse);
      // Act
      final result = await restaurantRepositoryImpl.getPopularRestaurantReviews(
        restaurantId: testRestaurantId,
      );
      // Assert
      expect(result, equals(Right(testPopularRestaurantReviewsResponse)));
    });

    test(
        'should return a ServerFailure when the call to the repository is unsuccessful',
        () async {
      // Arrange
      when(
        mockRestaurantDetailDataSource.getPopularRestaurantReviews(
          restaurantId: testRestaurantId,
        ),
      ).thenThrow(ServerException());
      // Act
      final result = await restaurantRepositoryImpl.getPopularRestaurantReviews(
        restaurantId: testRestaurantId,
      );
      // Assert
      expect(result, equals(Left(ServerFailure())));
    });
  });
}
