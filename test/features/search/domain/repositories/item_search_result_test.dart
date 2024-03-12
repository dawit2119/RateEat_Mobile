import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/search_result/domain/repositories/item_search_result.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/filter_item_result_params.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_state.dart';

class MockItemResultRepository extends Mock implements ItemResultRepository {}

void main() {
  late MockItemResultRepository repository;
  late FilterItemResultsParams params;
  setUp(() {
    repository = MockItemResultRepository();
    params = FilterItemResultsParams(
      searchQuery: 'test',
      rating: 3.0,
      selection: ItemsFilterState.mostPopular,
      maximumPrice: 4,
      isFasting: false,
      location: Location(latitude: 10.0, longitude: 20.0),
      category: 1,
      page: 1,
      limit: 10,
    );
  });

  test(
      'should return a list of items when fetching most popular items succeeds',
      () async {
    when(repository.getMostPopularItems(
      filterResultParams: params,
      page: 1,
      limit: 10,
      latitude: 0.0,
      longitude: 0.0,
    )).thenAnswer((_) async => Right([]));

    final result = await repository.getMostPopularItems(
      filterResultParams: params,
      page: 1,
      limit: 10,
      latitude: 0.0,
      longitude: 0.0,
    );

    expect(result, isA<Right<Failure, List<ItemModel>>>());
  });
}
