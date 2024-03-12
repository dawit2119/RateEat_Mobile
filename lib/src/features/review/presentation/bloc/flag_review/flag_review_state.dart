part of 'flag_review_bloc.dart';

abstract class FlagReviewState extends Equatable {}

final class FlagReviewInitial extends FlagReviewState {
  @override
  List<Object?> get props => [];
}

final class FlagReviewLoading extends FlagReviewState {
  @override
  List<Object?> get props => [];
}

final class FlagReviewFailed extends FlagReviewState {
  @override
  List<Object?> get props => [];
}

class FlagReviewSuccess extends FlagReviewState {
  final String message;

  FlagReviewSuccess({
    required this.message,
  });

  @override
  List<Object?> get props => [];
}
