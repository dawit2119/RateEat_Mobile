import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/use_cases.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/live_search/search_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/live_search/search_event.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/live_search/search_state.dart';

import 'search_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LiveSearchItemsUseCase>(),
  MockSpec<LiveSearchRestaurantsUseCase>(),
])
void main() {
  late SearchBloc searchBloc;
  late MockLiveSearchItemsUseCase mockLiveSearchItemsUseCase;
  late MockLiveSearchRestaurantsUseCase mockLiveSearchRestaurantsUseCase;

  setUp(() {
    mockLiveSearchItemsUseCase = MockLiveSearchItemsUseCase();
    mockLiveSearchRestaurantsUseCase = MockLiveSearchRestaurantsUseCase();
    searchBloc = SearchBloc(
      liveSearchItemsUseCase: mockLiveSearchItemsUseCase,
      liveSearchRestaurantsUseCase: mockLiveSearchRestaurantsUseCase,
    );
  });

  const itemSearchParams = LiveSearchItemsUseCaseParams(
    searchTerm: 'pizza',
    latitude: 0.0,
    longitude: 0.0,
  );
  final testItemResponse = [
    Item(
      itemId: '1',
      itemName: 'Pizza',
      numberOfReviews: 0,
    ),
  ];
  const testRestaurantParams = 'pizza';
  final testRestaurantResponse = [
    RestaurantResult(
      id: "id",
      name: "name",
    ),
  ];

  group('search bloc', () {
    test('initial state should be SearchInitial', () {
      expect(searchBloc.state, SearchInitial());
    });

    group('Live item Search', () {
      blocTest<SearchBloc, SearchState>(
        'emits [SearchLoading, ItemSearchLoaded] when ItemSearchEvent is successful',
        build: () {
          when(
            mockLiveSearchItemsUseCase(itemSearchParams),
          ).thenAnswer(
            (_) async => Right(testItemResponse),
          );
          return searchBloc;
        },
        act: (bloc) => bloc.add(
          ItemSearchEvent(
            query: 'pizza',
            latitude: 0.0,
            longitude: 0.0,
          ),
        ),
        expect: () => [
          SearchLoading(),
          ItemSearchLoaded(results: testItemResponse),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'emits [SearchLoading, SearchError] when ItemSearchEvent is unsuccessful',
        build: () {
          when(
            mockLiveSearchItemsUseCase(itemSearchParams),
          ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')),
          );
          return searchBloc;
        },
        act: (bloc) => bloc.add(
          ItemSearchEvent(
            query: 'pizza',
            latitude: 0.0,
            longitude: 0.0,
          ),
        ),
        expect: () => [
          SearchLoading(),
          SearchError(error: "Unable to get items"),
        ],
      );
    });

    group('Live restaurant Search', () {
      blocTest<SearchBloc, SearchState>(
        'emits [SearchLoading, RestaurantSearchLoaded] when RestaurantSearchEvent is successful',
        build: () {
          when(
            mockLiveSearchRestaurantsUseCase(
              testRestaurantParams,
            ),
          ).thenAnswer(
            (_) async => Right(testRestaurantResponse),
          );
          return searchBloc;
        },
        act: (bloc) => bloc.add(
          RestaurantSearchEvent(
            query: testRestaurantParams,
          ),
        ),
        expect: () => [
          SearchLoading(),
          RestaurantSearchLoaded(results: testRestaurantResponse),
        ],
      );

      blocTest<SearchBloc, SearchState>(
        'emits [SearchLoading, SearchError] when RestaurantSearchEvent is unsuccessful',
        build: () {
          when(
            mockLiveSearchRestaurantsUseCase(
              testRestaurantParams,
            ),
          ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')),
          );
          return searchBloc;
        },
        act: (bloc) => bloc.add(
          RestaurantSearchEvent(
            query: testRestaurantParams,
          ),
        ),
        expect: () => [
          SearchLoading(),
          SearchError(error: "Unable to get restaurants"),
        ],
      );
    });
  });
}
