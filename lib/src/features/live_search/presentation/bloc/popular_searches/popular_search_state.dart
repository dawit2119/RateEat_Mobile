import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/live_search/domain/entities/popular_search_items.dart';

abstract class PopularSearchesState extends Equatable {
  @override
  List<Object> get props => [];
}

class PopularSearchesLoaded extends PopularSearchesState {
  final PopularSearchItems popularSearchItems;
  PopularSearchesLoaded({
    required this.popularSearchItems,
  });
  @override
  List<Object> get props => [popularSearchItems];
}

class PopularSearchActionsFailed extends PopularSearchesState {
  final String message;

  PopularSearchActionsFailed({
    required this.message,
  });
}

class PopularSearchActionsLoading extends PopularSearchesState {}

class PopularSearchesInitial extends PopularSearchesState {}
