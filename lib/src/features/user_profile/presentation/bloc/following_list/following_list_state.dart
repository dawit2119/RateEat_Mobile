import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

abstract class FollowingListState {
  List<FollowUser>? followings;
  int page;
  bool hasReachedMax;
  FollowingListState(
      {this.followings, this.page = 1, this.hasReachedMax = false});
}

class FollowingListInitial extends FollowingListState {}

class FollowingListSuccess extends FollowingListState {
  FollowingListSuccess(
      {required super.page,
      required super.followings,
      required super.hasReachedMax});
}

class FollowingListNextLoading extends FollowingListState {
  FollowingListNextLoading({required super.followings});
}

class FollowingListFailed extends FollowingListState {}

class FollowingListLoading extends FollowingListState {}

class FollowUnFollowSuccess extends FollowingListState {
  final String userId; // the id of the user that is followed or unfollowed
  final bool
      newFollowStatus; // the new status of user follow true if user is followed false if unfollowed
  FollowUnFollowSuccess(
      {required super.page,
      required super.followings,
      required super.hasReachedMax,
      required this.userId,
      required this.newFollowStatus});
}

class FollowUnFollowFailed extends FollowingListState {
  FollowUnFollowFailed(
      {required super.page,
      required super.followings,
      required super.hasReachedMax});
}
