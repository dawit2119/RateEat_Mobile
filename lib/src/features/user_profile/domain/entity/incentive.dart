import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'incentive.g.dart';

@HiveType(typeId: 15)
class Incentive extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final double? totalIncentivized;
  @HiveField(2)
  final double? pendingIncentive;
  @HiveField(3)
  final int? weeklyRank;

  const Incentive({
    required this.id,
    required this.totalIncentivized,
    required this.pendingIncentive,
    required this.weeklyRank,
  });

  @override
  List<Object?> get props => [
        totalIncentivized,
        pendingIncentive,
      ];
}
