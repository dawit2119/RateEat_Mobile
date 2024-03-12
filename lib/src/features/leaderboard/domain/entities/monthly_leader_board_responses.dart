import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_response_model.dart';

class MonthlyLeaderBoardResponses {
  final List<MonthlyLeaderBoardResponse> users;
  final int rank;

  MonthlyLeaderBoardResponses({
    required this.users,
    required this.rank,
  });

  MonthlyLeaderBoardResponses copyWith({
    List<MonthlyLeaderBoardResponse>? users,
    int? rank,
  }) {
    return MonthlyLeaderBoardResponses(
      users: users ?? this.users,
      rank: rank ?? this.rank,
    );
  }
}
