import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class RestaurantDetailState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RestaurantDetailInitial extends RestaurantDetailState {}

class RestaurantDetailLoading extends RestaurantDetailState {}

class RestaurantDetailSuccess extends RestaurantDetailState {
  final RestaurantModel restaurant;
  RestaurantDetailSuccess({required this.restaurant});
  @override
  List<Object?> get props => [restaurant];
}

class RestaurantDetailError extends RestaurantDetailState {
  final String error;
  RestaurantDetailError({required this.error});
  @override
  List<Object?> get props => [error];
}
