import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/history.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/repository/live_search_repo.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/add_history_use_case.dart';

import 'add_history_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LiveSearchRepository>(),
])
void main() {
  late AddLocalSearchHistoryUseCase addLocalSearchHistoryUseCase;
  late MockLiveSearchRepository mockLiveSearchRepository;

  setUp(() {
    mockLiveSearchRepository = MockLiveSearchRepository();
    addLocalSearchHistoryUseCase = AddLocalSearchHistoryUseCase(
      liveSearchRepository: mockLiveSearchRepository,
    );
  });

  test('should add the history to local search history', () async {
    // arrange
    final params = AddLocalSearchUseCaseParams(
      history: History(
        id: '1',
        title: "title",
      ),
    );
    when(
      mockLiveSearchRepository.addHistory(
        history: params.history,
        localSearchType: params.localSearchType,
      ),
    ).thenAnswer(
      (_) async => const Right(null),
    );

    // act
    final result = await addLocalSearchHistoryUseCase(params);
    // assert
    expect(result, const Right(null));
    verify(
      mockLiveSearchRepository.addHistory(
        history: params.history,
        localSearchType: params.localSearchType,
      ),
    );
    verifyNoMoreInteractions(mockLiveSearchRepository);
  });
}
