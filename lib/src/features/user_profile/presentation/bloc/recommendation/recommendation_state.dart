import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

abstract class RecommendationState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RecommendationSuccess extends RecommendationState {
  final List<UserRecommendation> recommendations;
  final bool hasReachedMax;
  final int page;
  final bool isLocalData;

  RecommendationSuccess(
      {required this.recommendations,
      required this.hasReachedMax,
      required this.page,
      required this.isLocalData});

  @override
  List<Object?> get props =>
      [recommendations, hasReachedMax, page, isLocalData];
}

class RecommendationNextLoading extends RecommendationState {
  final List<UserRecommendation> recommendations;
  RecommendationNextLoading({required this.recommendations});

  @override
  List<Object?> get props => [recommendations];
}

class RecommendationFailed extends RecommendationState {}

class RecommendationLoading extends RecommendationState {}

class RecommendationInitial extends RecommendationState {}
