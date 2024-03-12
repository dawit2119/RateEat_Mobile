import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/domain/entities/location.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/repositories/filter_page_repository.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/use_cases/filer_page_usecase.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

import 'filter_usecase_test.mocks.dart';

class MockFilterItemsRepository extends Mock implements FilterItemsRepository {}

@GenerateMocks([MockFilterItemsRepository])
void main() {
  late FilterItemsUseCase filterItemsUseCase;
  late MockFilterItemsRepository mockFilterItemsRepository;

  setUp(() {
    mockFilterItemsRepository = MockMockFilterItemsRepository();
    filterItemsUseCase =
        FilterItemsUseCase(filterItemsRepository: mockFilterItemsRepository);
  });

  group('FilterItemsUseCase', () {
    const String restaurantId = '1';
    const String maxPrice = '50.0';
    const double minRating = 4.0;
    const bool fasting = false;
    const String sortingQuery = 'name';
    const String searchQuery = 'burger';
    const String categoryId = '1';
    const int page = 1;
    const int limit = 10;
    const Location location = Location(latitude: 37.7749, longitude: -122.4194);

    test('returns list of filtered items when repository call is successful',
        () async {
      final mockItems = [
        Item(
          itemId: '1',
          itemName: 'burger',
          numberOfReviews: 12,
        )
      ];
      when(mockFilterItemsRepository.getRestaurantItems(
        restaurantId: restaurantId,
        maxPrice: maxPrice,
        fasting: fasting,
        sortingQuery: sortingQuery,
        searchQuery: searchQuery,
        categoryId: categoryId,
        page: page,
        limit: limit,
      )).thenAnswer((_) async => Right(mockItems));

      final result = await filterItemsUseCase.getRestaurantItems(
        restaurantId,
        maxPrice,
        fasting,
        sortingQuery,
        searchQuery,
        categoryId,
        page,
        limit,
      );

      expect(result, Right(mockItems));
      verify(mockFilterItemsRepository.getRestaurantItems(
        restaurantId: restaurantId,
        maxPrice: maxPrice,
        fasting: fasting,
        sortingQuery: sortingQuery,
        searchQuery: searchQuery,
        categoryId: categoryId,
        page: page,
        limit: limit,
      ));
      verifyNoMoreInteractions(mockFilterItemsRepository);
    });

    test('returns failure when repository call fails', () async {
      final error = ServerFailure();
      when(mockFilterItemsRepository.getRestaurantItems(
        restaurantId: restaurantId,
        maxPrice: maxPrice,
        fasting: fasting,
        sortingQuery: sortingQuery,
        searchQuery: searchQuery,
        categoryId: categoryId,
        page: page,
        limit: limit,
      )).thenAnswer((_) async => Left(error));

      final result = await filterItemsUseCase.getRestaurantItems(
        restaurantId,
        maxPrice,
        fasting,
        sortingQuery,
        searchQuery,
        categoryId,
        page,
        limit,
      );

      expect(result, Left(error));
      verify(mockFilterItemsRepository.getRestaurantItems(
        restaurantId: restaurantId,
        maxPrice: maxPrice,
        fasting: fasting,
        sortingQuery: sortingQuery,
        searchQuery: searchQuery,
        categoryId: categoryId,
        page: page,
        limit: limit,
      ));
      verifyNoMoreInteractions(mockFilterItemsRepository);
    });
  });
}
