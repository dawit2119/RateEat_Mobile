import 'package:dartz/dartz.dart';

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_request_model.dart';

import 'package:rateeat_mobile/src/features/leaderboard/domain/entities/monthly_leader_board_responses.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/repositories/leader_board_repository.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/monthly_leader_board_usecase.dart';

import 'montly_leader_usecase_test.mocks.dart';

class MockLeaderRepository extends Mock implements LeaderRepository {}

@GenerateMocks([MockLeaderRepository])
void main() {
  late GetMonthlyLeaderBoardUseCase getMonthlyLeaderBoardUseCase;
  late MockLeaderRepository mockLeaderRepository;

  setUp(() {
    mockLeaderRepository = MockMockLeaderRepository();
    getMonthlyLeaderBoardUseCase =
        GetMonthlyLeaderBoardUseCase(leaderRepository: mockLeaderRepository);
  });

  group('GetMonthlyLeaderBoardUseCase', () {
    test('should get monthly leaderboard from the repository', () async {
      final mockRequestModel = MonthlyLeaderBoardRequestModel(page: 1);
      final params = GetMonthlyLeaderBoardParams(
          monthlyLeaderBoardRequestModel: mockRequestModel);
      final mockResponse = MonthlyLeaderBoardResponses(users: [], rank: 0);

      when(mockLeaderRepository.getMonthlyLeaderBoard(
              monthlyLeaderBoardRequestModel: mockRequestModel))
          .thenAnswer((_) async => Right(mockResponse));

      final result = await getMonthlyLeaderBoardUseCase(params);

      expect(result, Right(mockResponse));
      verify(mockLeaderRepository.getMonthlyLeaderBoard(
          monthlyLeaderBoardRequestModel: mockRequestModel));
      verifyNoMoreInteractions(mockLeaderRepository);
    });

    test('should return a failure when repository call fails', () async {
      final mockRequestModel = MonthlyLeaderBoardRequestModel(page: 1);
      final params = GetMonthlyLeaderBoardParams(
          monthlyLeaderBoardRequestModel: mockRequestModel);
      final error = ServerFailure();
      when(mockLeaderRepository.getMonthlyLeaderBoard(
              monthlyLeaderBoardRequestModel: mockRequestModel))
          .thenAnswer((_) async => Left(error));

      // Act
      final result = await getMonthlyLeaderBoardUseCase(params);

      // Assert
      expect(result, Left(error));
      verify(mockLeaderRepository.getMonthlyLeaderBoard(
          monthlyLeaderBoardRequestModel: mockRequestModel));
      verifyNoMoreInteractions(mockLeaderRepository);
    });
  });
}
