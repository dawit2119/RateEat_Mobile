import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/datasource/remote_leaderboard_datasource.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/leadermodel.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_responses_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_board_request_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_board_responses_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/repostitories/leader_board_repository_impl.dart';

import 'leaderboard_repo_impl_test.mocks.dart';

class MockLeaderDataSource extends Mock implements LeaderDataSource {}

@GenerateMocks([MockLeaderDataSource])
void main() {
  late LeaderRepoImpl leaderRepoImpl;
  late MockLeaderDataSource mockLeaderDataSource;

  setUp(() {
    mockLeaderDataSource = MockMockLeaderDataSource();
    leaderRepoImpl = LeaderRepoImpl(leaderDataSource: mockLeaderDataSource);
  });

  group('getLeaderBoard', () {
    const page = 1;
    const limit = 10;
    test('should return a list of LeaderBoardModel when successful', () async {
      final mockLeaderBoard = [
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
      when(mockLeaderDataSource.getLeaderBoard(limit: limit, page: page))
          .thenAnswer((_) async => mockLeaderBoard);

      final result = await leaderRepoImpl.getLeaderBoard(page: 1, limit: 10);

      expect(result, Right(mockLeaderBoard));
      verify(mockLeaderDataSource.getLeaderBoard(limit: 10, page: 1));
      verifyNoMoreInteractions(mockLeaderDataSource);
    });

    test('should return a ServerFailure when an exception is thrown', () async {
      final error = ServerFailure();
      when(mockLeaderDataSource.getLeaderBoard(limit: limit, page: page))
          .thenThrow(error);

      final result = await leaderRepoImpl.getLeaderBoard(page: 1, limit: 10);

      expect(result, Left(error));
      verify(mockLeaderDataSource.getLeaderBoard(limit: 10, page: 1));
      verifyNoMoreInteractions(mockLeaderDataSource);
    });
  });
  group('getWeeklyLeaderBoard', () {
    final mockRequestModel = WeeklyLeaderBoardRequestModel(page: 1);
    final mockResponseModel =
        WeeklyLeaderBoardResponsesModel(users: [], rank: 1);

    test(
        'should return a WeeklyLeaderBoardResponsesModel when the call is successful',
        () async {
      when(mockLeaderDataSource.getWeeklyLeaderBoard(
        weeklyLeaderBoardRequestModel: mockRequestModel,
      )).thenAnswer((_) async => mockResponseModel);

      final result = await leaderRepoImpl.getWeeklyLeaderBoard(
        weeklyLeaderBoardRequestModel: mockRequestModel,
      );

      expect(result, Right(mockResponseModel));
      verify(mockLeaderDataSource.getWeeklyLeaderBoard(
        weeklyLeaderBoardRequestModel: mockRequestModel,
      ));
      verifyNoMoreInteractions(mockLeaderDataSource);
    });

    test('should return a ServerFailure when the call fails', () async {
      final error = ServerFailure();
      when(mockLeaderDataSource.getWeeklyLeaderBoard(
        weeklyLeaderBoardRequestModel: mockRequestModel,
      )).thenThrow(error);

      final result = await leaderRepoImpl.getWeeklyLeaderBoard(
        weeklyLeaderBoardRequestModel: mockRequestModel,
      );

      expect(result, Left(error));
      verify(mockLeaderDataSource.getWeeklyLeaderBoard(
        weeklyLeaderBoardRequestModel: mockRequestModel,
      ));
      verifyNoMoreInteractions(mockLeaderDataSource);
    });
  });

  group('getMonthlyLeaderBoard', () {
    final mockRequestModel = MonthlyLeaderBoardRequestModel(page: 1);
    final mockResponseModel =
        MonthlyLeaderBoardResponsesModel(users: [], rank: 1);

    test(
        'should return a MonthlyLeaderBoardResponsesModel when the call is successful',
        () async {
      when(mockLeaderDataSource.getMonthlyLeaderBoard(
        monthlyLeaderBoardRequestModel: mockRequestModel,
      )).thenAnswer((_) async => mockResponseModel);

      final result = await leaderRepoImpl.getMonthlyLeaderBoard(
        monthlyLeaderBoardRequestModel: mockRequestModel,
      );

      expect(result, Right(mockResponseModel));
      verify(mockLeaderDataSource.getMonthlyLeaderBoard(
        monthlyLeaderBoardRequestModel: mockRequestModel,
      ));
      verifyNoMoreInteractions(mockLeaderDataSource);
    });

    test('should return a ServerFailure when the call fails', () async {
      final error = ServerFailure();
      when(mockLeaderDataSource.getMonthlyLeaderBoard(
        monthlyLeaderBoardRequestModel: mockRequestModel,
      )).thenThrow(error);

      final result = await leaderRepoImpl.getMonthlyLeaderBoard(
        monthlyLeaderBoardRequestModel: mockRequestModel,
      );

      expect(result, Left(error));
      verify(mockLeaderDataSource.getMonthlyLeaderBoard(
        monthlyLeaderBoardRequestModel: mockRequestModel,
      ));
      verifyNoMoreInteractions(mockLeaderDataSource);
    });
  });
}
