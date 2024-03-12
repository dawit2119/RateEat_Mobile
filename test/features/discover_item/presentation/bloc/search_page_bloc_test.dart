import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';

import 'package:rateeat_mobile/src/features/discover_item/domain/use_cases/search_page_use_case.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/search_restaurant.dart';

import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/search_restaurant_event.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/search_restaurant_state.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'search_page_bloc_test.mocks.dart';

class MockSearchPageUseCase extends Mock implements SearchPageUseCase {}

@GenerateMocks([MockSearchPageUseCase])
void main() {
  late SearchRestaurantsBloc searchRestaurantsBloc;
  late MockSearchPageUseCase mockSearchPageUseCase;

  setUp(() {
    mockSearchPageUseCase = MockMockSearchPageUseCase();
    searchRestaurantsBloc =
        SearchRestaurantsBloc(searchPageUseCase: mockSearchPageUseCase);
  });

  group('SearchRestaurantsBloc', () {
    const String mockQuery = 'burger';
    final List<RestaurantResult> mockResults = [
      RestaurantResult(id: '', name: ''),
    ];

    test('emits loading and success states when search is successful',
        () async {
      when(mockSearchPageUseCase.searchRestaurants(mockQuery))
          .thenAnswer((_) async => Right(mockResults));

      searchRestaurantsBloc
          .add(const RestaurantSearchSubmitted(query: mockQuery));

      await expectLater(
        searchRestaurantsBloc.stream,
        emitsInOrder([
          SearchRestaurantLoading(),
          SearchRestaurantSuccess(mockResults),
        ]),
      );
    });

    test('emits loading and error states when search fails', () async {
      final failure = ServerFailure();
      when(mockSearchPageUseCase.searchRestaurants(mockQuery))
          .thenAnswer((_) async => Left(failure));

      searchRestaurantsBloc
          .add(const RestaurantSearchSubmitted(query: mockQuery));

      await expectLater(
        searchRestaurantsBloc.stream,
        emitsInOrder([
          SearchRestaurantLoading(),
          SearchRestaurantsError(message: failure.errorMessage),
        ]),
      );
    });
  });
}
