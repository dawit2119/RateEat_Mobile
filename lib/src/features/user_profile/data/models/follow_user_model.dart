import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class FollowUserModel extends FollowUser {
  FollowUserModel(
      {required super.id,
      required super.firstName,
      required super.lastName,
      required super.email,
      required super.username,
      required super.imageUrl,
      required super.isFollowed});

  factory FollowUserModel.fromMap(Map<String, dynamic> data) {
    return FollowUserModel(
      id: data["id"],
      firstName: data["first_name"] ?? "",
      lastName: data["last_name"] ?? "",
      email: data["email"] ?? "",
      username: data["username"] ?? "",
      imageUrl: data["image"] ?? "",
      isFollowed: data["is_following"],
    );
  }

  void setUserFollowing(bool isFollowed) {
    this.isFollowed = isFollowed;
  }
}
