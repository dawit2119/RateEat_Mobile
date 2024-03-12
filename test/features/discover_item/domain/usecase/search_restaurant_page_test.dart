import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/use_cases/search_page_use_case.dart';

import 'package:rateeat_mobile/src/features/discover_item/domain/repositories/search_page_repostiory.dart';
import 'package:mockito/annotations.dart';

import 'search_restaurant_page_test.mocks.dart';

class MockSearchPageRepository extends Mock implements SearchPageRepository {}

@GenerateMocks([MockSearchPageRepository])
void main() {
  late SearchPageUseCase searchPageUseCase;
  late MockSearchPageRepository mockSearchPageRepository;

  setUp(() {
    mockSearchPageRepository = MockMockSearchPageRepository();
    searchPageUseCase =
        SearchPageUseCase(searchPageRepository: mockSearchPageRepository);
  });

  group('SearchPageUseCase', () {
    const query = "";

    test(
        'returns list of restaurant results when repository call is successful',
        () async {
      final mockResults = [RestaurantResult(id: '1', name: 'restaurant')];
      when(mockSearchPageRepository.searchRestaurants(''))
          .thenAnswer((_) async => Right(mockResults));

      final result = await searchPageUseCase.searchRestaurants(query);

      expect(result, Right(mockResults));
      verify(mockSearchPageRepository.searchRestaurants(query));
      verifyNoMoreInteractions(mockSearchPageRepository);
    });

    test('returns failure when repository call fails', () async {
      final error = ServerFailure();
      when(mockSearchPageRepository.searchRestaurants(''))
          .thenAnswer((_) async => Left(error));

      final result = await searchPageUseCase.searchRestaurants(query);

      expect(result, Left(error));
      verify(mockSearchPageRepository.searchRestaurants(query));
      verifyNoMoreInteractions(mockSearchPageRepository);
    });
  });
}
