part of 'monthly_leader_board_bloc.dart';

abstract class MonthlyLeaderBoardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetMonthlyLeaderBoardEvent extends MonthlyLeaderBoardEvent {
  final int page;
  final int limit;
  GetMonthlyLeaderBoardEvent({
    this.page = 1,
    this.limit = 10,
  });
}
