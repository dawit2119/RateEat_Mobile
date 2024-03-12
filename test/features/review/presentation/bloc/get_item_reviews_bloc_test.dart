import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/item_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/get_item_reviews_by_popularity_usecase.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/get_item_reviews_by_time_usecase.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_item_reviews/get_item_reviews_bloc.dart';

import 'get_item_reviews_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetItemReviewsByPopularityUseCase>(),
  MockSpec<GetItemReviewsByTimeUseCase>(),
])
void main() {
  late GetItemReviewsBloc getItemReviewsBloc;
  late MockGetItemReviewsByPopularityUseCase
      mockGetItemReviewsByPopularityUseCase;
  late MockGetItemReviewsByTimeUseCase mockGetItemReviewsByTimeUseCase;

  setUp(() {
    mockGetItemReviewsByPopularityUseCase =
        MockGetItemReviewsByPopularityUseCase();
    mockGetItemReviewsByTimeUseCase = MockGetItemReviewsByTimeUseCase();
    getItemReviewsBloc = GetItemReviewsBloc(
      getItemReviewsByPopularityUseCase: mockGetItemReviewsByPopularityUseCase,
      getItemReviewsByTimeUseCase: mockGetItemReviewsByTimeUseCase,
    );
  });

  const testMessage = 'testMessage';
  const testItemId = 'testItemId';
  const testPopularParams = GetItemReviewsByPopularityParams(
    itemId: testItemId,
    page: 1,
    limit: 10,
  );
  const testPopularParamsNext = GetItemReviewsByPopularityParams(
    itemId: testItemId,
    page: 2,
    limit: 10,
  );
  const testRecentParams = GetItemReviewsByTimeParams(
    itemId: testItemId,
    page: 1,
    limit: 10,
  );
  const testRecentParamsNext = GetItemReviewsByTimeParams(
    itemId: testItemId,
    page: 2,
    limit: 10,
  );

  final testItemReviewsResponse = ItemReviewsResponse(
    reviews: [],
    ratingsCount: [],
    averageRating: 0,
    numberOfReviews: 0,
  );

  group('Get Item Reviews Bloc', () {
    test('initial state should be GetItemReviewsInitial', () {
      // assert
      expect(
          getItemReviewsBloc.state,
          const GetItemReviewsInitial(
              sortType: ItemReviewsSortTypesState.mostRecent));
    });
    group('Get Popular Item Review', () {
      blocTest<GetItemReviewsBloc, GetItemReviewsState>(
        'should emit [ GetItemReviewsLoading, GetItemReviewsLoaded] when GetItemReviewsRequestEvent(sortType: ItemReviewsSortTypesState.mostPopular) is added.',
        build: () {
          when(
            mockGetItemReviewsByPopularityUseCase(testPopularParams),
          ).thenAnswer((_) async => Right(testItemReviewsResponse));

          return getItemReviewsBloc;
        },
        act: (bloc) => bloc.add(
          GetItemReviewsRequestEvent(
            itemId: testItemId,
            page: 1,
            limit: 10,
            sortType: ItemReviewsSortTypesState.mostPopular,
          ),
        ),
        expect: () => <GetItemReviewsState>[
          const GetItemReviewsLoading(
            sortType: ItemReviewsSortTypesState.mostPopular,
          ),
          GetItemReviewsLoaded(
            sortType: ItemReviewsSortTypesState.mostPopular,
            reviews: testItemReviewsResponse,
          ),
        ],
      );

      blocTest<GetItemReviewsBloc, GetItemReviewsState>(
        'should emit [ GetItemReviewsNextLoading, GetItemReviewsLoaded] when GetItemReviewsRequestEvent(sortType: ItemReviewsSortTypesState.mostPopular, page: 2) is added.',
        build: () {
          when(
            mockGetItemReviewsByPopularityUseCase(testPopularParamsNext),
          ).thenAnswer((_) async => Right(testItemReviewsResponse));

          return getItemReviewsBloc;
        },
        act: (bloc) => bloc.add(
          GetItemReviewsRequestEvent(
            itemId: testItemId,
            page: 2,
            limit: 10,
            sortType: ItemReviewsSortTypesState.mostPopular,
          ),
        ),
        expect: () => [
          GetItemReviewsNextLoading(
            reviews: testItemReviewsResponse,
            sortType: ItemReviewsSortTypesState.mostPopular,
          ),
          isA<GetItemReviewsLoaded>(),
        ],
      );

      blocTest<GetItemReviewsBloc, GetItemReviewsState>(
        'should emit [ GetItemReviewsLoading, GetItemReviewsError] when GetItemReviewsRequestEvent(sortType: ItemReviewsSortTypesState.mostPopular) is added.',
        build: () {
          when(
            mockGetItemReviewsByPopularityUseCase(testPopularParams),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'Server Error')));

          return getItemReviewsBloc;
        },
        act: (bloc) => bloc.add(
          GetItemReviewsRequestEvent(
            itemId: testItemId,
            page: 1,
            limit: 10,
            sortType: ItemReviewsSortTypesState.mostPopular,
          ),
        ),
        expect: () => <GetItemReviewsState>[
          const GetItemReviewsLoading(
              sortType: ItemReviewsSortTypesState.mostPopular),
          const GetItemReviewsFailure(
            message: 'Server Error',
            sortType: ItemReviewsSortTypesState.mostPopular,
          ),
        ],
      );
    });

    group('Get Recent Item Review', () {
      blocTest<GetItemReviewsBloc, GetItemReviewsState>(
        'should emit [ GetItemReviewsLoading, GetItemReviewsLoaded] when GetItemReviewsRequestEvent(sortType: ItemReviewsSortTypesState.mostRecent) is added.',
        build: () {
          when(
            mockGetItemReviewsByTimeUseCase(
              testRecentParams,
            ),
          ).thenAnswer((_) async => Right(testItemReviewsResponse));

          return getItemReviewsBloc;
        },
        act: (bloc) => bloc.add(
          GetItemReviewsRequestEvent(
            itemId: testItemId,
            page: 1,
            limit: 10,
            sortType: ItemReviewsSortTypesState.mostRecent,
          ),
        ),
        expect: () => <GetItemReviewsState>[
          const GetItemReviewsLoading(
              sortType: ItemReviewsSortTypesState.mostRecent),
          GetItemReviewsLoaded(
            sortType: ItemReviewsSortTypesState.mostRecent,
            reviews: testItemReviewsResponse,
          ),
        ],
      );

      blocTest<GetItemReviewsBloc, GetItemReviewsState>(
        'should emit [ GetItemReviewsNextLoading, GetItemReviewsLoaded] when GetItemReviewsRequestEvent(sortType: ItemReviewsSortTypesState.mostRecent, page: 2) is added.',
        build: () {
          when(
            mockGetItemReviewsByTimeUseCase(testRecentParamsNext),
          ).thenAnswer((_) async => Right(testItemReviewsResponse));

          return getItemReviewsBloc;
        },
        act: (bloc) => bloc.add(
          GetItemReviewsRequestEvent(
            itemId: testItemId,
            page: 2,
            limit: 10,
            sortType: ItemReviewsSortTypesState.mostRecent,
          ),
        ),
        expect: () => [
          GetItemReviewsNextLoading(
            reviews: testItemReviewsResponse,
            sortType: ItemReviewsSortTypesState.mostRecent,
          ),
          isA<GetItemReviewsLoaded>(),
        ],
      );

      blocTest<GetItemReviewsBloc, GetItemReviewsState>(
        'should emit [ GetItemReviewsLoading, GetItemReviewsError] when GetItemReviewsRequestEvent(sortType: ItemReviewsSortTypesState.mostRecent) is added.',
        build: () {
          when(
            mockGetItemReviewsByTimeUseCase(
              testRecentParams,
            ),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'Server Error')));

          return getItemReviewsBloc;
        },
        act: (bloc) => bloc.add(
          GetItemReviewsRequestEvent(
            itemId: testItemId,
            page: 1,
            limit: 10,
            sortType: ItemReviewsSortTypesState.mostRecent,
          ),
        ),
        expect: () => <GetItemReviewsState>[
          const GetItemReviewsLoading(
            sortType: ItemReviewsSortTypesState.mostRecent,
          ),
          const GetItemReviewsFailure(
            message: 'Server Error',
            sortType: ItemReviewsSortTypesState.mostRecent,
          ),
        ],
      );
    });
  });
}
