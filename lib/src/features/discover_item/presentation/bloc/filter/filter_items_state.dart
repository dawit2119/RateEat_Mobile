import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

class FilterItemsState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FilterItemsInitial extends FilterItemsState {}

class FilterItemsLoading extends FilterItemsState {}

class FilterItemsLoadingMore extends FilterItemsState {
  final List<Item> items;
  FilterItemsLoadingMore({required this.items});
  @override
  List<Object?> get props => [items];
}

class FilterItemsLoaded extends FilterItemsState {
  final bool hasReachedMax;
  final bool isLoadingMore;
  final List<Item> items;
  FilterItemsLoaded(
      {this.hasReachedMax = false,
      required this.isLoadingMore,
      required this.items});
  @override
  List<Object?> get props => [items];
}

class FilterItemsError extends FilterItemsState {
  final String error;
  FilterItemsError({
    required this.error,
  });
}
