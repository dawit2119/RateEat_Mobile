part of 'weekly_leader_board_bloc.dart';

abstract class WeeklyLeaderBoardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetWeeklyLeaderBoardEvent extends WeeklyLeaderBoardEvent {
  final int page;
  final int limit;
  GetWeeklyLeaderBoardEvent({
    this.page = 1,
    this.limit = 10,
  });
}
