part of 'weekly_leader_board_bloc.dart';

abstract class WeeklyLeaderBoardState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class WeeklyLeaderBoardInitial extends WeeklyLeaderBoardState {}

final class WeeklyLeaderBoardLoading extends WeeklyLeaderBoardState {}

final class WeeklyLeaderBoardLoaded extends WeeklyLeaderBoardState {
  final WeeklyLeaderBoardResponses standings;
  final bool hasReachedMax;
  final bool status;
  WeeklyLeaderBoardLoaded({
    this.status = true,
    required this.standings,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [status, standings, hasReachedMax];
}

final class WeeklyLeaderBoardNextLoading extends WeeklyLeaderBoardState {
  final WeeklyLeaderBoardResponses standings;
  WeeklyLeaderBoardNextLoading({
    required this.standings,
  });
}

final class WeeklyLeaderBoardFailure extends WeeklyLeaderBoardState {
  final String message;
  WeeklyLeaderBoardFailure({
    required this.message,
  });
  @override
  List<Object?> get props => [message];
}
