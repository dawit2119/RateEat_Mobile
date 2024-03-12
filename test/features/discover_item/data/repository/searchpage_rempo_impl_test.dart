import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/data_sources/search_page_data_provider.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/repositories/search_page_repoistory_impl.dart';

import 'searchpage_rempo_impl_test.mocks.dart';

class MockSearchPageDataProvider extends Mock
    implements SearchPageDataProvider {}

@GenerateMocks([MockSearchPageDataProvider])
void main() {
  late SearchPageDataProvider mockSearchPageDataProvider;
  late SearchPageRepositoryImpl searchPageRepository;

  setUp(() {
    mockSearchPageDataProvider = MockMockSearchPageDataProvider();
    searchPageRepository = SearchPageRepositoryImpl(
        searchPageDataProvider: mockSearchPageDataProvider);
  });

  group('SearchPageRepositoryImpl', () {
    const String mockQuery = 'restaurant';

    test('returns list of search results when data is retrieved successfully',
        () async {
      final mockResults = [RestaurantResult(id: '1', name: 'restaurant')];
      when(mockSearchPageDataProvider.searchRestaurants(mockQuery))
          .thenAnswer((_) async => mockResults);

      final result = await searchPageRepository.searchRestaurants(mockQuery);

      expect(result, Right(mockResults));
      verify(mockSearchPageDataProvider.searchRestaurants(mockQuery));
      verifyNoMoreInteractions(mockSearchPageDataProvider);
    });

    test('returns failure when data retrieval fails', () async {
      final error = ServerFailure();
      when(mockSearchPageDataProvider.searchRestaurants(mockQuery))
          .thenThrow(error);

      final result = await searchPageRepository.searchRestaurants(mockQuery);

      expect(result, Left(error));
      verify(mockSearchPageDataProvider.searchRestaurants(mockQuery));
      verifyNoMoreInteractions(mockSearchPageDataProvider);
    });
  });
}
