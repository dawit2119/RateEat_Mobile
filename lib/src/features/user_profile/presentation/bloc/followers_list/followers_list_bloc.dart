import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/follow_user.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/get_current_user_followers_use_case.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/other_user/get_other_user_followers_use_case.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/bloc.dart';

class FollowerListBloc extends Bloc<FollowerListEvent, FollowerListState> {
  List<FollowUser> followers = [];
  Map<String, FollowUser> mapping = {};
  int page = 0;
  bool hasReachedMax = false;

  final GetCurrentUserFollowersUseCase getCurrentUserFollowersUseCase;
  final GetOtherUserFollowersUseCase getOtherUserFollowersUseCase;
  FollowerListBloc({
    required this.getCurrentUserFollowersUseCase,
    required this.getOtherUserFollowersUseCase,
  }) : super(FollowerListInitial()) {
    on<GetFollowerList>(getFollowerList);
    on<UpdateFollowStatus>(updateFollowStatus);
  }

  void getFollowerList(GetFollowerList event, emit) async {
    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
    if (event.page == 1) {
      emit(FollowerListLoading());
      final Either<Failure, List<FollowUser>> res;
      if (user?.id == event.userId) {
        res = await getCurrentUserFollowersUseCase(
            GetCurrentUserFollowersParams(
                userId: event.userId, page: event.page, query: event.query));
      } else {
        res = await getOtherUserFollowersUseCase(GetOtherUserFollowersParams(
            userId: event.userId, page: event.page, query: event.query));
      }
      res.fold((error) {
        emit(FollowerListFailed());
      }, (followers) {
        this.followers = followers;
        for (FollowUser user in followers) {
          mapping[user.id] = user;
        }
        emit(FollowerListSuccess(
            followers: followers,
            page: event.page,
            hasReachedMax: followers.isEmpty));
      });
    } else {
      emit(FollowerListNextLoading(followers: event.followers));
      final Either<Failure, List<FollowUser>> res;
      if (user?.id == event.userId) {
        res = await getCurrentUserFollowersUseCase(
            GetCurrentUserFollowersParams(
                userId: event.userId, page: event.page, query: event.query));
      } else {
        res = await getOtherUserFollowersUseCase(GetOtherUserFollowersParams(
            userId: event.userId, page: event.page, query: event.query));
      }
      res.fold((error) {
        emit(FollowerListFailed());
      }, (followers) {
        if (followers.isNotEmpty) {
          this.followers = followers;
          for (FollowUser user in followers) {
            mapping[user.id] = user;
          }
          emit(FollowerListSuccess(
              followers: [...event.followers, ...followers],
              page: event.page,
              hasReachedMax: false));
        } else {
          emit(FollowerListSuccess(
              followers: followers, page: event.page - 1, hasReachedMax: true));
        }
      });
    }
  }

  FutureOr<void> updateFollowStatus(
      UpdateFollowStatus event, Emitter<FollowerListState> emit) {
    if (mapping.containsKey(event.userId)) {
      final user = mapping[event.userId] as FollowUserModel;
      user.setUserFollowing(event.followStatus);
    }
    emit(FollowerListSuccess(
        page: page, followers: followers, hasReachedMax: hasReachedMax));
  }
}
