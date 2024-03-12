import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/data_sources/local_nearby_restaurant_data_provider.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/entities/nearby_restaurants_response.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/use_cases/nearby_usecase.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_event.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/nearby_rest_state.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'nearby_bloc_test.mocks.dart';

@GenerateNiceMocks(
    [MockSpec<NearbyUseCase>(), MockSpec<LocalNearbyRestaurantDataProvider>()])
void main() {
  group('NearbyRestaurantBloc', () {
    late HomePageNearbyRestaurantBloc nearbyRestaurantBloc;
    late MockNearbyUseCase mockNearbyUseCase;
    late MockLocalNearbyRestaurantDataProvider
        mockLocalNearbyRestaurantDataProvider;

    setUp(() {
      mockNearbyUseCase = MockNearbyUseCase();
      nearbyRestaurantBloc =
          HomePageNearbyRestaurantBloc(nearbyUseCase: mockNearbyUseCase);

      mockLocalNearbyRestaurantDataProvider =
          MockLocalNearbyRestaurantDataProvider();
      dpLocator.registerSingleton<LocalNearbyRestaurantDataProvider>(
          mockLocalNearbyRestaurantDataProvider);
    });
    double lat = 0;
    double lng = 0;
    List<String> tags = [];
    int page = 1;
    int limit = 10;
    final event = GetNearByRestaurants(
      lat: lat,
      lng: lng,
      tags: tags,
      page: page,
      limit: limit,
    );
    test(
        'emits loading and success states when nearby restaurants are fetched successfully',
        () async {
      final List<RestaurantModel> mockResults = [
        const RestaurantModel(id: '1', name: 'Restaurant 1'),
        const RestaurantModel(id: '2', name: 'Restaurant 2'),
      ];

      when(mockLocalNearbyRestaurantDataProvider.getNearbyRestaurants())
          .thenAnswer((_) async => mockResults);

      when(mockNearbyUseCase.getNearbyRestaurants(lat, lng, tags, page, limit))
          .thenAnswer(
        (_) async => const Right(
          NearbyRestaurantsResponse(restaurants: [
            RestaurantModel(
              id: '1',
              name: 'Restaurant 1',
              distance: '10',
            )
          ], totalItems: 1),
        ),
      );
      when(mockLocalNearbyRestaurantDataProvider.clearNearbyRestaurants())
          .thenAnswer((_) async => null);
      when(mockLocalNearbyRestaurantDataProvider
              .cacheNearbyRestaurants(mockResults))
          .thenAnswer((_) async => null);
      nearbyRestaurantBloc.add(event);

      await expectLater(
        nearbyRestaurantBloc.stream,
        emitsInOrder([
          NearbyLoading(),
          NearbyRestaurantFetched(restaurants: mockResults),
        ]),
      );
    });

    test(
        'emits loading and error states when nearby restaurants fetching fails',
        () async {
      final failure = ServerFailure();

      when(mockLocalNearbyRestaurantDataProvider.getNearbyRestaurants())
          .thenAnswer((_) async => []);

      when(mockNearbyUseCase.getNearbyRestaurants(lat, lng, tags, page, limit))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'error')));

      when(mockLocalNearbyRestaurantDataProvider.clearNearbyRestaurants())
          .thenAnswer((_) async => null);

      when(mockLocalNearbyRestaurantDataProvider.cacheNearbyRestaurants([]))
          .thenAnswer((_) async => null);

      nearbyRestaurantBloc.add(event);

      await expectLater(
        nearbyRestaurantBloc.stream,
        emitsInOrder([
          NearbyLoading(),
          NearbyRestaurantFailure(err: failure.errorMessage),
        ]),
      );
    });
  });
}
