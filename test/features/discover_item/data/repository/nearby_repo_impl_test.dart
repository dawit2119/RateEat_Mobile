import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/data_sources/nearby_data_provider.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/near_by_restaurants_response_model.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/repositories/nearby_repo_impl.dart';

import 'package:rateeat_mobile/src/features/map_section/data/models/restaurant_model.dart';

import 'nearby_repo_impl_test.mocks.dart';

class MockNearByDataProvider extends Mock implements NearByDataProvider {}

@GenerateMocks([MockNearByDataProvider])
void main() {
  late NearByDataProvider mockNearByDataProvider;
  late NearByRestaurantsRepoImpl nearbyRestaurantsRepo;

  setUp(() {
    mockNearByDataProvider = MockMockNearByDataProvider();
    nearbyRestaurantsRepo =
        NearByRestaurantsRepoImpl(nearByDataProvider: mockNearByDataProvider);
  });

  group('NearByRestaurantsRepoImpl', () {
    const double mockLat = 37.7749;
    const double mockLng = -122.4194;
    const List<String> mockTag = ['burger'];
    const int mockPage = 1;
    const int mockLimit = 10;

    test(
        'returns list of nearby restaurants when data is retrieved successfully',
        () async {
      final mockResults = [const RestaurantModel(id: '1', name: 'restaurant')];
      final mockResponse = NearbyRestaurantsResponseModel(
        restaurants: mockResults,
        totalItems: 1,
      );

      when(mockNearByDataProvider.getNearByRestaurants(
        mockLat,
        mockLng,
        mockTag,
        mockPage,
        mockLimit,
      )).thenAnswer((_) async => mockResponse);

      final result = await nearbyRestaurantsRepo.getNearbyRestaurants(
        mockLat,
        mockLng,
        mockTag,
        mockPage,
        mockLimit,
      );

      expect(result, Right(mockResponse));
      verify(mockNearByDataProvider.getNearByRestaurants(
        mockLat,
        mockLng,
        mockTag,
        mockPage,
        mockLimit,
      ));
      verifyNoMoreInteractions(mockNearByDataProvider);
    });

    test('returns failure when data retrieval fails', () async {
      final error = ServerFailure();
      when(mockNearByDataProvider.getNearByRestaurants(
              mockLat, mockLng, mockTag, mockPage, mockLimit))
          .thenThrow(error);

      final result = await nearbyRestaurantsRepo.getNearbyRestaurants(
          mockLat, mockLng, mockTag, mockPage, mockLimit);

      expect(result, Left(error));
      verify(mockNearByDataProvider.getNearByRestaurants(
          mockLat, mockLng, mockTag, mockPage, mockLimit));
      verifyNoMoreInteractions(mockNearByDataProvider);
    });
  });
}
