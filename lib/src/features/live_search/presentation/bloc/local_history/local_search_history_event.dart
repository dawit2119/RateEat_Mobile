import 'package:equatable/equatable.dart';

import '../../../data/data_sources/local_search_history_data_source.dart';
import '../../../data/models/history.dart';

abstract class LocalSearchHistoryEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class AddLocalSearchHistory extends LocalSearchHistoryEvent {
  final History history;
  final LocalSearchType localSearchType;
  AddLocalSearchHistory({
    required this.history,
    required this.localSearchType,
  });
}

class DeleteLocalSearchHistory extends LocalSearchHistoryEvent {
  final LocalSearchType localSearchType;
  final String id;
  DeleteLocalSearchHistory({
    required this.localSearchType,
    required this.id,
  });
}

class GetLocalSearchHistory extends LocalSearchHistoryEvent {
  final LocalSearchType localSearchType;
  GetLocalSearchHistory({
    this.localSearchType = LocalSearchType.restaurants,
  });
}

class ClearLocalSearchHistory extends LocalSearchHistoryEvent {
  final LocalSearchType localSearchType;
  ClearLocalSearchHistory({
    this.localSearchType = LocalSearchType.restaurants,
  });
}
