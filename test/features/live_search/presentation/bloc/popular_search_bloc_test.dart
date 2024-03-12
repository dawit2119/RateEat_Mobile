import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/entities/popular_search_items.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/get_popular_search_items.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/popular_searches/popular_search_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/popular_searches/popular_search_event.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/popular_searches/popular_search_state.dart';

import 'popular_search_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetPopularSearchesUseCase>(),
])
void main() {
  late PopularSearchesBloc popularSearchesBloc;
  late MockGetPopularSearchesUseCase mockGetPopularSearchesUseCase;

  setUp(() {
    mockGetPopularSearchesUseCase = MockGetPopularSearchesUseCase();
    popularSearchesBloc = PopularSearchesBloc(
      getPopularSearchesUseCase: mockGetPopularSearchesUseCase,
    );
  });

  const testResponse = PopularSearchItems(
    items: ['pizza', 'burger'],
    restaurants: ['pizza', 'burger'],
  );
  const testParams = GetPopularSearchesParams(
    page: 1,
    limit: 7,
  );

  group('popular search bloc', () {
    test('initial state should be PopularSearchesInitial', () {
      expect(popularSearchesBloc.state, PopularSearchesInitial());
    });
    blocTest<PopularSearchesBloc, PopularSearchesState>(
      'emits [PopularSearchesLoading, PopularSearchesLoaded] when GetPopularSearches is successful',
      build: () {
        when(
          mockGetPopularSearchesUseCase(
            testParams,
          ),
        ).thenAnswer(
          (_) async => const Right(testResponse),
        );
        return popularSearchesBloc;
      },
      act: (bloc) => bloc.add(
        GetPopularSearches(
          page: 1,
          limit: 7,
        ),
      ),
      expect: () => [
        PopularSearchActionsLoading(),
        PopularSearchesLoaded(
          popularSearchItems: testResponse,
        ),
      ],
    );

    blocTest<PopularSearchesBloc, PopularSearchesState>(
      'emits [PopularSearchesLoading, PopularSearchesFailed] when GetPopularSearches is unsuccessful',
      build: () {
        when(
          mockGetPopularSearchesUseCase(
            testParams,
          ),
        ).thenAnswer(
          (_) async => Left(ServerFailure(errorMessage: 'Server Error')),
        );
        return popularSearchesBloc;
      },
      act: (bloc) => bloc.add(
        GetPopularSearches(
          page: 1,
          limit: 7,
        ),
      ),
      expect: () => [
        PopularSearchActionsLoading(),
        PopularSearchActionsFailed(
          message: "Unable to get popular searches",
        ),
      ],
    );
  });
}
