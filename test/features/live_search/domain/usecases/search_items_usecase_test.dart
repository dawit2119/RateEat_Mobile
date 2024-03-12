import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/search_items_use_case.dart';

import 'add_history_usecase_test.mocks.dart';

void main() {
  late LiveSearchItemsUseCase liveSearchItemsUseCase;
  late MockLiveSearchRepository mockLiveSearchRepository;

  setUp(() {
    mockLiveSearchRepository = MockLiveSearchRepository();
    liveSearchItemsUseCase = LiveSearchItemsUseCase(
      liveSearchRepository: mockLiveSearchRepository,
    );
  });

  const testParams = LiveSearchItemsUseCaseParams(
    searchTerm: 'query',
    latitude: 7,
    longitude: 1,
  );

  final testResponse = [
    Item(
      itemId: '1',
      itemName: 'name',
      numberOfReviews: 0,
    ),
  ];

  test('should search the items', () async {
    // arrange
    when(
      mockLiveSearchRepository.searchItems(
        testParams.searchTerm,
        latitude: testParams.latitude,
        longitude: testParams.longitude,
      ),
    ).thenAnswer(
      (_) async => Right(testResponse),
    );

    // act
    final result = await liveSearchItemsUseCase(
      testParams,
    );

    // assert
    expect(result, Right(testResponse));
    verify(
      mockLiveSearchRepository.searchItems(
        testParams.searchTerm,
        latitude: testParams.latitude,
        longitude: testParams.longitude,
      ),
    );
    verifyNoMoreInteractions(mockLiveSearchRepository);
  });
}
