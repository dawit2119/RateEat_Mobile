part of 'promotion_bloc.dart';

abstract class PromotionState extends Equatable {
  const PromotionState();

  @override
  List<Object> get props => [];
}

final class AllPromotionState extends PromotionState {
  final ItemStatus status;
  final String? errorMessage;
  final List<Promotion>? promotions;
  final bool hasReachedMax;

  const AllPromotionState({
    this.hasReachedMax = false,
    this.status = ItemStatus.loading,
    this.promotions,
    this.errorMessage,
  });

  AllPromotionState copyWith({
    ItemStatus? status,
    String? errorMessage,
    List<Promotion>? promotions,
    bool? hasReachedMax,
  }) {
    return AllPromotionState(
      status: status ?? this.status,
      errorMessage: errorMessage ?? this.errorMessage,
      promotions: promotions ?? this.promotions,
      hasReachedMax: hasReachedMax ?? this.hasReachedMax,
    );
  }

  @override
  List<Object> get props => [promotions ?? [], status];
}
