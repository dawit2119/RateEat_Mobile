import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../../../domain/domain.dart';

class OthersReviewBloc extends Bloc<GetOthersReviewEvent, OthersReviewState> {
  final GetOtherUserReviewsUseCase getOtherUserReviewsUseCase;

  OthersReviewBloc({required this.getOtherUserReviewsUseCase})
      : super(OthersReviewInitial()) {
    on<GetOthersReviewEvent>(_getOthersReview);
  }

  Future<void> _getOthersReview(
      GetOthersReviewEvent event, Emitter<OthersReviewState> emit) async {
    // Determine initial loading state
    event.page == 1
        ? emit(OthersReviewLoading())
        : emit(OthersReviewNextLoading(userReviews: event.reviews));

    try {
      final result = await getOtherUserReviewsUseCase(
          OtherReviewParams(page: event.page, userId: event.userId));

      result.fold(
        (error) => emit(
          event.page == 1
              ? OthersReviewError(error: error.errorMessage)
              : OthersReviewLoaded(
                  userReviews: event.reviews,
                  page: event.page - 1,
                  hasReachedMax: false,
                ),
        ),
        (otherReviews) {
          final updatedReviews = event.page == 1
              ? otherReviews
              : [...event.reviews, ...otherReviews];

          emit(OthersReviewLoaded(
            userReviews: updatedReviews,
            page: event.page,
            hasReachedMax: otherReviews.isEmpty,
          ));
        },
      );
    } catch (e) {
      emit(OthersReviewError(error: e.toString()));
    }
  }
}

//* Event
class GetOthersReviewEvent extends Equatable {
  final String userId;
  final int page;
  final List<UserReview> reviews;

  const GetOthersReviewEvent(
      {required this.userId, required this.page, required this.reviews});

  @override
  List<Object?> get props => [userId];
}

//* State
class OthersReviewState extends Equatable {
  @override
  List<Object?> get props => [];
}

class OthersReviewInitial extends OthersReviewState {}

class OthersReviewLoading extends OthersReviewState {}

class OthersReviewLoaded extends OthersReviewState {
  final List<UserReview> userReviews;
  final int page;
  final bool hasReachedMax;

  OthersReviewLoaded(
      {required this.userReviews,
      required this.page,
      required this.hasReachedMax});
  @override
  List<Object?> get props => [userReviews];
}

class OthersReviewNextLoading extends OthersReviewState {
  final List<UserReview> userReviews;

  OthersReviewNextLoading({required this.userReviews});
  @override
  List<Object?> get props => [userReviews];
}

class OthersReviewError extends OthersReviewState {
  final String error;
  OthersReviewError({required this.error});
  @override
  List<Object?> get props => [error];
}
