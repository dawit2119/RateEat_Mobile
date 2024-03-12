import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/clear_history_use_case.dart';

import 'add_history_usecase_test.mocks.dart';

void main() {
  late ClearLocalHistoryUseCase clearLocalHistoryUseCase;
  late MockLiveSearchRepository mockLiveSearchRepository;

  setUp(() {
    mockLiveSearchRepository = MockLiveSearchRepository();
    clearLocalHistoryUseCase = ClearLocalHistoryUseCase(
      liveSearchRepository: mockLiveSearchRepository,
    );
  });

  test('should clear the history from local search history', () async {
    // arrange
    const params = ClearLocalHistoryUseCaseParams();
    when(
      mockLiveSearchRepository.clearHistory(
        localSearchType: params.localSearchType,
      ),
    ).thenAnswer(
      (_) async => const Right(null),
    );

    // act
    final result = await clearLocalHistoryUseCase(params);
    // assert
    expect(result, const Right(null));
    verify(
      mockLiveSearchRepository.clearHistory(
        localSearchType: params.localSearchType,
      ),
    );
    verifyNoMoreInteractions(mockLiveSearchRepository);
  });
}
