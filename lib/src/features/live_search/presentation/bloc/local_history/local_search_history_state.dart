import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/history.dart';

abstract class LocalSearchHistoryState extends Equatable {
  @override
  List<Object> get props => [];
}

class LocalSearchHistoryInitialState extends LocalSearchHistoryState {}

class LocalSearchHistoryActionLoading extends LocalSearchHistoryState {}

class LocalSearchHistoryLoaded extends LocalSearchHistoryState {
  final List<History> histories;

  LocalSearchHistoryLoaded({
    required this.histories,
  });

  @override
  List<Object> get props => [histories];
}

class LocalSearchHistoryActionsSuccess extends LocalSearchHistoryState {
  final String message;

  LocalSearchHistoryActionsSuccess({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}

class LocalSearchHistoryActionsFailed extends LocalSearchHistoryState {
  final String message;

  LocalSearchHistoryActionsFailed({
    required this.message,
  });
  @override
  List<Object> get props => [message];
}
