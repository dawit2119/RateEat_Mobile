import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/leadermodel.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/all_time_leaderboard_usecase.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/leadear_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/leaderboard_event.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/leaderboard_state.dart';

import 'leaderboard_bloc_test.mocks.dart';

class MockLeaderBoardUseCase extends Mock implements LeaderBoardUseCase {}

@GenerateMocks([MockLeaderBoardUseCase])
void main() {
  late LeaderBoardBloc leaderBoardBloc;
  late MockLeaderBoardUseCase mockLeaderBoardUseCase;

  setUp(() {
    mockLeaderBoardUseCase = MockMockLeaderBoardUseCase();
    leaderBoardBloc =
        LeaderBoardBloc(leaderBoardUseCase: mockLeaderBoardUseCase);
  });

  group('LeaderBoardBloc', () {
    const int page = 1;
    const int limit = 10;
    final mockResponse = [
      LeaderBoardModel(
          id: '',
          userId: '',
          allTimeTotal: 0,
          currentTotal: 0,
          createdAt: '',
          updatedAt: '',
          user: User(
              id: '',
              firstName: 'firstName',
              lastName: 'lastName',
              phoneNumber: 'phoneNumber'))
    ];

    test('emits loading and loaded states with data on success', () async {
      when(mockLeaderBoardUseCase.getLeaders(page: page, limit: limit))
          .thenAnswer((_) async => Right(mockResponse));

      leaderBoardBloc.add(GetLeaderBoardEvent(page: page, limit: limit));

      await expectLater(
        leaderBoardBloc.stream,
        emitsInOrder([
          LeaderBoardLoading(),
          LeaderBoardFetchSuccess(
            status: true,
            hasReachedMax: false,
            leads: mockResponse,
          ),
        ]),
      );
    });

    test('emits loading and failure states on failure', () async {
      const failureMessage = 'Test Failure Message';
      final failure = ServerFailure(errorMessage: failureMessage);
      when(mockLeaderBoardUseCase.getLeaders(page: page, limit: limit))
          .thenAnswer((_) async => Left(failure));

      leaderBoardBloc.add(GetLeaderBoardEvent(page: page, limit: limit));

      await expectLater(
        leaderBoardBloc.stream,
        emitsInOrder([
          LeaderBoardLoading(),
          LeaderBoardError(error: failureMessage),
        ]),
      );
    });
  });
}
