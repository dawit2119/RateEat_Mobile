import 'dart:async';

import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/bloc.dart';

class FollowingListBloc extends Bloc<FollowingListEvent, FollowingListState> {
  List<FollowUser> followings = [];
  Map<String, FollowUser> mapping = {};
  int page = 1;
  bool hasReachedMax = false;
  final GetCurrentUserFollowingsUseCase getCurrentUserFollowingsUseCase;
  final GetOtherUserFollowingsUseCase getOtherUserFollowingsUseCase;
  final FollowUserUseCase followUserUseCase;
  final UnFollowUserUseCase unfollowUserUseCase;
  FollowingListBloc({
    required this.getCurrentUserFollowingsUseCase,
    required this.getOtherUserFollowingsUseCase,
    required this.followUserUseCase,
    required this.unfollowUserUseCase,
  }) : super(FollowingListInitial()) {
    on<GetFollowingList>(getFollowingList);
    on<UnfollowUserFromList>(unfollowUserFromList);
    on<FollowUserFromList>(followUserFromList);
  }

  void getFollowingList(GetFollowingList event, emit) async {
    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
    if (event.page == 1) {
      emit(FollowingListLoading());
      final Either<Failure, List<FollowUser>> res;
      if (user?.id == event.userId) {
        res = await getCurrentUserFollowingsUseCase(
            GetCurrentUserFollowingsParams(
                userId: event.userId, page: event.page, query: event.query));
      } else {
        res = await getOtherUserFollowingsUseCase(GetOtherUserFollowingsParams(
            userId: event.userId, page: event.page, query: event.query));
      }
      res.fold((error) {
        emit(FollowingListFailed());
      }, (followings) {
        this.followings = followings;
        for (FollowUser user in followings) {
          mapping[user.id] = user;
        }
        page = event.page;
        hasReachedMax = followings.isEmpty;
        emit(FollowingListSuccess(
            followings: followings,
            page: event.page,
            hasReachedMax: followings.isEmpty));
      });
    } else {
      emit(FollowingListNextLoading(followings: event.followings));
      final Either<Failure, List<FollowUser>> res;
      if (user?.id == event.userId) {
        res = await getCurrentUserFollowingsUseCase(
            GetCurrentUserFollowingsParams(
                userId: event.userId, page: event.page, query: event.query));
      } else {
        res = await getOtherUserFollowingsUseCase(GetOtherUserFollowingsParams(
            userId: event.userId, page: event.page, query: event.query));
      }
      res.fold((error) {
        emit(FollowingListSuccess(
            followings: event.followings,
            page: event.page - 1,
            hasReachedMax: false));
      }, (followings) {
        if (followings.isNotEmpty) {
          this.followings = [...event.followings, ...followings];
          for (FollowUser user in followings) {
            mapping[user.id] = user;
          }
          page = event.page;
          hasReachedMax = false;
          emit(FollowingListSuccess(
              followings: [...event.followings, ...followings],
              page: event.page,
              hasReachedMax: false));
        } else {
          hasReachedMax = true;
          emit(FollowingListSuccess(
              followings: event.followings,
              page: event.page - 1,
              hasReachedMax: true));
        }
      });
    }
  }

  FutureOr<void> unfollowUserFromList(
      UnfollowUserFromList event, Emitter<FollowingListState> emit) async {
    final res = await unfollowUserUseCase(event.userId);
    res.fold((error) {
      emit(FollowUnFollowFailed(
          page: page, followings: followings, hasReachedMax: hasReachedMax));
    }, (data) {
      if (mapping.containsKey(event.userId)) {
        FollowUserModel user = mapping[event.userId] as FollowUserModel;
        user.setUserFollowing(false);
      }
      emit(FollowUnFollowSuccess(
          userId: event.userId,
          newFollowStatus: false,
          page: page,
          followings: followings,
          hasReachedMax: hasReachedMax));
    });
  }

  FutureOr<void> followUserFromList(
      FollowUserFromList event, Emitter<FollowingListState> emit) async {
    final res = await followUserUseCase(event.userId);

    res.fold((error) {
      emit(FollowUnFollowFailed(
          page: page, followings: followings, hasReachedMax: hasReachedMax));
    }, (data) {
      if (mapping.containsKey(event.userId)) {
        FollowUserModel user = mapping[event.userId] as FollowUserModel;
        user.setUserFollowing(true);
      }
      emit(FollowUnFollowSuccess(
          userId: event.userId,
          newFollowStatus: true,
          page: page,
          followings: followings,
          hasReachedMax: hasReachedMax));
    });
  }
}
