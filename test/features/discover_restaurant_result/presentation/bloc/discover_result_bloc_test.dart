import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/discover_restaurant_result_model.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/domain/use_cases/discover_restaurant_use_case.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/bloc/restaurant_bloc/discover_result_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/bloc/restaurant_bloc/discover_result_event.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/bloc/restaurant_bloc/discover_result_state.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'discover_result_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<DiscoverRestaurantUseCase>(),
])
void main() {
  late FetchDiscoverRestaurantResultBloc fetchDiscoverRestaurantResultBloc;
  late MockDiscoverRestaurantUseCase mockDiscoverRestaurantUseCase;

  setUp(() {
    mockDiscoverRestaurantUseCase = MockDiscoverRestaurantUseCase();
    fetchDiscoverRestaurantResultBloc = FetchDiscoverRestaurantResultBloc(
      discoverRestaurantUseCase: mockDiscoverRestaurantUseCase,
    );
  });

  const testParam = DiscoverRestaurantParams(
    fasting: false,
    latitude: 0.0,
    longitude: 0.0,
    radius: 1000,
    maxPrice: 5000,
    minRating: 0,
    tags: ["test"],
    sorting: "rating",
    limit: 10,
    page: 1,
    maxTravelTime: 5,
    transportMode: TransportMode.driving,
  );
  final testStepper = DiscoveryStepsBloc();
  testStepper.add(
    const DiscoveryFilterUpdate(
      tags: ["test"],
      distanceToTravel: 1000,
      latitude: 0.0,
      longitude: 0.0,
      maxPrice: 5000,
      minPrice: 0,
      minRating: 0,
      fasting: false,
      searchQuery: "",
      sorting: "rating",
      page: 1,
      maxTravelTime: 5,
      transportMode: TransportMode.driving,
    ),
  );

  const testNextParam = DiscoverRestaurantParams(
    fasting: false,
    latitude: 0.0,
    longitude: 0.0,
    radius: 1000,
    maxPrice: 5000,
    minRating: 0,
    tags: ["test"],
    sorting: "rating",
    limit: 10,
    page: 2,
    maxTravelTime: 5,
    transportMode: TransportMode.driving,
  );
  final testNextStepper = DiscoveryStepsBloc();
  testNextStepper.add(
    const DiscoveryFilterUpdate(
      tags: ["test"],
      distanceToTravel: 1000,
      latitude: 0.0,
      longitude: 0.0,
      maxPrice: 5000,
      minPrice: 0,
      minRating: 0,
      fasting: false,
      searchQuery: "",
      sorting: "rating",
      page: 2,
      maxTravelTime: 5,
      transportMode: TransportMode.driving,
    ),
  );

  const testResponse = [
    DiscoverRestaurantResultModel(
      id: "1",
      name: "test",
      distance: 1000,
    )
  ];

  group('Discover Restaurant Result Bloc', () {
    test('initial state should be DiscoverRestaurantInitial', () {
      // assert
      expect(
          fetchDiscoverRestaurantResultBloc.state, DiscoverRestaurantInitial());
    });

    group('fetch discover restaurant result', () {
      blocTest<FetchDiscoverRestaurantResultBloc,
          FetchDiscoverRestaurantResultState>(
        'should emit [ DiscoverRestaurantLoading,  DiscoverRestaurantLoaded] when FetchNewDiscoverRestaurantResultEvent is called.',
        build: () {
          when(
            mockDiscoverRestaurantUseCase(
              testParam,
            ),
          ).thenAnswer((_) async => const Right(testResponse));
          return fetchDiscoverRestaurantResultBloc;
        },
        act: (bloc) => bloc.add(
          FetchNewDiscoverRestaurantResultEvent(
            discoveryStepsBloc: testStepper,
          ),
        ),
        expect: () => <FetchDiscoverRestaurantResultState>[
          DiscoverRestaurantLoading(),
          DiscoverRestaurantLoaded(discoveredRestaurantResults: testResponse),
        ],
      );

      blocTest<FetchDiscoverRestaurantResultBloc,
          FetchDiscoverRestaurantResultState>(
        'should emit [ DiscoverRestaurantLoading,  DiscoverRestaurantError] when FetchNewDiscoverRestaurantResultEvent is called.',
        build: () {
          when(
            mockDiscoverRestaurantUseCase(
              testParam,
            ),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'server error')));
          return fetchDiscoverRestaurantResultBloc;
        },
        act: (bloc) => bloc.add(
          FetchNewDiscoverRestaurantResultEvent(
            discoveryStepsBloc: testStepper,
          ),
        ),
        expect: () => <FetchDiscoverRestaurantResultState>[
          DiscoverRestaurantLoading(),
          DiscoverRestaurantError(errorMessage: 'server error'),
        ],
      );
    });

    group('load more restaurant result', () {
      blocTest<FetchDiscoverRestaurantResultBloc,
          FetchDiscoverRestaurantResultState>(
        'should emit [ DiscoverRestaurantLoading,  DiscoverRestaurantLoaded] when LoadMoreDiscoverRestaurantResultEvent(page: 1) is called.',
        build: () {
          when(
            mockDiscoverRestaurantUseCase(
              testParam,
            ),
          ).thenAnswer((_) async => const Right(testResponse));
          return fetchDiscoverRestaurantResultBloc;
        },
        act: (bloc) => bloc.add(
          LoadMoreDiscoverRestaurantResultEvent(
            discoveryStepsBloc: testStepper,
          ),
        ),
        expect: () => <FetchDiscoverRestaurantResultState>[
          DiscoverRestaurantLoading(),
          DiscoverRestaurantLoaded(
            discoveredRestaurantResults: testResponse,
            searchLoadingStatus: false,
          ),
        ],
      );
      blocTest<FetchDiscoverRestaurantResultBloc,
          FetchDiscoverRestaurantResultState>(
        'should emit [ DiscoverRestaurantsNextLoading, DiscoverRestaurantLoaded] when LoadMoreDiscoverRestaurantResultEvent(page: 2) is called.',
        build: () {
          when(
            mockDiscoverRestaurantUseCase(
              testNextParam,
            ),
          ).thenAnswer((_) async => const Right(testResponse));
          return fetchDiscoverRestaurantResultBloc;
        },
        act: (bloc) => bloc.add(
          LoadMoreDiscoverRestaurantResultEvent(
            discoveryStepsBloc: testNextStepper,
          ),
        ),
        expect: () => <FetchDiscoverRestaurantResultState>[
          DiscoverRestaurantsNextLoading(
            discoveredRestaurantResults: const [],
          ),
          DiscoverRestaurantLoaded(
            discoveredRestaurantResults: testResponse,
            searchLoadingStatus: false,
          ),
        ],
      );

      blocTest<FetchDiscoverRestaurantResultBloc,
          FetchDiscoverRestaurantResultState>(
        'should emit [ DiscoverRestaurantLoading,  DiscoverRestaurantError] when LoadMoreDiscoverRestaurantResultEvent is called.',
        build: () {
          when(
            mockDiscoverRestaurantUseCase(
              testParam,
            ),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'server error')));
          return fetchDiscoverRestaurantResultBloc;
        },
        act: (bloc) => bloc.add(
          LoadMoreDiscoverRestaurantResultEvent(
            discoveryStepsBloc: testStepper,
          ),
        ),
        expect: () => <FetchDiscoverRestaurantResultState>[
          DiscoverRestaurantLoading(),
          DiscoverRestaurantError(errorMessage: 'server error'),
        ],
      );
    });
  });
}
