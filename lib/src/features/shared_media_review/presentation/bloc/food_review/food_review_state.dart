import 'package:equatable/equatable.dart';

enum FoodReviewStatus { initial, loading, success, error }

class FoodReviewState extends Equatable {
  final FoodReviewStatus status;
  final String errorMessage;

  const FoodReviewState({
    this.status = FoodReviewStatus.initial,
    this.errorMessage = '',
  });
  @override
  List<Object> get props => [status, errorMessage];
}
