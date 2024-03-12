import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'all_restaurants_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<MapFunctionRepo>(),
])
void main() {
  late AllRestaurantsBloc allRestaurantsBloc;
  late MockMapFunctionRepo mockMapFunctionRepo;

  const int limit = 200;
  const double latitude = 0.0;
  const double longitude = 0.0;
  const double radius = 5000.0;

  setUp(() {
    mockMapFunctionRepo = MockMapFunctionRepo();
    allRestaurantsBloc =
        AllRestaurantsBloc(mapFunctionRepo: mockMapFunctionRepo);

    when(
      mockMapFunctionRepo.fetchAllRestaurants(
        limit: limit,
        latitude: latitude,
        longitude: longitude,
        radius: radius,
      ),
    ).thenAnswer(
        (_) async => Right(AllRestaurantsSuccess(restaurants: const [])));
  });

  group('All Restaurants Bloc', () {
    // the initial state is loading because of the timer updates
    test('initial state should be AllRestaurantsLoading', () {
      // assert
      expect(allRestaurantsBloc.state, AllRestaurantsLoading());
    });

    group('fetch all restaurants', () {
      blocTest<AllRestaurantsBloc, AllRestaurantsState>(
        'should emit [ AllRestaurantsLoading,  AllRestaurantsSuccess] when GetAllRestaurants is called.',
        build: () {
          when(
            mockMapFunctionRepo.fetchAllRestaurants(
              limit: limit,
              latitude: latitude,
              longitude: longitude,
              radius: radius,
            ),
          ).thenAnswer(
              (_) async => Right(AllRestaurantsSuccess(restaurants: const [])));
          return allRestaurantsBloc;
        },
        act: (bloc) => bloc.add(GetAllRestaurants(
          limit: limit,
          latitude: latitude,
          longitude: longitude,
          radius: radius,
        )),
        expect: () => <AllRestaurantsState>[
          AllRestaurantsLoading(),
          AllRestaurantsSuccess(restaurants: const []),
        ],
      );
      blocTest<AllRestaurantsBloc, AllRestaurantsState>(
        'should emit [ AllRestaurantsLoading,  AllRestaurantsFailure] when GetAllRestaurants is called.',
        build: () {
          when(
            mockMapFunctionRepo.fetchAllRestaurants(
              limit: limit,
              latitude: latitude,
              longitude: longitude,
              radius: radius,
            ),
          ).thenAnswer((_) async =>
              Left(NetworkFailure(errorMessage: 'Network Failure')));
          return allRestaurantsBloc;
        },
        act: (bloc) => bloc.add(GetAllRestaurants(
          limit: limit,
          latitude: latitude,
          longitude: longitude,
          radius: radius,
        )),
        expect: () => <AllRestaurantsState>[
          AllRestaurantsLoading(),
          AllRestaurantsFailure(message: 'Network Failure'),
        ],
      );
    });

    group('reset all restaurants', () {
      blocTest<AllRestaurantsBloc, AllRestaurantsState>(
        'should emit [ AllRestaurantsInitial] when ResetAllRestaurantsEvent is called.',
        build: () {
          return allRestaurantsBloc;
        },
        act: (bloc) => bloc.add(ResetAllRestaurantsEvent()),
        expect: () => <AllRestaurantsState>[
          AllRestaurantsInitial(),
        ],
      );
    });
  });
}
