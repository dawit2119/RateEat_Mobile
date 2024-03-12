import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_response_model.dart';

class WeeklyLeaderBoardResponses {
  final List<WeeklyLeaderBoardResponse> users;
  final int rank;

  WeeklyLeaderBoardResponses({
    required this.users,
    required this.rank,
  });

  WeeklyLeaderBoardResponses copyWith({
    List<WeeklyLeaderBoardResponse>? users,
    int? rank,
  }) {
    return WeeklyLeaderBoardResponses(
      users: users ?? this.users,
      rank: rank ?? this.rank,
    );
  }
}
