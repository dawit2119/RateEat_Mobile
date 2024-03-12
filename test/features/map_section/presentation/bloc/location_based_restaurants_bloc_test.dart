import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/map_section/domain/use_cases/get_location_based_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/bloc/location_based_restaurants/location_based_restaurants_bloc.dart';

import 'location_based_restaurants_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocationBasedRestaurantUseCase>(),
])
void main() {
  late LocationBasedRestaurantsBloc locationBasedRestaurantsBloc;
  late MockLocationBasedRestaurantUseCase mockLocationBasedRestaurantUseCase;

  setUp(() {
    mockLocationBasedRestaurantUseCase = MockLocationBasedRestaurantUseCase();
    locationBasedRestaurantsBloc = LocationBasedRestaurantsBloc(
      searchRestaurantsCountUseCase: mockLocationBasedRestaurantUseCase,
    );
  });

  const double lat = 1.0;
  const double long = 1.0;
  const double radius = 1.0;
  const params = LocationBasedRestaurantParams(
    lat: lat,
    long: long,
    radius: radius,
  );

  group('Location Based Restaurants Bloc', () {
    test('initial state should be LocationBasedRestaurantsInitial', () {
      // assert
      expect(locationBasedRestaurantsBloc.state,
          LocationBasedRestaurantsInitial());
    });

    group('get restaurants count', () {
      blocTest<LocationBasedRestaurantsBloc, LocationBasedRestaurantsState>(
        'should emit [GetLocationBasedRestaurants(status: RestaurantStatus.loading), GetLocationBasedRestaurants(status: RestaurantStatus.loaded)] when GetRestaurantsCountEvent is called.',
        build: () {
          when(
            mockLocationBasedRestaurantUseCase(
              params,
            ),
          ).thenAnswer((_) async => const Right(1));
          return locationBasedRestaurantsBloc;
        },
        act: (bloc) => bloc.add(
          GetRestaurantsCountEvent(
            lat: lat,
            long: long,
            radius: radius,
          ),
        ),
        expect: () => <LocationBasedRestaurantsState>[
          GetLocationBasedRestaurants(status: RestaurantStatus.loading),
          GetLocationBasedRestaurants(
              status: RestaurantStatus.loaded, count: 1),
        ],
      );

      blocTest<LocationBasedRestaurantsBloc, LocationBasedRestaurantsState>(
        'should emit [GetLocationBasedRestaurants(status: RestaurantStatus.loading), GetLocationBasedRestaurants(status: RestaurantStatus.error)] when GetRestaurantsCountEvent is called.',
        build: () {
          when(
            mockLocationBasedRestaurantUseCase(
              params,
            ),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: "Server Error")));
          return locationBasedRestaurantsBloc;
        },
        act: (bloc) => bloc.add(
            GetRestaurantsCountEvent(lat: lat, long: long, radius: radius)),
        expect: () => <LocationBasedRestaurantsState>[
          GetLocationBasedRestaurants(status: RestaurantStatus.loading),
          GetLocationBasedRestaurants(
              status: RestaurantStatus.error, errorMessage: "Server Error"),
        ],
      );
    });
  });
}
