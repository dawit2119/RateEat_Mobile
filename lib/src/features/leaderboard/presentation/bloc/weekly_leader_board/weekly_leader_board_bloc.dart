import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_board_responses_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/weekly_leader_board_responses.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/weekly_leader_board_usecase.dart';

part 'weekly_leader_board_event.dart';
part 'weekly_leader_board_state.dart';

class WeeklyLeaderBoardBloc
    extends Bloc<WeeklyLeaderBoardEvent, WeeklyLeaderBoardState> {
  final GetWeeklyLeaderBoardUseCase getWeeklyLeaderBoardUseCase;
  WeeklyLeaderBoardBloc({required this.getWeeklyLeaderBoardUseCase})
      : super(WeeklyLeaderBoardInitial()) {
    on<GetWeeklyLeaderBoardEvent>(_getWeeklyLeaderBoards);
  }
  Future<void> _getWeeklyLeaderBoards(GetWeeklyLeaderBoardEvent event,
      Emitter<WeeklyLeaderBoardState> emit) async {
    //* Get Weekly Reviews
    final prevStandings = (state is WeeklyLeaderBoardLoaded)
        ? (state as WeeklyLeaderBoardLoaded).standings
        : WeeklyLeaderBoardResponsesModel(users: [], rank: 0);

    //* Check if it's first page or next page
    if (event.page == 1) {
      emit(WeeklyLeaderBoardLoading());
    } else {
      emit(
        WeeklyLeaderBoardNextLoading(
          standings: prevStandings,
        ),
      );
    }

    Either<Failure, WeeklyLeaderBoardResponses> standings;
    standings = await getWeeklyLeaderBoardUseCase(GetWeeklyLeaderBoardParams(
      weeklyLeaderBoardRequestModel: WeeklyLeaderBoardRequestModel(
        page: event.page,
        limit: event.limit,
      ),
    ));

    //* Emit the response
    emit(
      standings.fold((failure) {
        //* First page error message
        if (event.page == 1) {
          return WeeklyLeaderBoardFailure(message: failure.errorMessage);
        }
        //* Second page error message
        return WeeklyLeaderBoardLoaded(
          status: false,
          standings: prevStandings,
        );
      }, (success) {
        //* page different from first page
        if (event.page != 1) {
          final standings = prevStandings.users;
          final mergedStandings = List.of(standings)..addAll(success.users);

          return WeeklyLeaderBoardLoaded(
            status: true,
            hasReachedMax: success.users.isEmpty,
            standings: prevStandings.copyWith(users: mergedStandings),
          );
        }
        //* first page Success
        return WeeklyLeaderBoardLoaded(
          status: true,
          hasReachedMax: false,
          standings: success,
        );
      }),
    );
  }
}
