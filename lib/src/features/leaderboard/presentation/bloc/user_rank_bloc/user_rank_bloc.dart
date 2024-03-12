import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/user_rank_use_case.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_event.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_state.dart';

class RankBloc extends Bloc<RankEvent, RankState> {
  final UserRankUseCase userRankUseCase;
  RankBloc({required this.userRankUseCase}) : super(RankInitial()) {
    on<GetUserRank>(
      (event, emit) async {
        emit(RankLoading());
        final res = await userRankUseCase.getRank();
        res.fold((err) {
          emit(RankError(error: err.errorMessage));
        }, (response) {
          emit(RankSuccess(rank: response));
        });
      },
    );
  }
}
