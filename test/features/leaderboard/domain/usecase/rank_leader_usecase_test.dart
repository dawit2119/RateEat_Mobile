import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/rank.dart';

import 'package:rateeat_mobile/src/features/leaderboard/domain/repositories/user_rank_repository.dart';
import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/user_rank_use_case.dart';

import 'rank_leader_usecase_test.mocks.dart';

class MockUserRankRepository extends Mock implements UserRankRepository {}

@GenerateMocks([MockUserRankRepository])
void main() {
  late UserRankUseCase userRankUseCase;
  late UserRankRepository mockUserRankRepository;

  setUp(() {
    mockUserRankRepository = MockMockUserRankRepository();
    userRankUseCase =
        UserRankUseCase(userRankRepository: mockUserRankRepository);
  });

  group('UserRankUseCase', () {
    test('should return user rank when repository call is successful',
        () async {
      final mockRank = Rank(
        rank: 1,
        id: '',
        userId: '',
        allTimeTotal: 0,
        currentTotal: 0,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        user: User(
          firstName: '',
          id: '',
          lastName: '',
          phoneNumber: '',
        ),
      );

      when(mockUserRankRepository.getRank())
          .thenAnswer((_) async => Right(mockRank));

      final result = await userRankUseCase.getRank();

      expect(result, Right(mockRank));
      verify(mockUserRankRepository.getRank());
      verifyNoMoreInteractions(mockUserRankRepository);
    });

    test('should return a failure when repository call fails', () async {
      final error = ServerFailure();
      when(mockUserRankRepository.getRank())
          .thenAnswer((_) async => Left(error));

      final result = await userRankUseCase.getRank();

      expect(result, Left(error));
      verify(mockUserRankRepository.getRank());
      verifyNoMoreInteractions(mockUserRankRepository);
    });
  });
}
