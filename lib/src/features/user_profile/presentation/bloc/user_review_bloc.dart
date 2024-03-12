import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';

import '../../domain/domain.dart';

class UserReviewBloc extends Bloc<GetUserReviewEvent, UserReviewState> {
  final GetUserReviewsUseCase getUserReviewsUseCase;

  UserReviewBloc({required this.getUserReviewsUseCase})
      : super(UserReviewInitial()) {
    on<GetUserReviewEvent>(_getUserReview);
  }

  _getUserReview(
      GetUserReviewEvent event, Emitter<UserReviewState> emit) async {
    try {
      List<UserReview> loadedUserReviews = (state is UserReviewLoaded &&
              !(state as UserReviewLoaded).isLocalData)
          ? (state as UserReviewLoaded).userReviews
          : [];

      if (event.page == 1) {
        emit(
          UserReviewLoading(),
        );
      } else {
        emit(
          UserNextReviewsLoading(
            userReviews: loadedUserReviews,
          ),
        );
      }
      final result = await getUserReviewsUseCase(
        GetUserReviewsUseCaseParams(
          userId: event.userId,
          page: event.page,
          limit: event.limit,
        ),
      );
      List<UserReview>? localUserReviews;
      if (result.isLeft()) {
        localUserReviews =
            dpLocator<LocalProfileDataProvider>().getUserReviews();
        if (localUserReviews == null) {
          throw Exception("Failed to get reviews");
        }
      } else {
        localUserReviews = [];
      }
      result.fold(
        (error) async {
          if (event.page == 1) {
            try {
              emit(UserReviewLoaded(
                userReviews: localUserReviews!,
                hasReachedMax: true,
                isLocalData: true,
                page: event.page - 1,
              ));
            } catch (e) {
              emit(UserReviewError(
                error: "Failed to get reviews",
              ));
            }
          } else {
            emit(
              UserReviewLoaded(
                  userReviews: loadedUserReviews,
                  status: false,
                  isLocalData: false,
                  page: event.page - 1),
            );
          }
        },
        (userReviews) {
          if (event.page != 1) {
            dpLocator<LocalProfileDataProvider>()
                .cacheUserReviews(loadedUserReviews..addAll(userReviews));
            emit(
              UserReviewLoaded(
                userReviews: loadedUserReviews..addAll(userReviews),
                hasReachedMax: userReviews.isEmpty,
                isLocalData: false,
                page: event.page,
              ),
            );
          } else {
            try {
              dpLocator<LocalProfileDataProvider>()
                  .cacheUserReviews(userReviews);
            } catch (e) {
              //failed to cache
            }
            emit(
              UserReviewLoaded(
                  userReviews: userReviews,
                  hasReachedMax: false,
                  isLocalData: false,
                  page: event.page),
            );
          }
        },
      );
    } catch (e) {
      emit(UserReviewError(error: e.toString()));
    }
  }
}

//* Event
class GetUserReviewEvent extends Equatable {
  final String userId;
  final int limit;
  final int page;
  const GetUserReviewEvent({
    required this.userId,
    this.page = 1,
    this.limit = 4,
  });

  GetUserReviewEvent copyWith({String? userId, int? limit, int? page}) =>
      GetUserReviewEvent(
          userId: userId ?? this.userId,
          limit: limit ?? this.limit,
          page: page ?? this.page);

  @override
  List<Object?> get props => [userId];
}

//* State
class UserReviewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class UserReviewInitial extends UserReviewState {}

class UserReviewLoading extends UserReviewState {}

class UserReviewLoaded extends UserReviewState {
  final List<UserReview> userReviews;
  final bool hasReachedMax;
  final bool status;
  final bool isLocalData;
  final int page;
  UserReviewLoaded({
    required this.userReviews,
    required this.isLocalData,
    required this.page,
    this.hasReachedMax = false,
    this.status = true,
  });
  @override
  List<Object?> get props => [userReviews, hasReachedMax, page, isLocalData];
}

class UserNextReviewsLoading extends UserReviewState {
  final List<UserReview> userReviews;
  UserNextReviewsLoading({
    required this.userReviews,
  });

  @override
  List<Object?> get props => [userReviews];
}

class UserReviewError extends UserReviewState {
  final String error;
  UserReviewError({required this.error});
  @override
  List<Object?> get props => [error];
}
