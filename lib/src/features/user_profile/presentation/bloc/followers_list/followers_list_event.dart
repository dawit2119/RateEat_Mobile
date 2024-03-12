import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

abstract class FollowerListEvent {}

class GetFollowerList extends FollowerListEvent {
  final String userId;
  final int page;
  final List<FollowUser> followers;
  final String query;

  GetFollowerList(
      {required this.userId,
      required this.page,
      required this.followers,
      required this.query});
}

class UpdateFollowStatus extends FollowerListEvent {
  final String userId;
  final bool followStatus;
  UpdateFollowStatus({required this.userId, required this.followStatus});
}
