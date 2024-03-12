import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';

import '../../../domain/entities/flag_review.dart';
import '../../../domain/use_cases/flag_review.dart';

part 'flag_review_event.dart';
part 'flag_review_state.dart';

class FlagReviewBloc extends Bloc<FlagReviewEvent, FlagReviewState> {
  final FlagReviewUseCase flagReviewsUseCase;
  FlagReviewBloc({
    required this.flagReviewsUseCase,
  }) : super(FlagReviewInitial()) {
    on<Flag>(_onFlag);
  }
  void _onFlag(Flag event, Emitter emit) async {
    emit(
      FlagReviewLoading(),
    );

    try {
      var response = await flagReviewsUseCase(
        FlagReviewUseCaseParams(
          review: event.review,
        ),
      );
      response.fold(
        (error) => emit(FlagReviewFailed()),
        (r) => emit(
          FlagReviewSuccess(message: "Review flagged"),
        ),
      );
    } catch (e) {
      emit(
        FlagReviewFailed(),
      );
    }
  }
}
