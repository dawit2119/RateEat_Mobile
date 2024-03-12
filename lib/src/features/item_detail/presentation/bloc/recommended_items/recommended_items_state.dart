import 'package:equatable/equatable.dart';

import '../../../../homepage/domain/entities/item.dart';

class DetailRecommendedState extends Equatable {
  @override
  List<Object?> get props => [];
}

class DetailRecommendedInitial extends DetailRecommendedState {}

class DetailRecommendedLoading extends DetailRecommendedState {}

class DetailRecommendedSuccess extends DetailRecommendedState {
  final List<Item> recommendations;
  final bool isLocal;
  DetailRecommendedSuccess(
      {required this.recommendations, required this.isLocal});
  @override
  List<Object?> get props => [recommendations];
}

class DetailRecommendedError extends DetailRecommendedState {
  final String error;
  DetailRecommendedError({required this.error});
  @override
  List<Object?> get props => [error];
}
