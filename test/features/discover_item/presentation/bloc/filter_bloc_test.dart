import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/use_cases/filer_page_usecase.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/filter/filter_items_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/filter/filter_items_event.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/filter/filter_items_state.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

import 'filter_bloc_test.mocks.dart';

class MockFilterItemsUseCase extends Mock implements FilterItemsUseCase {}

@GenerateMocks([MockFilterItemsUseCase])
void main() {
  group('FilterItemsBloc', () {
    late FilterItemsBloc filterItemsBloc;
    late MockFilterItemsUseCase mockFilterItemsUseCase;

    setUp(() {
      mockFilterItemsUseCase = MockMockFilterItemsUseCase();
      filterItemsBloc =
          FilterItemsBloc(filterItemsUseCase: mockFilterItemsUseCase);
    });

    const String restaurantId = 'restaurantId';
    const String maxPrice = '50';
    const double minRating = 4.0;
    const bool fasting = false;
    const String sortingQuery = 'sortBy=name';
    const String searchQuery = 'searchQuery';
    const String categoryId = 'categoryId';
    const int page = 1;
    const int limit = 10;
    const Location location = Location(latitude: 0, longitude: 0);
    final event = GetFilteredItemsEvent(
      restaurantId: restaurantId,
      maxPrice: maxPrice,
      fasting: fasting,
      sortingQuery: sortingQuery,
      searchQuery: searchQuery,
      categoryId: categoryId,
      page: page,
      limit: limit,
    );

    test(
        'emits loading and success states when filtered items are fetched successfully',
        () async {
      final List<Item> mockItems = [
        Item(itemId: '', itemName: '', numberOfReviews: 0),
      ];

      when(mockFilterItemsUseCase.getRestaurantItems(
        restaurantId,
        maxPrice,
        fasting,
        sortingQuery,
        searchQuery,
        categoryId,
        page,
        limit,
      )).thenAnswer((_) async => Right(mockItems));

      filterItemsBloc.add(event);

      await expectLater(
        filterItemsBloc.stream,
        emitsInOrder([
          FilterItemsLoading(),
          FilterItemsLoaded(items: mockItems, isLoadingMore: false),
        ]),
      );
    });

    test('emits loading and error states when filtered items fetching fails',
        () async {
      final failure = ServerFailure(errorMessage: 'Server error');
      when(mockFilterItemsUseCase.getRestaurantItems(
        restaurantId,
        maxPrice,
        fasting,
        sortingQuery,
        searchQuery,
        categoryId,
        page,
        limit,
      )).thenAnswer((_) async => Left(failure));

      filterItemsBloc.add(event);

      await expectLater(
        filterItemsBloc.stream,
        emitsInOrder([
          FilterItemsLoading(),
          FilterItemsError(error: failure.errorMessage),
        ]),
      );
    });
  });
}
