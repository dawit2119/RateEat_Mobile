import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/data_sources/local_item_detail_datasource.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/popular_item_reviews/popular_item_reviews_event.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/popular_item_reviews/popular_item_reviews_state.dart';
import 'package:dartz/dartz.dart';

import 'popular_item_reviews_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetPopularItemReviewsUseCase>(),
  MockSpec<LocalItemDetailDataSource>(),
])
void main() {
  late PopularItemReviewsBloc bloc;
  late MockGetPopularItemReviewsUseCase mockGetPopularItemReviewsUseCase;
  late MockLocalItemDetailDataSource mockLocalItemDetailDataSource;

  setUp(() async {
    mockGetPopularItemReviewsUseCase = MockGetPopularItemReviewsUseCase();
    mockLocalItemDetailDataSource = MockLocalItemDetailDataSource();
    bloc = PopularItemReviewsBloc(
        getPopularItemReviewsUseCase: mockGetPopularItemReviewsUseCase);
    await dpLocator.reset();
    dpLocator.registerLazySingleton<LocalItemDetailDataSource>(
      () => mockLocalItemDetailDataSource,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('PopularItemReviewsBloc', () {
    const String itemId = 'item1';

    test('initial state is PopularItemReviewsInitial', () {
      expect(bloc.state, PopularItemReviewsInitial());
    });

    test(
        'emits [PopularItemReviewLoading, PopularItemReviewsLoaded] when GetPopularItemReviewsEvent is successful',
        () async {
      final reviewsResponse = PopularItemReviewsResponse(
        ratingsCount: [1, 2, 3, 4, 5],
        reviews: [],
        averageRating: 4.0,
        numberOfReviews: 10,
      );

      when(mockGetPopularItemReviewsUseCase(any))
          .thenAnswer((_) async => Right(reviewsResponse));

      bloc.add(GetPopularItemReviewsEvent(itemId: itemId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          PopularItemReviewLoading(),
          PopularItemReviewsLoaded(
              popularReviews: reviewsResponse, isLocal: false),
        ]),
      );
    });

    test(
        'emits [PopularItemReviewLoading, PopularItemReviewsLoaded] when local reviews are retrieved on failure',
        () async {
      final localReviewsResponse = PopularItemReviewsResponse(
        ratingsCount: [1, 2, 3, 4, 5],
        reviews: [],
        averageRating: 4.0,
        numberOfReviews: 10,
      );

      when(mockGetPopularItemReviewsUseCase(any)).thenAnswer((_) async =>
          Left(ServerFailure(errorMessage: 'Error fetching reviews')));
      when(mockLocalItemDetailDataSource.getPopularItemReviews(itemId))
          .thenAnswer((_) async => localReviewsResponse);

      bloc.add(GetPopularItemReviewsEvent(itemId: itemId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          PopularItemReviewLoading(),
          PopularItemReviewsLoaded(
              popularReviews: localReviewsResponse, isLocal: true),
        ]),
      );
    });

    test(
        'emits [PopularItemReviewLoading, PopularItemReviewsFailure] when both use case and local fetch fail',
        () async {
      when(mockGetPopularItemReviewsUseCase(any)).thenAnswer((_) async =>
          Left(ServerFailure(errorMessage: 'Error fetching reviews')));
      when(mockLocalItemDetailDataSource.getPopularItemReviews(itemId))
          .thenThrow(Exception('Local fetch error'));

      bloc.add(GetPopularItemReviewsEvent(itemId: itemId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          PopularItemReviewLoading(),
          isA<PopularItemReviewsFailure>(),
        ]),
      );
    });

    test(
        'emits [PopularItemReviewLoading, PopularItemReviewsFailure] on unexpected exceptions',
        () async {
      when(mockGetPopularItemReviewsUseCase(any))
          .thenThrow(Exception('Unexpected error'));

      bloc.add(GetPopularItemReviewsEvent(itemId: itemId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          PopularItemReviewLoading(),
          isA<PopularItemReviewsFailure>(),
        ]),
      );
    });
  });
}
