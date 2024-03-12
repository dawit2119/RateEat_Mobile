class FollowEvent {}

class FollowUserEvent extends FollowEvent {
  final String userId;
  FollowUserEvent({required this.userId});
}

class UnfollowUserEvent extends FollowEvent {
  final String userId;
  UnfollowUserEvent({required this.userId});
}
