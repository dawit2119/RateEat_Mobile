import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/datasources/local_restaurant_detail_data_provider.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_review_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/get_restaurant_popular_reviews_usecase.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_popular_reviews/restaurant_popular_reviews_bloc.dart';

import 'restaurant_popular_reviews_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetPopularRestaurantReviewsUseCase>(),
  MockSpec<RestaurantLocalDataSource>(),
])
void main() {
  late RestaurantPopularReviewsBloc restaurantPopularReviewsBloc;
  late MockGetPopularRestaurantReviewsUseCase
      mockGetPopularRestaurantReviewsUseCase;
  late MockRestaurantLocalDataSource mockRestaurantLocalDataSource;

  setUp(() async {
    mockGetPopularRestaurantReviewsUseCase =
        MockGetPopularRestaurantReviewsUseCase();
    restaurantPopularReviewsBloc = RestaurantPopularReviewsBloc(
      getPopularRestaurantReviews: mockGetPopularRestaurantReviewsUseCase,
    );
    mockRestaurantLocalDataSource = MockRestaurantLocalDataSource();
    await dpLocator.reset();

    dpLocator.registerSingleton<RestaurantLocalDataSource>(
        mockRestaurantLocalDataSource);
    when(mockRestaurantLocalDataSource.getCachedPopularItems(any))
        .thenAnswer((_) async => []);
  });

  tearDown(() async {
    await dpLocator.reset();
  });

  const testRestaurantId = 'testRestaurantId';
  const testParams = GetRestaurantPopularReviewsParams(
    restaurantId: testRestaurantId,
  );
  final testPopularRestaurantReviewsResponse = PopularRestaurantReviewsResponse(
    reviews: [
      PopularRestaurantReviewResponseModel(
        id: 'testReviewId',
      ),
    ],
    ratingsCount: [0, 0, 0, 0, 0],
    averageRating: 0,
    numberOfReviews: 0,
  );

  group('Restaurant Popular Reviews Bloc', () {
    test('initial state should be PopularRestaurantReviewsInitial', () {
      // assert
      expect(restaurantPopularReviewsBloc.state,
          PopularRestaurantReviewsInitial());
    });
    blocTest<RestaurantPopularReviewsBloc, RestaurantPopularReviewsState>(
      'should emit [ PopularRestaurantReviewsLoading, PopularRestaurantReviewsLoaded] when GetRestaurantPopularReviewsEvent is added.',
      build: () {
        when(
          mockGetPopularRestaurantReviewsUseCase(testParams),
        ).thenAnswer((_) async => Right(testPopularRestaurantReviewsResponse));

        return restaurantPopularReviewsBloc;
      },
      act: (bloc) => bloc.add(
          GetRestaurantPopularReviewsEvent(restaurantId: testRestaurantId)),
      expect: () => <RestaurantPopularReviewsState>[
        PopularRestaurantReviewsLoading(),
        PopularRestaurantReviewsLoaded(
            popularReviews: testPopularRestaurantReviewsResponse),
      ],
    );

    blocTest<RestaurantPopularReviewsBloc, RestaurantPopularReviewsState>(
      'should emit [ PopularRestaurantReviewsLoading, PopularRestaurantReviewsFailure] when GetRestaurantPopularReviewsEvent is added.',
      build: () {
        when(
          mockGetPopularRestaurantReviewsUseCase(testParams),
        ).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Server Error')));

        return restaurantPopularReviewsBloc;
      },
      act: (bloc) => bloc.add(
          GetRestaurantPopularReviewsEvent(restaurantId: testRestaurantId)),
      expect: () => <RestaurantPopularReviewsState>[
        PopularRestaurantReviewsLoading(),
        PopularRestaurantReviewsFailure(message: "Server Error"),
      ],
    );
  });
}
