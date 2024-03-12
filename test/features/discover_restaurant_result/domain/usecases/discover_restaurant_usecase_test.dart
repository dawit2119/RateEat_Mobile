import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/discover_restaurant_result_model.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/domain/repositories/discover_restaurant_repo.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/domain/use_cases/discover_restaurant_use_case.dart';

import 'discover_restaurant_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FetchRestaurantRepo>(),
])
void main() {
  late DiscoverRestaurantUseCase discoverRestaurantUseCase;
  late MockFetchRestaurantRepo mockFetchRestaurantRepo;

  setUp(() {
    mockFetchRestaurantRepo = MockFetchRestaurantRepo();
    discoverRestaurantUseCase = DiscoverRestaurantUseCase(
      fetchRestaurantRepo: mockFetchRestaurantRepo,
    );
  });

  const testResponse = [
    DiscoverRestaurantResultModel(
      id: '1',
      name: 'test',
      distance: 1.0,
    )
  ];

  const testParam = DiscoverRestaurantParams(
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

  group('Discover Restaurant Use Case', () {
    test('should return list of DiscoverRestaurantResultModel', () async {
      // arrange
      when(
        mockFetchRestaurantRepo.getDiscoverRestaurantsResults(
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
        (_) async => const Right(testResponse),
      );

      // act
      final result = await discoverRestaurantUseCase(
        testParam,
      );
      // assert
      expect(result, const Right(testResponse));
      verify(
        mockFetchRestaurantRepo.getDiscoverRestaurantsResults(
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
      );
      verifyNoMoreInteractions(mockFetchRestaurantRepo);
    });
  });
}
