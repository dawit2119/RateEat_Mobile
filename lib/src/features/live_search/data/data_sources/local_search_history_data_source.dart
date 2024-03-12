import 'package:flutter/foundation.dart';
import 'package:hive_flutter/hive_flutter.dart';

import '../models/history.dart';

enum LocalSearchType { restaurants, items }

abstract class LocalSearchHistoryDataSource {
  Future<void> addHistory({
    required History history,
    LocalSearchType localSearchType = LocalSearchType.restaurants,
  });
  Future<List<History>> getHistoryList({
    LocalSearchType localSearchType = LocalSearchType.restaurants,
  });
  Future<void> clearHistory({
    LocalSearchType localSearchType = LocalSearchType.restaurants,
  });
  Future<void> deleteHistory({
    required String id,
    LocalSearchType localSearchType = LocalSearchType.restaurants,
  });
}

class LocalSearchHistoryDataSourceImpl extends LocalSearchHistoryDataSource {
  late final Box<History> restaurantsSearchHistoryBox;
  late final Box<History> itemsSearchHistoryBox;

  LocalSearchHistoryDataSourceImpl(
      {Box<History>? restaurantsSearchHistoryBox,
      Box<History>? itemsSearchHistoryBox}) {
    this.restaurantsSearchHistoryBox = restaurantsSearchHistoryBox ??
        Hive.box<History>("restaurantsSearchHistory");
    this.itemsSearchHistoryBox =
        itemsSearchHistoryBox ?? Hive.box<History>("itemsSearchHistory");
  }

  @override
  Future<void> addHistory({
    required History history,
    LocalSearchType localSearchType = LocalSearchType.restaurants,
  }) async {
    try {
      var searchHistoryBox = localSearchType == LocalSearchType.restaurants
          ? restaurantsSearchHistoryBox
          : itemsSearchHistoryBox;

      if (!searchHistoryBox.values
          .any((existingHistory) => existingHistory.title == history.title)) {
        await searchHistoryBox.add(history);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<List<History>> getHistoryList({
    LocalSearchType localSearchType = LocalSearchType.restaurants,
  }) async {
    if (localSearchType == LocalSearchType.restaurants) {
      var history = restaurantsSearchHistoryBox.values.toList();
      return history.reversed.toList();
    } else {
      var history = itemsSearchHistoryBox.values.toList();
      return history.reversed.toList();
    }
  }

  @override
  Future<void> clearHistory({
    LocalSearchType localSearchType = LocalSearchType.restaurants,
  }) async {
    try {
      if (localSearchType == LocalSearchType.restaurants) {
        await restaurantsSearchHistoryBox.clear();
      } else {
        await itemsSearchHistoryBox.clear();
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  Future<void> deleteHistory({
    required String id,
    LocalSearchType localSearchType = LocalSearchType.restaurants,
  }) async {
    try {
      int? key;
      if (localSearchType == LocalSearchType.restaurants) {
        key = restaurantsSearchHistoryBox.keys.firstWhere(
          (k) => restaurantsSearchHistoryBox.get(k)?.id == id,
          orElse: () => null,
        );
        await restaurantsSearchHistoryBox.delete(key);
      } else {
        key = itemsSearchHistoryBox.keys.firstWhere(
          (k) => itemsSearchHistoryBox.get(k)?.id == id,
          orElse: () => null,
        );
        await itemsSearchHistoryBox.delete(key);
      }
    } catch (e) {
      debugPrint(e.toString());
    }
  }
}
