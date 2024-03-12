import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/datasource/remote_user_rank_datasource.dart';

import 'package:rateeat_mobile/src/features/leaderboard/data/model/rank.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/repostitories/user_rank_repository_impl.dart';

import 'userrank_repo_impl_test.mocks.dart';

class MockUserRankDataSource extends Mock implements UserRankDataSource {}

@GenerateMocks([MockUserRankDataSource])
void main() {
  late UserRankImpl repository;
  late MockUserRankDataSource mockDataSource;

  setUp(() {
    mockDataSource = MockMockUserRankDataSource();
    repository = UserRankImpl(userRankDataSource: mockDataSource);
  });

  group('getRank', () {
    final mockRank = Rank(
        rank: 1,
        id: '',
        userId: '',
        allTimeTotal: 0,
        currentTotal: 1,
        createdAt: DateTime.now(),
        updatedAt: DateTime.now(),
        user: User(
            id: '',
            firstName: 'firstName',
            lastName: 'lastName',
            phoneNumber: 'phoneNumber'));

    test('should return a Rank when the call is successful', () async {
      when(mockDataSource.getRank()).thenAnswer((_) async => mockRank);

      final result = await repository.getRank();

      expect(result, Right(mockRank));
      verify(mockDataSource.getRank());
      verifyNoMoreInteractions(mockDataSource);
    });

    test('should return a ServerFailure when the call fails', () async {
      final error = ServerFailure();
      when(mockDataSource.getRank()).thenThrow(error);

      final result = await repository.getRank();

      expect(result, Left(error));
      verify(mockDataSource.getRank());
      verifyNoMoreInteractions(mockDataSource);
    });
  });
}
