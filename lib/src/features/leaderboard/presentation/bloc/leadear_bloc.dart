import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/leadermodel.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/all_time_leaderboard_usecase.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/leaderboard_event.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/leaderboard_state.dart';

class LeaderBoardBloc extends Bloc<LeaderBoardEvent, LeaderBoardState> {
  final LeaderBoardUseCase leaderBoardUseCase;
  LeaderBoardBloc({required this.leaderBoardUseCase})
      : super(LeaderBoardInitial()) {
    on<GetLeaderBoardEvent>(_getAllTimeLeaderBoards);
  }

  Future<void> _getAllTimeLeaderBoards(
      GetLeaderBoardEvent event, Emitter<LeaderBoardState> emit) async {
    List<LeaderBoardModel> prevLeads = (state is LeaderBoardFetchSuccess)
        ? (state as LeaderBoardFetchSuccess).leads
        : [];
    //* Loading state types
    if (event.page == 1) {
      emit(LeaderBoardLoading());
    } else {
      emit(LeaderBoardNextFetchLoading(
        leads: prevLeads,
      ));
    }

    //* Fetching data
    Either<Failure, List<LeaderBoardModel>> leads;
    leads = await leaderBoardUseCase.getLeaders(
      page: event.page,
      limit: event.limit,
    );

    //* Emit the response
    emit(
      leads.fold((failure) {
        //* First page error message
        if (event.page == 1) {
          return LeaderBoardError(error: failure.errorMessage);
        }
        //* Second page error message
        return LeaderBoardFetchSuccess(
          status: false,
          leads: prevLeads,
        );
      }, (success) {
        //* page different from first page
        if (event.page != 1) {
          return LeaderBoardFetchSuccess(
            status: true,
            hasReachedMax: success.isEmpty,
            leads: List.of(prevLeads)..addAll(success),
          );
        }
        //* first page Success
        return LeaderBoardFetchSuccess(
          status: true,
          hasReachedMax: false,
          leads: success,
        );
      }),
    );
  }
}
