import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

abstract class FollowingListEvent {}

class GetFollowingList extends FollowingListEvent {
  final String userId;
  final int page;
  final List<FollowUser> followings;
  final String query;

  GetFollowingList(
      {required this.userId,
      required this.page,
      required this.followings,
      required this.query});
}

class FollowUserFromList extends FollowingListEvent {
  final String userId;
  FollowUserFromList({required this.userId});
}

class UnfollowUserFromList extends FollowingListEvent {
  final String userId;
  UnfollowUserFromList({required this.userId});
}
