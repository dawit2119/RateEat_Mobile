import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_response_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/monthly_leader_board_responses.dart';

class MonthlyLeaderBoardResponsesModel extends MonthlyLeaderBoardResponses {
  MonthlyLeaderBoardResponsesModel({
    required super.users,
    required super.rank,
  });
  factory MonthlyLeaderBoardResponsesModel.fromJson(Map<String, dynamic> json) {
    return MonthlyLeaderBoardResponsesModel(
      users: json['leaderboard']
          .map<MonthlyLeaderBoardResponse>(
              (user) => MonthlyLeaderBoardResponse.fromJson(user))
          .toList(),
      rank: json['userRank'],
    );
  }
}
