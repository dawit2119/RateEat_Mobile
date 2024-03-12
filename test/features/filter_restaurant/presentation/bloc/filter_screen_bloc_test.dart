import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/filter_restaurants/filter_restaurants.dart';

import 'filter_screen_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FilterRestaurantUseCase>(),
  MockSpec<GetRatingUseCase>(),
  MockSpec<GetPriceRangeUseCase>(),
  MockSpec<GetPriceUseCase>(),
])
void main() {
  late FilterBloc filterBloc;
  late MockFilterRestaurantUseCase mockFilterRestaurantUseCase;
  late MockGetRatingUseCase mockGetRatingUseCase;
  late MockGetPriceRangeUseCase mockGetPriceRangeUseCase;
  late MockGetPriceUseCase mockGetPriceUseCase;

  setUp(() {
    mockFilterRestaurantUseCase = MockFilterRestaurantUseCase();
    mockGetRatingUseCase = MockGetRatingUseCase();
    mockGetPriceRangeUseCase = MockGetPriceRangeUseCase();
    mockGetPriceUseCase = MockGetPriceUseCase();
    filterBloc = FilterBloc(
      filterRestaurantUseCase: mockFilterRestaurantUseCase,
      getRatingUseCase: mockGetRatingUseCase,
      getPriceRangeUseCase: mockGetPriceRangeUseCase,
      getPriceUseCase: mockGetPriceUseCase,
    );
  });

  group('FilterBloc', () {
    test('initial state should be FilteringInitial', () {
      // assert
      expect(filterBloc.state, FilteringInitial());
    });

    group('FilterSubmittedEvent', () {
      blocTest<FilterBloc, FilteringState>(
        'should emit [FilterLoading, FilterLoaded] when FilterSubmittedEvent is added.',
        build: () {
          when(
            mockFilterRestaurantUseCase(const FilterRestaurantParams(
              query: 'testQuery',
            )),
          ).thenAnswer((_) async => const Right([]));

          return filterBloc;
        },
        act: (bloc) => bloc.add(
          FilterSubmittedEvent(
            query: 'testQuery',
          ),
        ),
        expect: () => <FilteringState>[
          FilterLoading(),
          FilterLoaded(results: const []),
        ],
      );

      blocTest<FilterBloc, FilteringState>(
        'should emit [FilterLoading, FilterError] when FilterSubmittedEvent is added.',
        build: () {
          when(
            mockFilterRestaurantUseCase(const FilterRestaurantParams(
              query: 'testQuery',
            )),
          ).thenAnswer((_) async =>
              Left(ServerFailure(errorMessage: 'ServerException')));

          return filterBloc;
        },
        act: (bloc) => bloc.add(
          FilterSubmittedEvent(
            query: 'testQuery',
          ),
        ),
        expect: () => <FilteringState>[
          FilterLoading(),
          FilterError(message: 'Failed'),
        ],
      );
    });

    group('RatingChangedEvent', () {
      blocTest<FilterBloc, FilteringState>(
        'should emit [RatingLoading, RatingLoaded] when RatingChangedEvent is added.',
        build: () {
          when(
            mockGetRatingUseCase(const GetRatingParams(
              rating: 'testRating',
              location: 'testLocation',
            )),
          ).thenAnswer((_) async => const Right('testRatingQuery'));

          return filterBloc;
        },
        act: (bloc) => bloc.add(
          RatingChangedEvent(
            rating: 'testRating',
            location: 'testLocation',
          ),
        ),
        expect: () => <FilteringState>[
          RatingLoading(),
          RatingLoaded(result: 'testRatingQuery'),
        ],
      );

      blocTest<FilterBloc, FilteringState>(
        'should emit [RatingLoading, RatingError] when RatingChangedEvent is added.',
        build: () {
          when(
            mockGetRatingUseCase(const GetRatingParams(
              rating: 'testRating',
              location: 'testLocation',
            )),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure(errorMessage: 'ServerException'),
            ),
          );

          return filterBloc;
        },
        act: (bloc) => bloc.add(
          RatingChangedEvent(
            rating: 'testRating',
            location: 'testLocation',
          ),
        ),
        expect: () => <FilteringState>[
          RatingLoading(),
          RatingError(message: 'Failed'),
        ],
      );
    });

    group('PriceChangedEvent', () {
      blocTest<FilterBloc, FilteringState>(
        'should emit [PriceLoading, PriceLoaded] when PriceChangedEvent is added.',
        build: () {
          when(
            mockGetPriceUseCase(const GetPriceParams(
              price: 'testPrice',
              location: 'testLocation',
            )),
          ).thenAnswer((_) async => const Right('testPriceQuery'));

          return filterBloc;
        },
        act: (bloc) => bloc.add(
          PriceChangedEvent(
            price: 'testPrice',
            location: 'testLocation',
          ),
        ),
        expect: () => <FilteringState>[
          PriceLoading(),
          PriceLoaded(result: 'testPriceQuery'),
        ],
      );

      blocTest<FilterBloc, FilteringState>(
        'should emit [PriceLoading, PriceError] when PriceChangedEvent is added.',
        build: () {
          when(
            mockGetPriceUseCase(const GetPriceParams(
              price: 'testPrice',
              location: 'testLocation',
            )),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure(errorMessage: 'ServerException'),
            ),
          );

          return filterBloc;
        },
        act: (bloc) => bloc.add(
          PriceChangedEvent(
            price: 'testPrice',
            location: 'testLocation',
          ),
        ),
        expect: () => <FilteringState>[
          PriceLoading(),
          PriceError(message: 'Failed'),
        ],
      );
    });

    group('PriceRangeChangedEvent', () {
      blocTest<FilterBloc, FilteringState>(
        'should emit [PriceRangeLoading, PriceRangeLoaded] when PriceRangeChangedEvent is added.',
        build: () {
          when(
            mockGetPriceRangeUseCase(const GetPriceRangeParams(
              priceRange: 'testPriceRange',
              location: 'testLocation',
            )),
          ).thenAnswer((_) async => const Right('testPriceRangeQuery'));

          return filterBloc;
        },
        act: (bloc) => bloc.add(
          PriceRangeChangedEvent(
            priceRange: 'testPriceRange',
            location: 'testLocation',
          ),
        ),
        expect: () => <FilteringState>[
          PriceRangeLoading(),
          PriceRangeLoaded(result: 'testPriceRangeQuery'),
        ],
      );

      blocTest<FilterBloc, FilteringState>(
        'should emit [PriceRangeLoading, PriceRangeError] when PriceRangeChangedEvent is added.',
        build: () {
          when(
            mockGetPriceRangeUseCase(const GetPriceRangeParams(
              priceRange: 'testPriceRange',
              location: 'testLocation',
            )),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure(errorMessage: 'ServerException'),
            ),
          );

          return filterBloc;
        },
        act: (bloc) => bloc.add(
          PriceRangeChangedEvent(
            priceRange: 'testPriceRange',
            location: 'testLocation',
          ),
        ),
        expect: () => <FilteringState>[
          PriceRangeLoading(),
          PriceRangeError(message: 'Failed'),
        ],
      );
    });
  });
}
