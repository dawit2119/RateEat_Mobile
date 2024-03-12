import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_responses_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/monthly_leader_board_responses.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/monthly_leader_board_usecase.dart';

part 'monthly_leader_board_event.dart';
part 'monthly_leader_board_state.dart';

class MonthlyLeaderBoardBloc
    extends Bloc<MonthlyLeaderBoardEvent, MonthlyLeaderBoardState> {
  final GetMonthlyLeaderBoardUseCase getMonthlyLeaderBoardUseCase;

  MonthlyLeaderBoardBloc({required this.getMonthlyLeaderBoardUseCase})
      : super(MonthlyLeaderBoardInitial()) {
    on<GetMonthlyLeaderBoardEvent>(_getMonthlyLeaderBoards);
  }

  Future<void> _getMonthlyLeaderBoards(GetMonthlyLeaderBoardEvent event,
      Emitter<MonthlyLeaderBoardState> emit) async {
    //* Get Monthly Reviews
    final prevStandings = (state is MonthlyLeaderBoardLoaded)
        ? (state as MonthlyLeaderBoardLoaded).standings
        : MonthlyLeaderBoardResponsesModel(users: [], rank: 0);

    //* Check if it's first page or next page
    if (event.page == 1) {
      emit(MonthlyLeaderBoardLoading());
    } else {
      emit(
        MonthlyLeaderBoardNextLoading(
          standings: prevStandings,
        ),
      );
    }

    Either<Failure, MonthlyLeaderBoardResponses> standings;
    standings = await getMonthlyLeaderBoardUseCase(GetMonthlyLeaderBoardParams(
      monthlyLeaderBoardRequestModel: MonthlyLeaderBoardRequestModel(
        page: event.page,
        limit: event.limit,
      ),
    ));

    //* Emit the response
    emit(
      standings.fold((failure) {
        //* First page error message
        if (event.page == 1) {
          return MonthlyLeaderBoardFailure(message: failure.errorMessage);
        }
        //* Second page error message
        return MonthlyLeaderBoardLoaded(
          status: false,
          standings: prevStandings,
        );
      }, (success) {
        //* page different from first page
        if (event.page != 1) {
          final standings = prevStandings.users;
          final mergedStandings = List.of(standings)..addAll(success.users);

          return MonthlyLeaderBoardLoaded(
            status: true,
            hasReachedMax: success.users.isEmpty,
            standings: prevStandings.copyWith(users: mergedStandings),
          );
        }
        //* first page Success
        return MonthlyLeaderBoardLoaded(
          status: true,
          hasReachedMax: false,
          standings: success,
        );
      }),
    );
  }
}
