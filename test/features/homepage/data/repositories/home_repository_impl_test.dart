import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/popular_items_response.dart';

import 'home_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RemoteHomeSource>(),
])
void main() {
  late HomeRepositoryImpl homeRepositoryImpl;
  late MockRemoteHomeSource mockRemoteHomeSource;

  setUp(() {
    mockRemoteHomeSource = MockRemoteHomeSource();
    homeRepositoryImpl = HomeRepositoryImpl(
      remoteSource: mockRemoteHomeSource,
    );
  });

  const testGetRecommendedItemsParams = GetRecommendedRestaurantsParams(
    page: 1,
    limit: 5,
    latitude: 0,
    longitude: 0,
    tags: [],
  );

  final items = [
    ItemModel(
      itemId: '1',
      itemName: 'name',
      description: 'description',
      imageUrl: 'imageUrl',
      numberOfReviews: 0,
    )
  ];

  final restaurants = [
    const RecommendedRestaurantModel(
      numberOfReviews: 0,
    )
  ];

  const promotions = [
    PromotionModel(
      itemId: "itemId",
      foodName: "foodName",
      restaurantName: "restaurantName",
      imageUrl: "imageUrl",
      discount: 10,
    )
  ];

  group('HomeRepositoryImpl', () {
    group('Get highest Rated Items', () {
      test(
          'should return a list of items when the call to the getTopRatedItems is successful',
          () async {
        // arrange
        when(
          mockRemoteHomeSource.getTopRatedItems(
            limit: testGetRecommendedItemsParams.limit,
            page: testGetRecommendedItemsParams.page,
            lat: testGetRecommendedItemsParams.latitude,
            lng: testGetRecommendedItemsParams.longitude,
            tags: ['tag'],
          ),
        ).thenAnswer((_) async =>
            PopularItemsResponse(items: items, totalItems: items.length));
        // act
        final result = await homeRepositoryImpl.getTopRatedItems(
          limit: testGetRecommendedItemsParams.limit,
          page: testGetRecommendedItemsParams.page,
          lat: testGetRecommendedItemsParams.latitude,
          lng: testGetRecommendedItemsParams.longitude,
          tags: ['tag'],
        );
        // assert
        expect(
            result,
            Right(
                PopularItemsResponse(items: items, totalItems: items.length)));
        verify(mockRemoteHomeSource.getTopRatedItems(
          limit: testGetRecommendedItemsParams.limit,
          page: testGetRecommendedItemsParams.page,
          lat: testGetRecommendedItemsParams.latitude,
          lng: testGetRecommendedItemsParams.longitude,
          tags: ['tag'],
        ));
      });

      test(
          'should return a ServerFailure when the call to the getTopRatedItems is unsuccessful',
          () async {
        // arrange
        when(
          mockRemoteHomeSource.getTopRatedItems(
            limit: testGetRecommendedItemsParams.limit,
            page: testGetRecommendedItemsParams.page,
            lat: testGetRecommendedItemsParams.latitude,
            lng: testGetRecommendedItemsParams.longitude,
            tags: ['tag'],
          ),
        ).thenThrow(ServerException());
        // act
        final result = await homeRepositoryImpl.getTopRatedItems(
          limit: testGetRecommendedItemsParams.limit,
          page: testGetRecommendedItemsParams.page,
          lat: testGetRecommendedItemsParams.latitude,
          lng: testGetRecommendedItemsParams.longitude,
          tags: ['tag'],
        );
        // assert
        expect(result, Left(ServerFailure()));
        verify(mockRemoteHomeSource.getTopRatedItems(
          limit: testGetRecommendedItemsParams.limit,
          page: testGetRecommendedItemsParams.page,
          lat: testGetRecommendedItemsParams.latitude,
          lng: testGetRecommendedItemsParams.longitude,
          tags: ['tag'],
        ));
      });
    });
    group('Get Recommended Items', () {
      test(
          'should return a list of items when the call to the getRecommendations is successful',
          () async {
        // arrange
        when(
          mockRemoteHomeSource.getRestaurantRecommendations(
            limit: testGetRecommendedItemsParams.limit,
            page: testGetRecommendedItemsParams.page,
            latitude: testGetRecommendedItemsParams.latitude,
            longitude: testGetRecommendedItemsParams.longitude,
            tags: [],
          ),
        ).thenAnswer((_) async => restaurants);
        // act
        final result = await homeRepositoryImpl.getRestaurantRecommendations(
          limit: testGetRecommendedItemsParams.limit,
          page: testGetRecommendedItemsParams.page,
          latitude: testGetRecommendedItemsParams.latitude,
          longitude: testGetRecommendedItemsParams.longitude,
          tags: [],
        );
        // assert
        expect(result, Right(restaurants));
        verify(mockRemoteHomeSource.getRestaurantRecommendations(
          limit: testGetRecommendedItemsParams.limit,
          page: testGetRecommendedItemsParams.page,
          latitude: testGetRecommendedItemsParams.latitude,
          longitude: testGetRecommendedItemsParams.longitude,
          tags: [],
        ));
      });

      test(
          'should return a ServerFailure when the call to the getRecommendations is unsuccessful',
          () async {
        // arrange
        when(
          mockRemoteHomeSource.getRestaurantRecommendations(
            limit: testGetRecommendedItemsParams.limit,
            page: testGetRecommendedItemsParams.page,
            latitude: testGetRecommendedItemsParams.latitude,
            longitude: testGetRecommendedItemsParams.longitude,
            tags: [],
          ),
        ).thenThrow(ServerException());
        // act
        final result = await homeRepositoryImpl.getRestaurantRecommendations(
          limit: testGetRecommendedItemsParams.limit,
          page: testGetRecommendedItemsParams.page,
          latitude: testGetRecommendedItemsParams.latitude,
          longitude: testGetRecommendedItemsParams.longitude,
          tags: [],
        );
        // assert
        expect(result, Left(ServerFailure()));
        verify(mockRemoteHomeSource.getRestaurantRecommendations(
          limit: testGetRecommendedItemsParams.limit,
          page: testGetRecommendedItemsParams.page,
          latitude: testGetRecommendedItemsParams.latitude,
          longitude: testGetRecommendedItemsParams.longitude,
          tags: [],
        ));
      });
    });
    group('Get Promotions', () {
      test(
          'should return a list of promotions when the call to the getPromotions is successful',
          () async {
        // arrange
        when(
          mockRemoteHomeSource.getPromotions(),
        ).thenAnswer(
          (_) async => promotions,
        );
        // act
        final result = await homeRepositoryImpl.getPromotions();
        // assert
        expect(result, const Right(promotions));
        verify(mockRemoteHomeSource.getPromotions());
      });

      test(
          'should return a ServerFailure when the call to the getPromotions is unsuccessful',
          () async {
        // arrange
        when(
          mockRemoteHomeSource.getPromotions(),
        ).thenThrow(ServerException());
        // act
        final result = await homeRepositoryImpl.getPromotions();
        // assert
        expect(result, Left(ServerFailure()));
        verify(mockRemoteHomeSource.getPromotions());
      });
    });
  });
}
