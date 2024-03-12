import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';

import 'package:rateeat_mobile/src/features/discover_item/data/data_sources/filter_page_data_provider.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/repositories/filter_page_repostiory_impl.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'filter_repo_impl_test.mocks.dart';

class MockFilterItemsDataProvider extends Mock
    implements FilterItemsDataProvider {}

@GenerateMocks([MockFilterItemsDataProvider])
void main() {
  late FilterItemsDataProvider mockFilterItemsDataProvider;
  late FilterItemsRepoImpl filterItemsRepo;

  setUp(() {
    mockFilterItemsDataProvider = MockMockFilterItemsDataProvider();
    filterItemsRepo = FilterItemsRepoImpl(
        filterItemsDataProvider: mockFilterItemsDataProvider);
  });

  group('FilterItemsRepoImpl', () {
    const String restaurantId = '1';
    const String maxPrice = '50.0';
    const double minRating = 4.0;
    const bool fasting = false;
    const String sortingQuery = 'name';
    const String searchQuery = 'burger';
    const int page = 1;
    const int limit = 10;
    const Location location = Location(latitude: 37.7749, longitude: -122.4194);

    test('returns list of filtered items when data is retrieved successfully',
        () async {
      final mockItems = [
        ItemModel(
          itemId: '1',
          itemName: 'burger',
          numberOfReviews: 12,
        )
      ];
      when(mockFilterItemsDataProvider.getRestaurantItems(
        restaurantId: restaurantId,
        maxPrice: maxPrice,
        fasting: fasting,
        sortingQuery: sortingQuery,
        searchQuery: searchQuery,
        page: page,
        limit: limit,
      )).thenAnswer((_) async => mockItems);

      final result = await filterItemsRepo.getRestaurantItems(
        restaurantId: restaurantId,
        maxPrice: maxPrice,
        fasting: fasting,
        sortingQuery: sortingQuery,
        searchQuery: searchQuery,
        page: page,
        limit: limit,
        location: location,
      );

      expect(result, Right(mockItems));
      verify(mockFilterItemsDataProvider.getRestaurantItems(
        restaurantId: restaurantId,
        maxPrice: maxPrice,
        fasting: fasting,
        sortingQuery: sortingQuery,
        searchQuery: searchQuery,
        page: page,
        limit: limit,
      ));
      verifyNoMoreInteractions(mockFilterItemsDataProvider);
    });

    test('returns failure when data retrieval fails', () async {
      final error = ServerFailure();
      when(mockFilterItemsDataProvider.getRestaurantItems(
        restaurantId: restaurantId,
        maxPrice: maxPrice,
        fasting: fasting,
        sortingQuery: sortingQuery,
        searchQuery: searchQuery,
        page: page,
        limit: limit,
      )).thenThrow(error);

      final result = await filterItemsRepo.getRestaurantItems(
        restaurantId: restaurantId,
        maxPrice: maxPrice,
        fasting: fasting,
        sortingQuery: sortingQuery,
        searchQuery: searchQuery,
        page: page,
        limit: limit,
        location: location,
      );

      expect(result, Left(error));
      verify(mockFilterItemsDataProvider.getRestaurantItems(
        restaurantId: restaurantId,
        maxPrice: maxPrice,
        fasting: fasting,
        sortingQuery: sortingQuery,
        searchQuery: searchQuery,
        page: page,
        limit: limit,
      ));
      verifyNoMoreInteractions(mockFilterItemsDataProvider);
    });
  });
}
