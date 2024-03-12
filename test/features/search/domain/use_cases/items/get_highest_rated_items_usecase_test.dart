import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_highest_rated_items_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/filter_item_result_params.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_state.dart';

import '../../../data/data/items.dart';
import 'get_closest_items_use_case_test.mocks.dart';

void main() {
  late MockItemResultRepository mockItemResultRepository;
  late GetHighestRatedItemsUseCase getHighestRatedItemsUseCase;

  setUp(() {
    mockItemResultRepository = MockItemResultRepository();
    getHighestRatedItemsUseCase = GetHighestRatedItemsUseCase(
      itemResultRepository: mockItemResultRepository,
    );
  });

  test("Should return closest items", () async {
    final itemsFilterParams = FilterItemResultsParams(
      searchQuery: "",
      selection: ItemsFilterState.closest,
      isFasting: false,
      location: const Location(latitude: 9.03, longitude: 38.8),
      category: 1,
      rating: 3,
      maximumPrice: 4000,
      page: 1,
      limit: 10,
    );
    //arrange
    when(mockItemResultRepository.getHighestRatedItems(
      filterResultParams: itemsFilterParams,
      page: 1,
      limit: 10,
      latitude: 9.03,
      longitude: 38.8,
    )).thenAnswer(
      (_) async => Right(
        dummyItems,
      ),
    );
    //act
    final result = await getHighestRatedItemsUseCase(itemsFilterParams);

    //assert
    expect(
      result,
      Right(dummyItems),
    );
    verify(
      mockItemResultRepository.getHighestRatedItems(
        filterResultParams: itemsFilterParams,
        page: 1,
        limit: 10,
        latitude: 9.03,
        longitude: 38.8,
      ),
    );
    verifyNoMoreInteractions(
      mockItemResultRepository,
    );
  });
}
