import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/near_by_restaurants_response_model.dart';

import 'package:rateeat_mobile/src/features/discover_item/domain/use_cases/nearby_usecase.dart';

import 'package:rateeat_mobile/src/features/discover_item/domain/repositories/nearby_repository.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/src/features/map_section/data/data.dart';

import 'nearyby_page_usecase_test.mocks.dart';

class MockNearbyRestaurantsRepo extends Mock implements NearbyRestaurantsRepo {}

@GenerateMocks([MockNearbyRestaurantsRepo])
void main() {
  late NearbyUseCase nearbyUseCase;
  late MockNearbyRestaurantsRepo mockNearbyRestaurantsRepo;

  setUp(() {
    mockNearbyRestaurantsRepo = MockMockNearbyRestaurantsRepo();
    nearbyUseCase =
        NearbyUseCase(nearbyRestaurantsRepo: mockNearbyRestaurantsRepo);
  });

  group('NearbyUseCase', () {
    const double lat = 37.7749;
    const double lng = -122.4194;
    const List<String> tag = ['food'];
    const int page = 1;
    const int limit = 10;

    test(
        'returns list of nearby restaurant results when repository call is successful',
        () async {
      final mockResults = [const RestaurantModel(id: '1', name: 'restaurant')];
      final mockResponse = NearbyRestaurantsResponseModel(
          restaurants: mockResults, totalItems: 1);
      when(mockNearbyRestaurantsRepo.getNearbyRestaurants(
              lat, lng, tag, page, limit))
          .thenAnswer((_) async => Right(mockResponse));

      final result =
          await nearbyUseCase.getNearbyRestaurants(lat, lng, tag, page, limit);

      expect(result, Right(mockResponse));
      verify(mockNearbyRestaurantsRepo.getNearbyRestaurants(
          lat, lng, tag, page, limit));
      verifyNoMoreInteractions(mockNearbyRestaurantsRepo);
    });

    test('returns failure when repository call fails', () async {
      final error = ServerFailure();
      when(mockNearbyRestaurantsRepo.getNearbyRestaurants(
              lat, lng, tag, page, limit))
          .thenAnswer((_) async => Left(error));

      final result =
          await nearbyUseCase.getNearbyRestaurants(lat, lng, tag, page, limit);
      expect(result, Left(error));
      verify(mockNearbyRestaurantsRepo.getNearbyRestaurants(
          lat, lng, tag, page, limit));
      verifyNoMoreInteractions(mockNearbyRestaurantsRepo);
    });
  });
}
