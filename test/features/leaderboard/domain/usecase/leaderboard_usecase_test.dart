import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/leadermodel.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/repositories/leader_board_repository.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/all_time_leaderboard_usecase.dart';

import 'leaderboard_usecase_test.mocks.dart';

class MockLeaderRepository extends Mock implements LeaderRepository {}

@GenerateMocks([MockLeaderRepository])
void main() {
  late LeaderBoardUseCase leaderBoardUseCase;
  late MockLeaderRepository mockLeaderRepository;

  setUp(() {
    mockLeaderRepository = MockMockLeaderRepository();
    leaderBoardUseCase =
        LeaderBoardUseCase(leaderRepository: mockLeaderRepository);
  });

  group('LeaderBoardUseCase', () {
    test('should get a list of leaders from the repository', () async {
      const page = 1;
      const limit = 10;
      final mockLeaders = [
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

      when(mockLeaderRepository.getLeaderBoard(limit: limit, page: page))
          .thenAnswer((_) async => Right(mockLeaders));

      final result =
          await leaderBoardUseCase.getLeaders(page: page, limit: limit);

      expect(result, Right(mockLeaders));
      verify(mockLeaderRepository.getLeaderBoard(limit: limit, page: page));
      verifyNoMoreInteractions(mockLeaderRepository);
    });

    test('should return a failure when repository call fails', () async {
      const page = 1;
      const limit = 10;
      final error = ServerFailure();
      when(mockLeaderRepository.getLeaderBoard(limit: limit, page: page))
          .thenAnswer((_) async => Left(error));

      final result =
          await leaderBoardUseCase.getLeaders(page: page, limit: limit);

      expect(result, Left(error));
      verify(mockLeaderRepository.getLeaderBoard(limit: limit, page: page));
      verifyNoMoreInteractions(mockLeaderRepository);
    });
  });
}
