part of 'recommended_bloc.dart';

abstract class RecommendedState extends Equatable {
  const RecommendedState();

  @override
  List<Object> get props => [];
}

class RecommendedRestaurantInitial extends RecommendedState {}

class RecommendedRestaurantLoading extends RecommendedState {}

class RecommendedRestaurantNextLoading extends RecommendedState {
  final List<RecommendedRestaurantEntity> restaurants;
  final int page;
  const RecommendedRestaurantNextLoading({
    required this.restaurants,
    required this.page,
  });
}

class RecommendedRestaurantFetched extends RecommendedState {
  final List<RecommendedRestaurantEntity> restaurants;
  final bool hasReachedMax;
  final int page;
  const RecommendedRestaurantFetched({
    required this.restaurants,
    this.hasReachedMax = false,
    this.page = 1,
  });
}

class RecommendedRestaurantFailure extends RecommendedState {
  final String errorMessage;
  const RecommendedRestaurantFailure({required this.errorMessage});
}
