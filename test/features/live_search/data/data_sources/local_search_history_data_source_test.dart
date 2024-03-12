import 'package:flutter_test/flutter_test.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/live_search/data/data_sources/local_search_history_data_source.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/history.dart';

import 'local_search_history_data_source_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Box>(),
])
void main() {
  late LocalSearchHistoryDataSourceImpl dataSource;
  late MockBox<History> mockRestaurantsBox;
  late MockBox<History> mockItemsBox;

  setUp(() async {
    mockRestaurantsBox = MockBox<History>();
    mockItemsBox = MockBox<History>();
    dataSource = LocalSearchHistoryDataSourceImpl(
      restaurantsSearchHistoryBox: mockRestaurantsBox,
      itemsSearchHistoryBox: mockItemsBox,
    );
  });

  group('LocalSearchHistoryDataSourceImpl', () {
    test('addHistory adds history to the box if it does not exist', () async {
      // Arrange
      final history = History(id: '1', title: 'Pizza');
      when(mockRestaurantsBox.values).thenReturn([]);
      when(mockRestaurantsBox.add(any)).thenAnswer((_) async => 1);

      // Act
      await dataSource.addHistory(
          history: history, localSearchType: LocalSearchType.restaurants);

      // Assert
      verify(mockRestaurantsBox.add(history)).called(1);
    });

    test('addHistory does not add duplicate history', () async {
      // Arrange
      final history = History(id: '1', title: 'Pizza');
      when(mockRestaurantsBox.values).thenReturn([history]);

      // Act
      await dataSource.addHistory(
          history: history, localSearchType: LocalSearchType.restaurants);

      // Assert
      verifyNever(mockRestaurantsBox.add(any));
    });

    test('getHistoryList returns a list of history items', () async {
      // Arrange
      final history1 = History(id: '1', title: 'Pizza');
      final history2 = History(id: '2', title: 'Burger');
      when(mockRestaurantsBox.values).thenReturn([history1, history2]);

      // Act
      final result = await dataSource.getHistoryList(
          localSearchType: LocalSearchType.restaurants);

      // Assert
      expect(result, [history2, history1]); // Should return reversed order
    });

    test('clearHistory clears the history box', () async {
      // Act
      await dataSource.clearHistory(
          localSearchType: LocalSearchType.restaurants);

      // Assert
      verify(mockRestaurantsBox.clear()).called(1);
    });

    test('deleteHistory removes an item by id', () async {
      // Arrange
      final history = History(id: '1', title: 'Pizza');
      when(mockRestaurantsBox.keys).thenReturn([0]);
      when(mockRestaurantsBox.get(0)).thenReturn(history);

      // Act
      await dataSource.deleteHistory(
          id: '1', localSearchType: LocalSearchType.restaurants);

      // Assert
      verify(mockRestaurantsBox.delete(0)).called(1);
    });

    test('deleteHistory does not remove item if id does not exist', () async {
      // Arrange
      when(mockRestaurantsBox.keys).thenReturn([0]);
      when(mockRestaurantsBox.get(0)).thenReturn(null); // No item found

      // Act
      await dataSource.deleteHistory(
          id: '1', localSearchType: LocalSearchType.restaurants);

      // Assert that it is called with null and not actual value
      verify(mockRestaurantsBox.delete(null)).called(1);
    });
  });
}
