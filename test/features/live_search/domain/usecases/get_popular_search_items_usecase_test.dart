import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/entities/popular_search_items.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/get_popular_search_items.dart';

import 'add_history_usecase_test.mocks.dart';

void main() {
  late GetPopularSearchesUseCase getPopularSearchesUseCase;
  late MockLiveSearchRepository mockLiveSearchRepository;

  setUp(() {
    mockLiveSearchRepository = MockLiveSearchRepository();
    getPopularSearchesUseCase = GetPopularSearchesUseCase(
      repository: mockLiveSearchRepository,
    );
  });

  const testParams = GetPopularSearchesParams(limit: 7, page: 1);
  const testResponse = PopularSearchItems(
    items: [
      "title",
    ],
    restaurants: [
      "restaurant",
    ],
  );

  test('should get the popular search items', () async {
    // arrange
    when(
      mockLiveSearchRepository.getPopularSearchItems(
        page: testParams.page,
        limit: testParams.limit,
      ),
    ).thenAnswer(
      (_) async => const Right(testResponse),
    );

    // act
    final result = await getPopularSearchesUseCase(
      testParams,
    );

    // assert
    expect(result, const Right(testResponse));
    verify(
      mockLiveSearchRepository.getPopularSearchItems(
        page: testParams.page,
        limit: testParams.limit,
      ),
    );
    verifyNoMoreInteractions(mockLiveSearchRepository);
  });
}
