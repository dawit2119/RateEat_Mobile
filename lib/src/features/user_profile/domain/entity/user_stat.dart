import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_stat.g.dart';

@HiveType(typeId: 17)
class UserStat extends Equatable {
  @HiveField(0)
  final int? followers;
  @HiveField(1)
  final int? following;
  @HiveField(2)
  final int? contributions;
  @HiveField(3)
  final int? favoritesCount;
  @HiveField(4)
  final int? reviewsCount;
  @HiveField(5)
  final int? draftsCount;
  @HiveField(6)
  final int? recommendations;
  const UserStat(
      {this.favoritesCount,
      this.reviewsCount,
      this.draftsCount,
      this.followers,
      this.following,
      this.contributions,
      this.recommendations});

  @override
  List<Object?> get props => [followers, following, contributions];
}
