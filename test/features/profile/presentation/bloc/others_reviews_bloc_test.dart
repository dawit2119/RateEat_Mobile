import 'package:flutter_test/flutter_test.dart';
import 'package:bloc_test/bloc_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_profile/others_user_review_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';

import 'others_reviews_bloc_test.mocks.dart';

@GenerateMocks([GetOtherUserReviewsUseCase])
void main() {
  late MockGetOtherUserReviewsUseCase mockGetOtherUserReviewsUseCase;
  late OthersReviewBloc othersReviewBloc;

  setUp(() {
    mockGetOtherUserReviewsUseCase = MockGetOtherUserReviewsUseCase();
    othersReviewBloc = OthersReviewBloc(
        getOtherUserReviewsUseCase: mockGetOtherUserReviewsUseCase);
  });

  group('OthersReviewBloc', () {
    final otherReviewParams = OtherReviewParams(userId: '1', page: 1);

    test('initial state should be OthersReviewInitial', () {
      expect(othersReviewBloc.state, OthersReviewInitial());
    });

    blocTest<OthersReviewBloc, OthersReviewState>(
      'should emit [OthersReviewLoading, OthersReviewLoaded] when getting other user reviews is successful',
      build: () {
        final reviews = [UserReview(id: '1')];
        when(mockGetOtherUserReviewsUseCase.call(any))
            .thenAnswer((_) async => Right(reviews));
        return othersReviewBloc;
      },
      act: (bloc) => bloc.add(GetOthersReviewEvent(
          userId: '1', page: 1, reviews: [UserReview(id: '1')])),
      expect: () => [
        OthersReviewLoading(),
        OthersReviewLoaded(
            userReviews: [UserReview(id: '1')], page: 1, hasReachedMax: false),
      ],
      verify: (_) {
        verify(mockGetOtherUserReviewsUseCase.call(any)).called(1);
      },
    );

    blocTest<OthersReviewBloc, OthersReviewState>(
      'should emit [OthersReviewLoading, OthersReviewError] when getting other user reviews fails',
      build: () {
        final failure = ServerFailure();
        when(mockGetOtherUserReviewsUseCase.call(any))
            .thenAnswer((_) async => Left(failure));
        return othersReviewBloc;
      },
      act: (bloc) =>
          bloc.add(GetOthersReviewEvent(userId: '1', page: 1, reviews: [])),
      expect: () => [
        OthersReviewLoading(),
        OthersReviewError(error: 'Server failure'),
      ],
      verify: (_) {
        verify(mockGetOtherUserReviewsUseCase.call(any)).called(1);
      },
    );
  });
}
