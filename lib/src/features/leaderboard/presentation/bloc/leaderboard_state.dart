import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/leadermodel.dart';

class LeaderBoardState extends Equatable {
  @override
  List<Object?> get props => [];
}

class LeaderBoardInitial extends LeaderBoardState {}

class LeaderBoardLoading extends LeaderBoardState {}

class LeaderBoardFetchSuccess extends LeaderBoardState {
  final List<LeaderBoardModel> leads;
  final bool status;
  final bool hasReachedMax;

  LeaderBoardFetchSuccess({
    this.status = true,
    this.hasReachedMax = false,
    required this.leads,
  });
  @override
  List<Object?> get props => [leads, status];
}

class LeaderBoardNextFetchLoading extends LeaderBoardState {
  final List<LeaderBoardModel> leads;

  LeaderBoardNextFetchLoading({
    required this.leads,
  });
  @override
  List<Object?> get props => [leads];
}

class LeaderBoardError extends LeaderBoardState {
  final String error;
  LeaderBoardError({required this.error});
  @override
  List<Object?> get props => [error];
}
