import 'package:equatable/equatable.dart';

enum RestaurantReviewStatus { initial, loading, success, error }

class RestaurantReviewState extends Equatable {
  final RestaurantReviewStatus status;
  final String errorMessage;

  const RestaurantReviewState({
    this.status = RestaurantReviewStatus.initial,
    this.errorMessage = '',
  });
  @override
  List<Object> get props => [status, errorMessage];
}
