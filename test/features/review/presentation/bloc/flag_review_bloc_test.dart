import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/flag_review.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/flag_review.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/flag_review/flag_review_bloc.dart';

import 'flag_review_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FlagReviewUseCase>(),
])
void main() {
  late FlagReviewBloc flagReviewBloc;
  late MockFlagReviewUseCase mockFlagReviewUseCase;

  setUp(() {
    mockFlagReviewUseCase = MockFlagReviewUseCase();
    flagReviewBloc = FlagReviewBloc(
      flagReviewsUseCase: mockFlagReviewUseCase,
    );
  });

  const testMessage = 'testMessage';
  const testFlagReviewRequestModel = FlagReview(
    reviewId: 'testReviewId',
    reportType: '',
    userId: '1',
  );

  const params = FlagReviewUseCaseParams(
    review: testFlagReviewRequestModel,
  );

  group('Flag Review Bloc', () {
    test('initial state should be FlagReviewInitial', () {
      // assert
      expect(flagReviewBloc.state, FlagReviewInitial());
    });
    blocTest<FlagReviewBloc, FlagReviewState>(
      'should emit [ FlagReviewLoading, FlagReviewSuccess] when Flag is added.',
      build: () {
        when(
          mockFlagReviewUseCase(params),
        ).thenAnswer((_) async => const Right(testMessage));

        return flagReviewBloc;
      },
      act: (bloc) => bloc.add(
        Flag(
          review: testFlagReviewRequestModel,
        ),
      ),
      expect: () => <FlagReviewState>[
        FlagReviewLoading(),
        FlagReviewSuccess(message: testMessage),
      ],
    );

    blocTest<FlagReviewBloc, FlagReviewState>(
      'should emit [ FlagReviewLoading, FlagReviewFailed] when Flag is added.',
      build: () {
        when(
          mockFlagReviewUseCase(params),
        ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: "Server Error")));

        return flagReviewBloc;
      },
      act: (bloc) => bloc.add(
        Flag(
          review: testFlagReviewRequestModel,
        ),
      ),
      expect: () => <FlagReviewState>[
        FlagReviewLoading(),
        FlagReviewFailed(),
      ],
    );
  });
}
