import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/get_restaurant_reviews_by_popularity_usecase.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/get_restaurant_reviews_by_time_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_restaurant_reviews/get_restaurant_reviews_bloc.dart';

import 'get_restaurant_reviews_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetRestaurantReviewsByPopularityUseCase>(),
  MockSpec<GetRestaurantReviewsByTimeUseCase>(),
])
void main() {
  late GetRestaurantReviewsBloc getRestaurantReviewsBloc;
  late MockGetRestaurantReviewsByPopularityUseCase
      mockGetRestaurantReviewsByPopularityUseCase;
  late MockGetRestaurantReviewsByTimeUseCase
      mockGetRestaurantReviewsByTimeUseCase;

  setUp(() {
    mockGetRestaurantReviewsByPopularityUseCase =
        MockGetRestaurantReviewsByPopularityUseCase();
    mockGetRestaurantReviewsByTimeUseCase =
        MockGetRestaurantReviewsByTimeUseCase();
    getRestaurantReviewsBloc = GetRestaurantReviewsBloc(
      getPopularRestaurantReviewsUseCase:
          mockGetRestaurantReviewsByPopularityUseCase,
      getRecentRestaurantReviewsUseCase: mockGetRestaurantReviewsByTimeUseCase,
    );
  });

  const testRestaurantId = 'testRestaurantId';

  const testPopularParams = GetPopularRestaurantReviewsParams(
    restaurantId: testRestaurantId,
    page: 1,
    limit: 10,
  );

  const testPopularParamsNext = GetPopularRestaurantReviewsParams(
    restaurantId: testRestaurantId,
    page: 2,
    limit: 10,
  );

  const testRecentParams = GetRecentRestaurantReviewsParams(
    restaurantId: testRestaurantId,
    page: 1,
    limit: 10,
  );

  const testRecentParamsNext = GetRecentRestaurantReviewsParams(
    restaurantId: testRestaurantId,
    page: 2,
    limit: 10,
  );

  final testRestaurantReviewsResponse = RestaurantReviewsResponse(
    reviews: [],
    ratingsCount: [],
    averageRating: 0,
    numberOfReviews: 0,
  );

  group('Get Restaurant Reviews Bloc', () {
    test('initial state should be GetRestaurantReviewsInitial', () {
      // assert
      expect(
        getRestaurantReviewsBloc.state,
        const GetRestaurantReviewsInitial(
          sortType: RestaurantReviewsSortTypesState.mostRecent,
        ),
      );
    });

    group('Get Popular Restaurant Review', () {
      blocTest<GetRestaurantReviewsBloc, GetRestaurantReviewsState>(
        'emits [GetRestaurantReviewsLoading, GetRestaurantReviewsLoaded] '
        'when GetRestaurantReviewsRequestEvent(sortType: RestaurantReviewsSortTypesState.mostPopular) is added',
        build: () {
          when(mockGetRestaurantReviewsByPopularityUseCase(testPopularParams))
              .thenAnswer((_) async => Right(testRestaurantReviewsResponse));
          return getRestaurantReviewsBloc;
        },
        act: (bloc) => bloc.add(
          GetRestaurantReviewsRequestEvent(
            restaurantId: testRestaurantId,
            sortType: RestaurantReviewsSortTypesState.mostPopular,
            page: 1,
            limit: 10,
          ),
        ),
        expect: () => <GetRestaurantReviewsState>[
          const GetRestaurantReviewsLoading(
            sortType: RestaurantReviewsSortTypesState.mostPopular,
          ),
          GetRestaurantReviewsLoaded(
            reviews: testRestaurantReviewsResponse,
            sortType: RestaurantReviewsSortTypesState.mostPopular,
          ),
        ],
      );

      blocTest<GetRestaurantReviewsBloc, GetRestaurantReviewsState>(
        'emits [GetRestaurantReviewsNextLoading, GetRestaurantReviewsLoaded] '
        'when GetRestaurantReviewsRequestEvent(sortType: RestaurantReviewsSortTypesState.mostPopular, page: 2) is added with next page',
        build: () {
          when(
            mockGetRestaurantReviewsByPopularityUseCase(
              testPopularParamsNext,
            ),
          ).thenAnswer((_) async => Right(testRestaurantReviewsResponse));
          return getRestaurantReviewsBloc;
        },
        act: (bloc) => bloc.add(
          GetRestaurantReviewsRequestEvent(
            restaurantId: testRestaurantId,
            sortType: RestaurantReviewsSortTypesState.mostPopular,
            page: 2,
            limit: 10,
          ),
        ),
        expect: () => [
          GetRestaurantReviewsNextLoading(
            reviews: testRestaurantReviewsResponse,
            sortType: RestaurantReviewsSortTypesState.mostPopular,
          ),
          isA<GetRestaurantReviewsLoaded>(),
        ],
      );

      blocTest<GetRestaurantReviewsBloc, GetRestaurantReviewsState>(
        'emits [GetRestaurantReviewsLoading, GetRestaurantReviewsFailure] '
        'when GetRestaurantReviewsRequestEvent(sortType: RestaurantReviewsSortTypesState.mostPopular) is added and fails',
        build: () {
          when(mockGetRestaurantReviewsByPopularityUseCase(testPopularParams))
              .thenAnswer((_) async =>
                  Left(ServerFailure(errorMessage: "Server Error")));
          return getRestaurantReviewsBloc;
        },
        act: (bloc) => bloc.add(
          GetRestaurantReviewsRequestEvent(
            restaurantId: testRestaurantId,
            sortType: RestaurantReviewsSortTypesState.mostPopular,
            page: 1,
            limit: 10,
          ),
        ),
        expect: () => [
          const GetRestaurantReviewsLoading(
            sortType: RestaurantReviewsSortTypesState.mostPopular,
          ),
          const GetRestaurantReviewsFailure(
            message: "Server Error",
            sortType: RestaurantReviewsSortTypesState.mostPopular,
          ),
        ],
      );
    });

    group('Get Recent Restaurant Review', () {
      blocTest<GetRestaurantReviewsBloc, GetRestaurantReviewsState>(
        'emits [GetRestaurantReviewsLoading, GetRestaurantReviewsLoaded] '
        'when GetRestaurantReviewsRequestEvent(sortType: RestaurantReviewsSortTypesState.mostRecent) is added',
        build: () {
          when(mockGetRestaurantReviewsByTimeUseCase(testRecentParams))
              .thenAnswer((_) async => Right(testRestaurantReviewsResponse));
          return getRestaurantReviewsBloc;
        },
        act: (bloc) => bloc.add(
          GetRestaurantReviewsRequestEvent(
            restaurantId: testRestaurantId,
            sortType: RestaurantReviewsSortTypesState.mostRecent,
            page: 1,
            limit: 10,
          ),
        ),
        expect: () => <GetRestaurantReviewsState>[
          const GetRestaurantReviewsLoading(
            sortType: RestaurantReviewsSortTypesState.mostRecent,
          ),
          GetRestaurantReviewsLoaded(
            reviews: testRestaurantReviewsResponse,
            sortType: RestaurantReviewsSortTypesState.mostRecent,
          ),
        ],
      );

      blocTest<GetRestaurantReviewsBloc, GetRestaurantReviewsState>(
        'emits [GetRestaurantReviewsNextLoading, GetRestaurantReviewsLoaded] '
        'when GetRestaurantReviewsRequestEvent(sortType: RestaurantReviewsSortTypesState.mostRecent, page: 2) is added with next page',
        build: () {
          when(
            mockGetRestaurantReviewsByTimeUseCase(testRecentParamsNext),
          ).thenAnswer((_) async => Right(testRestaurantReviewsResponse));
          return getRestaurantReviewsBloc;
        },
        act: (bloc) => bloc.add(
          GetRestaurantReviewsRequestEvent(
            restaurantId: testRestaurantId,
            sortType: RestaurantReviewsSortTypesState.mostRecent,
            page: 2,
            limit: 10,
          ),
        ),
        expect: () => [
          GetRestaurantReviewsNextLoading(
            reviews: testRestaurantReviewsResponse,
            sortType: RestaurantReviewsSortTypesState.mostRecent,
          ),
          isA<GetRestaurantReviewsLoaded>(),
        ],
      );

      blocTest<GetRestaurantReviewsBloc, GetRestaurantReviewsState>(
        'emits [GetRestaurantReviewsLoading, GetRestaurantReviewsFailure] '
        'when GetRestaurantReviewsRequestEvent(sortType: RestaurantReviewsSortTypesState.mostRecent) is added and fails',
        build: () {
          when(mockGetRestaurantReviewsByTimeUseCase(testRecentParams))
              .thenAnswer((_) async =>
                  Left(ServerFailure(errorMessage: "Server Error")));
          return getRestaurantReviewsBloc;
        },
        act: (bloc) => bloc.add(
          GetRestaurantReviewsRequestEvent(
            restaurantId: testRestaurantId,
            sortType: RestaurantReviewsSortTypesState.mostRecent,
            page: 1,
            limit: 10,
          ),
        ),
        expect: () => [
          const GetRestaurantReviewsLoading(
            sortType: RestaurantReviewsSortTypesState.mostRecent,
          ),
          const GetRestaurantReviewsFailure(
            message: "Server Error",
            sortType: RestaurantReviewsSortTypesState.mostRecent,
          ),
        ],
      );
    });
  });
}
