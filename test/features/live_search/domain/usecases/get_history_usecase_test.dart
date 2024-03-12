import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/history.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/get_history_use_case.dart';

import 'add_history_usecase_test.mocks.dart';

void main() {
  late GetLocalHistoryUseCase getLocalHistoryUseCase;
  late MockLiveSearchRepository mockLiveSearchRepository;

  setUp(() {
    mockLiveSearchRepository = MockLiveSearchRepository();
    getLocalHistoryUseCase = GetLocalHistoryUseCase(
      liveSearchRepository: mockLiveSearchRepository,
    );
  });

  final testResponse = [
    History(
      id: '1',
      title: "title",
    ),
  ];
  test('should get the history from local search history', () async {
    // arrange
    const params = GetHistoryUseCaseParams();
    when(
      mockLiveSearchRepository.getHistoryList(
        localSearchType: params.localSearchType,
      ),
    ).thenAnswer(
      (_) async => Right(testResponse),
    );

    // act
    final result = await getLocalHistoryUseCase(params);
    // assert
    expect(result, Right(testResponse));
    verify(
      mockLiveSearchRepository.getHistoryList(
        localSearchType: params.localSearchType,
      ),
    );
    verifyNoMoreInteractions(mockLiveSearchRepository);
  });
}
