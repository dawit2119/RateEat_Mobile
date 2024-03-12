import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/monthly_leader_board_request.dart';

class MonthlyLeaderBoardRequestModel extends MonthlyLeaderBoardRequest {
  MonthlyLeaderBoardRequestModel({
    required super.page,
    super.limit,
  });
}
