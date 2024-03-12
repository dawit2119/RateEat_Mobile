import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/delete_history_use_case.dart';

import 'add_history_usecase_test.mocks.dart';

void main() {
  late DeleteLocalHistoryUseCase deleteLocalHistoryUseCase;
  late MockLiveSearchRepository mockLiveSearchRepository;

  setUp(() {
    mockLiveSearchRepository = MockLiveSearchRepository();
    deleteLocalHistoryUseCase = DeleteLocalHistoryUseCase(
      liveSearchRepository: mockLiveSearchRepository,
    );
  });

  test('should delete the history from local search history', () async {
    // arrange
    const params = DeleteHistoryUseCaseParams(id: '1');
    when(
      mockLiveSearchRepository.deleteHistory(
        id: params.id,
        localSearchType: params.localSearchType,
      ),
    ).thenAnswer(
      (_) async => const Right(null),
    );

    // act
    final result = await deleteLocalHistoryUseCase(params);
    // assert
    expect(result, const Right(null));
    verify(
      mockLiveSearchRepository.deleteHistory(
        id: params.id,
        localSearchType: params.localSearchType,
      ),
    );
    verifyNoMoreInteractions(mockLiveSearchRepository);
  });
}
