import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_response_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/weekly_leader_board_responses.dart';

class WeeklyLeaderBoardResponsesModel extends WeeklyLeaderBoardResponses {
  WeeklyLeaderBoardResponsesModel({
    required super.users,
    required super.rank,
  });
  factory WeeklyLeaderBoardResponsesModel.fromJson(Map<String, dynamic> json) {
    return WeeklyLeaderBoardResponsesModel(
      users: json['leaderboard']
          .map<WeeklyLeaderBoardResponse>(
              (user) => WeeklyLeaderBoardResponse.fromJson(user))
          .toList(),
      rank: json['userRank'],
    );
  }
}
