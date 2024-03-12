import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/live_search/data/data_sources/local_search_history_data_source.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/history.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/use_cases.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/local_history/local_search_history_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/local_history/local_search_history_event.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/local_history/local_search_history_state.dart';

import 'local_search_history_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AddLocalSearchHistoryUseCase>(),
  MockSpec<ClearLocalHistoryUseCase>(),
  MockSpec<DeleteLocalHistoryUseCase>(),
  MockSpec<GetLocalHistoryUseCase>(),
])
void main() {
  late LocalSearchHistoryBloc localSearchHistoryBloc;
  late MockAddLocalSearchHistoryUseCase mockAddLocalSearchHistoryUseCase;
  late MockClearLocalHistoryUseCase mockClearLocalHistoryUseCase;
  late MockDeleteLocalHistoryUseCase mockDeleteLocalHistoryUseCase;
  late MockGetLocalHistoryUseCase mockGetLocalHistoryUseCase;

  setUp(() {
    mockAddLocalSearchHistoryUseCase = MockAddLocalSearchHistoryUseCase();
    mockClearLocalHistoryUseCase = MockClearLocalHistoryUseCase();
    mockDeleteLocalHistoryUseCase = MockDeleteLocalHistoryUseCase();
    mockGetLocalHistoryUseCase = MockGetLocalHistoryUseCase();
    localSearchHistoryBloc = LocalSearchHistoryBloc(
      addLocalSearchHistoryUseCase: mockAddLocalSearchHistoryUseCase,
      clearLocalHistoryUseCase: mockClearLocalHistoryUseCase,
      deleteLocalHistoryUseCase: mockDeleteLocalHistoryUseCase,
      getLocalHistoryUseCase: mockGetLocalHistoryUseCase,
    );
  });

  final testHistoryResponses = [
    History(
      id: "id",
      title: "title",
    ),
  ];

  group('local search history bloc', () {
    test('initial state should be LocalSearchHistoryInitialState', () {
      expect(localSearchHistoryBloc.state, LocalSearchHistoryInitialState());
    });

    group('GetLocalSearchHistory', () {
      blocTest<LocalSearchHistoryBloc, LocalSearchHistoryState>(
        'emits [LocalSearchHistoryActionLoading, LocalSearchHistoryLoaded] when GetLocalSearchHistory is successful',
        build: () {
          when(
            mockGetLocalHistoryUseCase(
              const GetHistoryUseCaseParams(
                localSearchType: LocalSearchType.restaurants,
              ),
            ),
          ).thenAnswer(
            (_) async => Right(testHistoryResponses),
          );
          return localSearchHistoryBloc;
        },
        act: (bloc) => bloc.add(
          GetLocalSearchHistory(
            localSearchType: LocalSearchType.restaurants,
          ),
        ),
        expect: () => [
          LocalSearchHistoryActionLoading(),
          LocalSearchHistoryLoaded(
            histories: testHistoryResponses,
          ),
        ],
      );

      blocTest<LocalSearchHistoryBloc, LocalSearchHistoryState>(
        'emits [LocalSearchHistoryActionLoading, LocalSearchHistoryActionsFailed] when GetLocalSearchHistory is unsuccessful',
        build: () {
          when(
            mockGetLocalHistoryUseCase(
              const GetHistoryUseCaseParams(
                localSearchType: LocalSearchType.restaurants,
              ),
            ),
          ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')),
          );
          return localSearchHistoryBloc;
        },
        act: (bloc) => bloc.add(
          GetLocalSearchHistory(
            localSearchType: LocalSearchType.restaurants,
          ),
        ),
        expect: () => [
          LocalSearchHistoryActionLoading(),
          LocalSearchHistoryActionsFailed(
            message: "Unable to get search histories",
          ),
        ],
      );
    });

    group('AddLocalSearchHistory', () {
      blocTest<LocalSearchHistoryBloc, LocalSearchHistoryState>(
        'emits [LocalSearchHistoryActionLoading, LocalSearchHistoryActionsSuccess] when AddLocalSearchHistory is successful',
        build: () {
          when(
            mockAddLocalSearchHistoryUseCase(
              AddLocalSearchUseCaseParams(
                history: testHistoryResponses.first,
                localSearchType: LocalSearchType.restaurants,
              ),
            ),
          ).thenAnswer(
            (_) async => const Right(null),
          );
          return localSearchHistoryBloc;
        },
        act: (bloc) => bloc.add(
          AddLocalSearchHistory(
            history: testHistoryResponses.first,
            localSearchType: LocalSearchType.restaurants,
          ),
        ),
        expect: () => [
          LocalSearchHistoryActionLoading(),
          LocalSearchHistoryActionsSuccess(
            message: "History added",
          ),
        ],
      );

      blocTest<LocalSearchHistoryBloc, LocalSearchHistoryState>(
        'emits [LocalSearchHistoryActionLoading, LocalSearchHistoryActionsFailed] when AddLocalSearchHistory is unsuccessful',
        build: () {
          when(
            mockAddLocalSearchHistoryUseCase(
              AddLocalSearchUseCaseParams(
                history: testHistoryResponses.first,
                localSearchType: LocalSearchType.restaurants,
              ),
            ),
          ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')),
          );
          return localSearchHistoryBloc;
        },
        act: (bloc) => bloc.add(
          AddLocalSearchHistory(
            history: testHistoryResponses.first,
            localSearchType: LocalSearchType.restaurants,
          ),
        ),
        expect: () => [
          LocalSearchHistoryActionLoading(),
          LocalSearchHistoryActionsFailed(
            message: "Unable to  add history",
          ),
        ],
      );
    });

    group('DeleteLocalSearchHistory', () {
      blocTest<LocalSearchHistoryBloc, LocalSearchHistoryState>(
        'emits [LocalSearchHistoryActionLoading, LocalSearchHistoryActionsSuccess] when DeleteLocalSearchHistory is successful',
        build: () {
          when(
            mockDeleteLocalHistoryUseCase(
              const DeleteHistoryUseCaseParams(
                id: "1",
                localSearchType: LocalSearchType.restaurants,
              ),
            ),
          ).thenAnswer(
            (_) async => const Right(null),
          );
          return localSearchHistoryBloc;
        },
        act: (bloc) => bloc.add(
          DeleteLocalSearchHistory(
            id: "1",
            localSearchType: LocalSearchType.restaurants,
          ),
        ),
        expect: () => [
          LocalSearchHistoryActionLoading(),
          LocalSearchHistoryActionsSuccess(
            message: "History deleted",
          ),
        ],
      );

      blocTest<LocalSearchHistoryBloc, LocalSearchHistoryState>(
        'emits [LocalSearchHistoryActionLoading, LocalSearchHistoryActionsFailed] when DeleteLocalSearchHistory is unsuccessful',
        build: () {
          when(
            mockDeleteLocalHistoryUseCase(
              const DeleteHistoryUseCaseParams(
                id: "1",
                localSearchType: LocalSearchType.restaurants,
              ),
            ),
          ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')),
          );
          return localSearchHistoryBloc;
        },
        act: (bloc) => bloc.add(
          DeleteLocalSearchHistory(
            id: "1",
            localSearchType: LocalSearchType.restaurants,
          ),
        ),
        expect: () => [
          LocalSearchHistoryActionLoading(),
          LocalSearchHistoryActionsFailed(
            message: "Unable to delete history",
          ),
        ],
      );
    });

    group('ClearLocalSearchHistory', () {
      blocTest<LocalSearchHistoryBloc, LocalSearchHistoryState>(
        'emits [LocalSearchHistoryActionLoading, LocalSearchHistoryActionsSuccess] when ClearLocalSearchHistory is successful',
        build: () {
          when(
            mockClearLocalHistoryUseCase(
              const ClearLocalHistoryUseCaseParams(
                localSearchType: LocalSearchType.restaurants,
              ),
            ),
          ).thenAnswer(
            (_) async => const Right(null),
          );
          return localSearchHistoryBloc;
        },
        act: (bloc) => bloc.add(
          ClearLocalSearchHistory(
            localSearchType: LocalSearchType.restaurants,
          ),
        ),
        expect: () => [
          LocalSearchHistoryActionLoading(),
          LocalSearchHistoryActionsSuccess(
            message: "History cleared",
          ),
        ],
      );

      blocTest<LocalSearchHistoryBloc, LocalSearchHistoryState>(
        'emits [LocalSearchHistoryActionLoading, LocalSearchHistoryActionsFailed] when ClearLocalSearchHistory is unsuccessful',
        build: () {
          when(
            mockClearLocalHistoryUseCase(
              const ClearLocalHistoryUseCaseParams(
                localSearchType: LocalSearchType.restaurants,
              ),
            ),
          ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')),
          );
          return localSearchHistoryBloc;
        },
        act: (bloc) => bloc.add(
          ClearLocalSearchHistory(
            localSearchType: LocalSearchType.restaurants,
          ),
        ),
        expect: () => [
          LocalSearchHistoryActionLoading(),
          LocalSearchHistoryActionsFailed(
            message: "Unable to clear history",
          ),
        ],
      );
    });
  });
}
