import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/repositories/item_search_result.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/items/get_closest_items_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/filter_item_result_params.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_state.dart';

import '../../../data/data/items.dart';
import 'get_closest_items_use_case_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ItemResultRepository>(),
])
void main() {
  late MockItemResultRepository mockItemResultRepository;
  late GetClosestItemsUseCase getClosestItemsUseCase;

  setUp(() {
    mockItemResultRepository = MockItemResultRepository();
    getClosestItemsUseCase = GetClosestItemsUseCase(
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
    when(mockItemResultRepository.getClosestItems(
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
    final result = await getClosestItemsUseCase(itemsFilterParams);

    //assert
    expect(
      result,
      Right(dummyItems),
    );
    verify(
      mockItemResultRepository.getClosestItems(
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
