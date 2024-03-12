import 'package:equatable/equatable.dart';

class FilteringState extends Equatable {
  @override
  List<Object?> get props => [];
}

class FilteringInitial extends FilteringState {}

class RatingLoading extends FilteringState {}

class RatingLoaded extends FilteringState {
  final String result;
  RatingLoaded({required this.result});
  @override
  List<Object> get props => [result];
}

class RatingError extends FilteringState {
  final String message;

  RatingError({required this.message});
  @override
  List<Object> get props => [message];
}

class PriceLoading extends FilteringState {}

class PriceLoaded extends FilteringState {
  final String result;
  PriceLoaded({required this.result});
  @override
  List<Object> get props => [result];
}

class PriceError extends FilteringState {
  final String message;

  PriceError({required this.message});
  @override
  List<Object> get props => [message];
}

class PriceRangeLoading extends FilteringState {}

class PriceRangeLoaded extends FilteringState {
  final String result;
  PriceRangeLoaded({required this.result});
  @override
  List<Object> get props => [result];
}

class PriceRangeError extends FilteringState {
  final String message;

  PriceRangeError({required this.message});
  @override
  List<Object> get props => [message];
}

class FilterLoading extends FilteringState {}

class FilterLoaded extends FilteringState {
  final List<dynamic> results;
  FilterLoaded({required this.results});
  @override
  List<Object> get props => [results];
}

class FilterError extends FilteringState {
  final String message;

  FilterError({required this.message});
  @override
  List<Object> get props => [message];
}
