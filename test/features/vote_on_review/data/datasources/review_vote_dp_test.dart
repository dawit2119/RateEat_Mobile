import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/data/data_sources/review_vote_dp.dart';
import 'package:rateeat_mobile/src/features/vote_on_review/domain/entities/vote_on_review.dart';

import 'review_vote_dp_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() {
  late VoteOnReviewDataProvider dataProvider;
  late MockDio mockDio;

  setUp(() async {
    mockDio = MockDio();
    dataProvider = VoteOnReviewDataProvider(dio: mockDio);
    TestWidgetsFlutterBinding.ensureInitialized();
    await dotenv.load(fileName: ".env");
  });

  group('upVoteItemReview', () {
    test('returns VoteResponse on successful upvote', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      final responseData = {'success': true};
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: responseData,
                statusCode: 201,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataProvider.upVoteItemReview(
          userId: userId, reviewId: reviewId);

      expect(result.isRight(), true);
      expect(result.isLeft(), false);
      result.fold((l) {}, (r) {
        expect(r, isA<VoteResponse>());
      });
    });

    test('returns ServerFailure on server error', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 500,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataProvider.upVoteItemReview(
          userId: userId, reviewId: reviewId);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });

    test('returns NetworkFailure on non-5xx error', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 400,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataProvider.upVoteItemReview(
          userId: userId, reviewId: reviewId);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<NetworkFailure>());
    });

    test('returns ServerFailure on exception', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenThrow(Exception('Network error'));

      final result = await dataProvider.upVoteItemReview(
          userId: userId, reviewId: reviewId);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });
  });

  group('downVoteItemReview', () {
    test('returns VoteResponse on successful downvote', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      final responseData = {'success': true};
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: responseData,
                statusCode: 201,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataProvider.downVoteItemReview(
          userId: userId, reviewId: reviewId);

      expect(result.isRight(), true);
      result.fold((l) {}, (r) {
        expect(r, isA<VoteResponse>());
      });
    });

    test('returns ServerFailure on server error', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 500,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataProvider.downVoteItemReview(
          userId: userId, reviewId: reviewId);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });

    test('returns NetworkFailure on non-5xx error', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 400,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataProvider.downVoteItemReview(
          userId: userId, reviewId: reviewId);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<NetworkFailure>());
    });

    test('returns ServerFailure on exception', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenThrow(Exception('Network error'));

      final result = await dataProvider.downVoteItemReview(
          userId: userId, reviewId: reviewId);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });
  });

  group('upVoteRestaurantReview', () {
    test('returns VoteResponse on successful upvote', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      final responseData = {'success': true};
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: responseData,
                statusCode: 201,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataProvider.upVoteRestaurantReview(
          userId: userId, reviewId: reviewId);

      expect(result.isRight(), true);
      result.fold((l) {}, (r) {
        expect(r, isA<VoteResponse>());
      });
    });

    test('returns ServerFailure on server error', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 500,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataProvider.upVoteRestaurantReview(
          userId: userId, reviewId: reviewId);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });

    test('returns NetworkFailure on non-5xx error', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 400,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataProvider.upVoteRestaurantReview(
          userId: userId, reviewId: reviewId);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<NetworkFailure>());
    });

    test('returns ServerFailure on exception', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenThrow(Exception('Network error'));

      final result = await dataProvider.upVoteRestaurantReview(
          userId: userId, reviewId: reviewId);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });
  });

  group('downVoteRestaurantReview', () {
    test('returns VoteResponse on successful downvote', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      final responseData = {'success': true};
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: responseData,
                statusCode: 201,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataProvider.downVoteRestaurantReview(
          userId: userId, reviewId: reviewId);

      expect(result.isRight(), true);
      result.fold((l) {}, (r) {
        expect(r, isA<VoteResponse>());
      });
    });

    test('returns ServerFailure on server error', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 500,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataProvider.downVoteRestaurantReview(
          userId: userId, reviewId: reviewId);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });

    test('returns NetworkFailure on non-5xx error', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
                data: {},
                statusCode: 400,
                requestOptions: RequestOptions(path: ''),
              ));

      final result = await dataProvider.downVoteRestaurantReview(
          userId: userId, reviewId: reviewId);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<NetworkFailure>());
    });

    test('returns ServerFailure on exception', () async {
      final userId = 'user123';
      final reviewId = 'review123';
      when(mockDio.post(any,
              options: anyNamed('options'), data: anyNamed('data')))
          .thenThrow(Exception('Network error'));

      final result = await dataProvider.downVoteRestaurantReview(
          userId: userId, reviewId: reviewId);

      expect(result.isLeft(), true);
      expect(result.fold((l) => l, (r) => null), isA<ServerFailure>());
    });
  });
}
