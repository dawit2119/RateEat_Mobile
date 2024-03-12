import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/datasources/discover_restaurant_dp.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/discover_restaurant_result_model.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/repositories/discover_repo_impl.dart';

import 'discover_result_repo_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DiscoverRestaurantDataProvider>(),
])
void main() {
  late FetchRestaurantRepoImpl fetchRestaurantRepoImpl;
  late MockDiscoverRestaurantDataProvider mockDiscoverRestaurantDataProvider;

  setUp(() {
    mockDiscoverRestaurantDataProvider = MockDiscoverRestaurantDataProvider();
    fetchRestaurantRepoImpl = FetchRestaurantRepoImpl(
      discoverRestaurantResultDataProvider: mockDiscoverRestaurantDataProvider,
    );
  });

  const testResponse = [
    DiscoverRestaurantResultModel(
      id: '1',
      name: 'test',
      distance: 1.0,
    )
  ];

  group('Fetch Restaurant Repo Impl', () {
    test('should return list of DiscoverRestaurantResultModel', () async {
      // arrange
      when(
        mockDiscoverRestaurantDataProvider.getDiscoverRestaurantResults(
          latitude: 1.0,
          longitude: 1.0,
          radius: 1.0,
          maxPrice: 1.0,
          minRating: 1.0,
          tags: ['test'],
          sorting: 'test',
          fasting: true,
          limit: 1,
          page: 1,
          maxTravelTime: 1,
          transportMode: TransportMode.driving,
        ),
      ).thenAnswer(
        (_) async => testResponse,
      );

      // act
      final result =
          await fetchRestaurantRepoImpl.getDiscoverRestaurantsResults(
        latitude: 1.0,
        longitude: 1.0,
        radius: 1.0,
        maxPrice: 1.0,
        minRating: 1.0,
        tags: ['test'],
        sorting: 'test',
        fasting: true,
        limit: 1,
        page: 1,
        maxTravelTime: 1,
        transportMode: TransportMode.driving,
      );

      // assert
      expect(result, equals(const Right(testResponse)));
    });

    test('should return a failure when the server fails', () async {
      // arrange
      when(
        mockDiscoverRestaurantDataProvider.getDiscoverRestaurantResults(
          latitude: 1.0,
          longitude: 1.0,
          radius: 1.0,
          maxPrice: 1.0,
          minRating: 1.0,
          tags: ['test'],
          sorting: 'test',
          fasting: true,
          limit: 1,
          page: 1,
          maxTravelTime: 1,
          transportMode: TransportMode.driving,
        ),
      ).thenThrow(ServerException(errorMessage: 'Server error'));

      // act
      final result =
          await fetchRestaurantRepoImpl.getDiscoverRestaurantsResults(
        latitude: 1.0,
        longitude: 1.0,
        radius: 1.0,
        maxPrice: 1.0,
        minRating: 1.0,
        tags: ['test'],
        sorting: 'test',
        fasting: true,
        limit: 1,
        page: 1,
        maxTravelTime: 1,
        transportMode: TransportMode.driving,
      );

      // assert
      expect(result, equals(Left(ServerFailure(errorMessage: 'Server error'))));
    });
  });
}
