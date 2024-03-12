import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

abstract class FollowerListState {}

class FollowerListInitial extends FollowerListState {}

class FollowerListSuccess extends FollowerListState {
  final int page;
  final List<FollowUser> followers;
  final bool hasReachedMax;
  FollowerListSuccess(
      {required this.page,
      required this.followers,
      required this.hasReachedMax});
}

class FollowerListNextLoading extends FollowerListState {
  final List<FollowUser> followers;
  FollowerListNextLoading({required this.followers});
}

class FollowerListFailed extends FollowerListState {}

class FollowerListLoading extends FollowerListState {}
