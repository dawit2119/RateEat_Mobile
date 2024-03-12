import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
part 'user_level.g.dart';

@HiveType(typeId: 19)
class UserLevel extends Equatable {
  @HiveField(0)
  final int? level;
  @HiveField(1)
  final String? levelName;
  @HiveField(2)
  final int? nextLevelMinimum;

  const UserLevel({
    this.level,
    this.levelName,
    this.nextLevelMinimum,
  });

  @override
  List<Object?> get props => [level, levelName];

  toJson() {}
}
