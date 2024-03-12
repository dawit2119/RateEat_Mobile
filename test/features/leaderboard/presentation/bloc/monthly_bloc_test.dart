import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/monthly_leader_board_responses.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/monthly_leader_board_usecase.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/monthly_leader_board/monthly_leader_board_bloc.dart';

import 'monthly_bloc_test.mocks.dart';

class MockGetMonthlyLeaderBoardUseCase extends Mock
    implements GetMonthlyLeaderBoardUseCase {}

@GenerateMocks([MockGetMonthlyLeaderBoardUseCase])
void main() {
  late MonthlyLeaderBoardBloc monthlyLeaderBoardBloc;
  late MockGetMonthlyLeaderBoardUseCase mockGetMonthlyLeaderBoardUseCase;

  setUp(() {
    mockGetMonthlyLeaderBoardUseCase = MockMockGetMonthlyLeaderBoardUseCase();
    monthlyLeaderBoardBloc = MonthlyLeaderBoardBloc(
      getMonthlyLeaderBoardUseCase: mockGetMonthlyLeaderBoardUseCase,
    );
  });

  group('MonthlyLeaderBoardBloc', () {
    const int page = 1;
    const int limit = 10;
    final mockResponse = MonthlyLeaderBoardResponses(users: [], rank: 1);

    test('emits loading and loaded states with data on success', () async {
      // Arrange
      when(mockGetMonthlyLeaderBoardUseCase(
        GetMonthlyLeaderBoardParams(
          monthlyLeaderBoardRequestModel: MonthlyLeaderBoardRequestModel(
            page: page,
            limit: limit,
          ),
        ),
      )).thenAnswer((_) async => Right(mockResponse));

      monthlyLeaderBoardBloc.add(
        GetMonthlyLeaderBoardEvent(page: page, limit: limit),
      );

      await expectLater(
        monthlyLeaderBoardBloc.stream,
        emitsInOrder([
          MonthlyLeaderBoardLoading(),
          MonthlyLeaderBoardLoaded(
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
      when(mockGetMonthlyLeaderBoardUseCase(
        GetMonthlyLeaderBoardParams(
          monthlyLeaderBoardRequestModel: MonthlyLeaderBoardRequestModel(
            page: page,
            limit: limit,
          ),
        ),
      )).thenAnswer((_) async => Left(failure));

      monthlyLeaderBoardBloc.add(
        GetMonthlyLeaderBoardEvent(page: page, limit: limit),
      );

      await expectLater(
        monthlyLeaderBoardBloc.stream,
        emitsInOrder([
          MonthlyLeaderBoardLoading(),
          MonthlyLeaderBoardFailure(message: failureMessage),
        ]),
      );
    });
  });
}
