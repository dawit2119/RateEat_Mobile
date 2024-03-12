import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/use_case/search_restaurants_use_case.dart';

import 'add_history_usecase_test.mocks.dart';

void main() {
  late LiveSearchRestaurantsUseCase liveSearchRestaurantsUseCase;
  late MockLiveSearchRepository mockLiveSearchRepository;

  setUp(() {
    mockLiveSearchRepository = MockLiveSearchRepository();
    liveSearchRestaurantsUseCase = LiveSearchRestaurantsUseCase(
      liveSearchRepository: mockLiveSearchRepository,
    );
  });

  const testParams = 'query';

  final testResponse = [
    RestaurantResult(
      id: '1',
      name: 'name',
    ),
  ];

  test('should search the restaurants', () async {
    // arrange
    when(
      mockLiveSearchRepository.searchRestaurants(
        testParams,
      ),
    ).thenAnswer(
      (_) async => Right(testResponse),
    );

    // act
    final result = await liveSearchRestaurantsUseCase(
      testParams,
    );

    // assert
    expect(result, Right(testResponse));
    verify(
      mockLiveSearchRepository.searchRestaurants(
        testParams,
      ),
    );
    verifyNoMoreInteractions(mockLiveSearchRepository);
  });
}
