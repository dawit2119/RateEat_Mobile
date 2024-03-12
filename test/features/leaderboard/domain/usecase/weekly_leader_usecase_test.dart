import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/weekly_leader_board_responses.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/repositories/leader_board_repository.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/weekly_leader_board_usecase.dart';

import 'weekly_leader_usecase_test.mocks.dart';

class MockLeaderRepository extends Mock implements LeaderRepository {}

@GenerateMocks([MockLeaderRepository])
void main() {
  late GetWeeklyLeaderBoardUseCase getWeeklyLeaderBoardUseCase;
  late LeaderRepository mockLeaderRepository;

  setUp(() {
    mockLeaderRepository = MockMockLeaderRepository();
    getWeeklyLeaderBoardUseCase = GetWeeklyLeaderBoardUseCase(
      leaderRepository: mockLeaderRepository,
    );
  });

  group('GetWeeklyLeaderBoardUseCase', () {
    test('should return weekly leaderboard when repository call is successful',
        () async {
      final mockRequestModel = WeeklyLeaderBoardRequestModel(page: 1);
      final params = GetWeeklyLeaderBoardParams(
        weeklyLeaderBoardRequestModel: mockRequestModel,
      );
      final mockResponse = WeeklyLeaderBoardResponses(users: [], rank: 0);

      when(mockLeaderRepository.getWeeklyLeaderBoard(
        weeklyLeaderBoardRequestModel: mockRequestModel,
      )).thenAnswer((_) async => Right(mockResponse));

      final result = await getWeeklyLeaderBoardUseCase(params);

      expect(result, Right(mockResponse));
      verify(mockLeaderRepository.getWeeklyLeaderBoard(
        weeklyLeaderBoardRequestModel: mockRequestModel,
      ));
      verifyNoMoreInteractions(mockLeaderRepository);
    });

    test('should return a failure when repository call fails', () async {
      final mockRequestModel = WeeklyLeaderBoardRequestModel(page: 1);
      final params = GetWeeklyLeaderBoardParams(
        weeklyLeaderBoardRequestModel: mockRequestModel,
      );
      final error = ServerFailure();
      when(mockLeaderRepository.getWeeklyLeaderBoard(
        weeklyLeaderBoardRequestModel: mockRequestModel,
      )).thenAnswer((_) async => Left(error));

      final result = await getWeeklyLeaderBoardUseCase(params);

      expect(result, Left(error));
      verify(mockLeaderRepository.getWeeklyLeaderBoard(
        weeklyLeaderBoardRequestModel: mockRequestModel,
      ));
      verifyNoMoreInteractions(mockLeaderRepository);
    });
  });
}
