import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/use_cases/restaurants/get_price_sorted_restaurants_usecase.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';

import '../../../data/data/restaurants.dart';
import 'get_closest_restaurants_use_case_test.mocks.dart';

void main() {
  late MockRestaurantResultRepository mockRestaurantResultRepository;
  late GetPriceSortedRestaurantsUseCase getPriceSortedRestaurantsUseCase;

  setUp(() {
    mockRestaurantResultRepository = MockRestaurantResultRepository();
    getPriceSortedRestaurantsUseCase = GetPriceSortedRestaurantsUseCase(
      restaurantResultRepository: mockRestaurantResultRepository,
    );
  });

  test("Should return closest items", () async {
    final restaurantsFilterParams = FilterRestaurantResultsParams(
      searchQuery: "",
      selection: RestaurantsFilterState.closest,
      isFasting: false,
      location: const Location(latitude: 9.03, longitude: 38.8),
      category: 1,
      rating: 3,
      maximumPrice: 4000,
      page: 1,
      limit: 10,
    );
    //arrange
    when(mockRestaurantResultRepository.getPriceSortedRestaurants(
      filterResultParams: restaurantsFilterParams,
      page: 1,
      limit: 10,
    )).thenAnswer(
      (_) async => Right(
        dummyRestaurants,
      ),
    );
    //act
    final result =
        await getPriceSortedRestaurantsUseCase(restaurantsFilterParams);

    //assert
    expect(
      result,
      Right(
        dummyRestaurants,
      ),
    );
    verify(
      mockRestaurantResultRepository.getPriceSortedRestaurants(
        filterResultParams: restaurantsFilterParams,
        page: 1,
        limit: 10,
      ),
    );
    verifyNoMoreInteractions(
      mockRestaurantResultRepository,
    );
  });
}
