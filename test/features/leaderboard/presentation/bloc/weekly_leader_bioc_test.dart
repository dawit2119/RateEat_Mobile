import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/weekly_leader_board_responses.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/weekly_leader_board_usecase.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/weekly_leader_board/weekly_leader_board_bloc.dart';

import 'weekly_leader_bioc_test.mocks.dart';

class MockGetWeeklyLeaderBoardUseCase extends Mock
    implements GetWeeklyLeaderBoardUseCase {}

@GenerateMocks([MockGetWeeklyLeaderBoardUseCase])
void main() {
  late WeeklyLeaderBoardBloc weeklyLeaderBoardBloc;
  late MockGetWeeklyLeaderBoardUseCase mockGetWeeklyLeaderBoardUseCase;

  setUp(() {
    mockGetWeeklyLeaderBoardUseCase = MockMockGetWeeklyLeaderBoardUseCase();
    weeklyLeaderBoardBloc = WeeklyLeaderBoardBloc(
      getWeeklyLeaderBoardUseCase: mockGetWeeklyLeaderBoardUseCase,
    );
  });

  group('WeeklyLeaderBoardBloc', () {
    const int page = 1;
    const int limit = 10;
    final mockResponse = WeeklyLeaderBoardResponses(users: [], rank: 1);

    test('emits loading and loaded states with data on success', () async {
      // Arrange
      when(mockGetWeeklyLeaderBoardUseCase(
        GetWeeklyLeaderBoardParams(
          weeklyLeaderBoardRequestModel: WeeklyLeaderBoardRequestModel(
            page: page,
            limit: limit,
          ),
        ),
      )).thenAnswer((_) async => Right(mockResponse));

      // Act
      weeklyLeaderBoardBloc.add(
        GetWeeklyLeaderBoardEvent(page: page, limit: limit),
      );

      // Assert
      await expectLater(
        weeklyLeaderBoardBloc.stream,
        emitsInOrder([
          WeeklyLeaderBoardLoading(),
          WeeklyLeaderBoardLoaded(
            status: true,
            hasReachedMax: false,
            standings: mockResponse,
          ),
        ]),
      );
    });

    test('emits loading and failure states on failure', () async {
      const failureMessage = 'Test Failure Message';
      final failure = ServerFailure(errorMessage: failureMessage);
      when(mockGetWeeklyLeaderBoardUseCase(
        GetWeeklyLeaderBoardParams(
          weeklyLeaderBoardRequestModel: WeeklyLeaderBoardRequestModel(
            page: page,
            limit: limit,
          ),
        ),
      )).thenAnswer((_) async => Left(failure));

      weeklyLeaderBoardBloc.add(
        GetWeeklyLeaderBoardEvent(page: page, limit: limit),
      );

      await expectLater(
        weeklyLeaderBoardBloc.stream,
        emitsInOrder([
          WeeklyLeaderBoardLoading(),
          WeeklyLeaderBoardFailure(message: failureMessage),
        ]),
      );
    });
  });
}
