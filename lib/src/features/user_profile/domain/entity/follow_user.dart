//does not extend equatable because isFollowed can be changed and equatable inherits immutable
class FollowUser {
  final String id;
  final String firstName;
  final String lastName;
  final String email;
  final String username;
  final String imageUrl;
  bool? isFollowed;

  FollowUser(
      {required this.id,
      required this.firstName,
      required this.lastName,
      required this.email,
      required this.username,
      required this.imageUrl,
      required this.isFollowed});
}
