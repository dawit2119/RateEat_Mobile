import 'package:equatable/equatable.dart';

class FeedbackState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FeedbackInitial extends FeedbackState {}

class FeedbackLoading extends FeedbackState {}

class FeedbackSuccess extends FeedbackState {
  final String message;
  FeedbackSuccess({required this.message});
  @override
  List<Object?> get props => [message];
}

class FeedbackFailure extends FeedbackState {
  final String error;
  FeedbackFailure({required this.error});
  @override
  List<Object?> get props => [error];
}
