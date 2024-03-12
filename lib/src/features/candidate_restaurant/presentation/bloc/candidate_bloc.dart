import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/domain/usecase/candidate_usecase.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/bloc/candidatae_event.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/bloc/candidate_state.dart';

class CandidateBloc extends Bloc<CandidateEvent, CandidateState> {
  final CandidateUseCase candidateUseCase;
  CandidateBloc({required this.candidateUseCase}) : super(CandidateInitial()) {
    on<SubmitCandidate>(
      (event, emit) async {
        emit(CandidateLoading());
        try {
          final res = await candidateUseCase.createCandidateRestaurant(
              candidRest: event.candidRest);
          res.fold((err) {
            emit(CandidateFailure(error: err.toString()));
          }, (response) {
            emit(CandidateSuccess(message: response));
          });
        } catch (e) {
          emit(CandidateFailure(error: e.toString()));
        }
      },
    );
  }
}
