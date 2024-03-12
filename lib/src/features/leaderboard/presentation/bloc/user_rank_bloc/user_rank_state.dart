import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/rank.dart';

class RankState extends Equatable {
  @override
  List<Object?> get props => [];
}

class RankInitial extends RankState {}

class RankLoading extends RankState {}

class RankSuccess extends RankState {
  final Rank rank;
  RankSuccess({required this.rank});
  @override
  List<Object?> get props => [rank];
}

class RankError extends RankState {
  final String error;
  RankError({required this.error});
  @override
  List<Object?> get props => [error];
}
