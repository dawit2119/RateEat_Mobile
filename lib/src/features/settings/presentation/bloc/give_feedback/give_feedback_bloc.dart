import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/settings/domain/usecase/feedbackusecase.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/give_feedback/give_feedback_event.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/give_feedback/give_feedback_state.dart';

class FeedbackBloc extends Bloc<FeedBackEvent, FeedbackState> {
  final FeedbackUseCase feedbackUseCase;
  FeedbackBloc({required this.feedbackUseCase}) : super(FeedbackInitial()) {
    on<SubmitFeedbackEvent>((event, emit) async {
      emit(FeedbackLoading());
      final res = await feedbackUseCase.giveFeedback(event.comment);
      res.fold((err) {
        emit(FeedbackFailure(error: err.toString()));
      }, (sucess) {
        emit(FeedbackSuccess(message: sucess));
      });
    });
  }
}
