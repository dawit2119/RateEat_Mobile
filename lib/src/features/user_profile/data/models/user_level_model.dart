import 'package:rateeat_mobile/src/features/user_profile/domain/entity/user_level.dart';

class UserLevelModel extends UserLevel {
  const UserLevelModel({super.level, super.levelName, super.nextLevelMinimum});
  factory UserLevelModel.fromMap(json) {
    return UserLevelModel(
        level: json["level"],
        levelName: json["level_name"],
        nextLevelMinimum: json["next_level_contribution_requirement"]);
  }
  @override
  Map<String, dynamic> toJson() {
    return {
      "level": level,
      "level_name": levelName,
      "next_level_contribution_requirement": nextLevelMinimum
    };
  }
}
