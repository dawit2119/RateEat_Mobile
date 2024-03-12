part of 'monthly_leader_board_bloc.dart';

abstract class MonthlyLeaderBoardState extends Equatable {
  @override
  List<Object?> get props => [];
}

final class MonthlyLeaderBoardInitial extends MonthlyLeaderBoardState {}

final class MonthlyLeaderBoardLoading extends MonthlyLeaderBoardState {}

final class MonthlyLeaderBoardLoaded extends MonthlyLeaderBoardState {
  final MonthlyLeaderBoardResponses standings;
  final bool hasReachedMax;
  final bool status;
  MonthlyLeaderBoardLoaded({
    this.status = true,
    required this.standings,
    this.hasReachedMax = false,
  });

  @override
  List<Object?> get props => [status, standings, hasReachedMax];
}

final class MonthlyLeaderBoardNextLoading extends MonthlyLeaderBoardState {
  final MonthlyLeaderBoardResponses standings;
  MonthlyLeaderBoardNextLoading({
    required this.standings,
  });
}

final class MonthlyLeaderBoardFailure extends MonthlyLeaderBoardState {
  final String message;
  MonthlyLeaderBoardFailure({
    required this.message,
  });
  @override
  List<Object?> get props => [message];
}
