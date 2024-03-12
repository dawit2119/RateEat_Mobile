import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/weekly_leader_board_request.dart';

class WeeklyLeaderBoardRequestModel extends WeeklyLeaderBoardRequest {
  WeeklyLeaderBoardRequestModel({
    required super.page,
    super.limit,
  });
}
