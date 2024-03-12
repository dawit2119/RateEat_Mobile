import 'package:equatable/equatable.dart';

import '../../../domain/entities/item.dart';

abstract class PopularState extends Equatable {
  const PopularState();

  @override
  List<Object> get props => [];
}

enum ItemStatus { loaded, loading, error, nextError, nextLoading }

final class TopRatedState extends PopularState {
  final ItemStatus status;
  final String? errorMessage;
  final List<Item>? popular;
  final bool hasReachedMax;
  final int? totalItems;

  const TopRatedState({
    this.hasReachedMax = false,
    this.status = ItemStatus.loading,
    this.popular = const [],
    this.errorMessage,
    this.totalItems,
  });

  TopRatedState copyWith({
    ItemStatus? status,
    String? errorMessage,
    List<Item>? popular,
    bool? hasReachedMax,
    int? totalItems,
  }) {
    return TopRatedState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      popular: popular ?? this.popular,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
      totalItems: totalItems ?? this.totalItems,
    );
  }

  @override
  List<Object> get props => [
        popular ?? [],
        status,
        errorMessage ?? "",
        hasReachedMax,
        totalItems ?? 0
      ];
}
