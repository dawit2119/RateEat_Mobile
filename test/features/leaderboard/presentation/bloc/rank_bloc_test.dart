import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/rank.dart';

import 'package:rateeat_mobile/src/features/leaderboard/domain/usecases/user_rank_use_case.dart';

import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_event.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_state.dart';

import 'rank_bloc_test.mocks.dart';

class MockUserRankUseCase extends Mock implements UserRankUseCase {}

@GenerateMocks([MockUserRankUseCase])
void main() {
  late RankBloc rankBloc;
  late MockUserRankUseCase mockUserRankUseCase;

  setUp(() {
    mockUserRankUseCase = MockMockUserRankUseCase();
    rankBloc = RankBloc(userRankUseCase: mockUserRankUseCase);
  });

  group('RankBloc', () {
    test('emits [RankLoading, RankSuccess] when GetUserRank event is added',
        () async {
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
      when(mockUserRankUseCase.getRank())
          .thenAnswer((_) async => Right(mockRank));

      rankBloc.add(GetUserRank());

      await expectLater(
        rankBloc.stream,
        emitsInOrder([RankLoading(), RankSuccess(rank: mockRank)]),
      );
    });

    test('emits [RankLoading, RankError] when GetUserRank event fails',
        () async {
      final error = ServerFailure();
      when(mockUserRankUseCase.getRank()).thenAnswer((_) async => Left(error));

      rankBloc.add(GetUserRank());

      await expectLater(
        rankBloc.stream,
        emitsInOrder([RankLoading(), RankError(error: error.errorMessage)]),
      );
    });
  });
}
