import '../../domain/entity/incentive.dart';

class IncentiveModel extends Incentive {
  const IncentiveModel({
    super.id,
    super.totalIncentivized,
    super.pendingIncentive,
    super.weeklyRank,
  });
  factory IncentiveModel.fromMap(Map<String, dynamic> data) => IncentiveModel(
      id: data['id'],
      totalIncentivized: data['all_time_total'] != null
          ? data['all_time_total'].toDouble()
          : 0.0,
      pendingIncentive: data['current_total'] != null
          ? data['current_total'].toDouble()
          : 0.0,
      weeklyRank: data['weekly_rank']);
}
