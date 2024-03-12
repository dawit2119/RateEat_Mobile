import 'package:equatable/equatable.dart';

class LeaderBoardEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class GetLeaderBoardEvent extends LeaderBoardEvent {
  final int limit;
  final int page;

  GetLeaderBoardEvent({
    this.limit = 10,
    this.page = 1,
  });
}
