import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'recommended_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetRestaurantRecommendationsUseCase>(),
])
void main() {
  late RecommendedBloc recommendedBloc;
  late MockGetRestaurantRecommendationsUseCase mockGetRecommendedUseCase;

  setUp(() {
    mockGetRecommendedUseCase = MockGetRestaurantRecommendationsUseCase();
    recommendedBloc =
        RecommendedBloc(getRecommendedUseCase: mockGetRecommendedUseCase);
  });

  const testRecommendedParams = GetRecommendedRestaurantsParams(
    page: 1,
    limit: 7,
    latitude: 0,
    longitude: 0,
    tags: [],
  );
  const testRecommendedNextParams = GetRecommendedRestaurantsParams(
    page: 2,
    limit: 7,
    latitude: 0,
    longitude: 0,
    tags: [],
  );

  final restaurants = [
    const RecommendedRestaurantEntity(
      numberOfReviews: 0,
    )
  ];

  group('RecommendedBloc', () {
    test('initial state is RecommendationState', () {
      expect(recommendedBloc.state, RecommendedRestaurantLoading());
    });

    blocTest<RecommendedBloc, RecommendedState>(
      'should emit [RecommendationState(status: ItemStatus.loading), RecommendationState(status: ItemStatus.loaded)] when the call to the GetRecommendedEvent(page: 1) is successful',
      build: () {
        when(
          mockGetRecommendedUseCase(testRecommendedParams),
        ).thenAnswer((_) async => Right(restaurants));
        return recommendedBloc;
      },
      act: (bloc) => bloc.add(
        GetRecommendedEvent(
          page: 1,
          limit: 7,
          latitude: 0,
          longitude: 0,
          tags: [],
        ),
      ),
      expect: () => [
        RecommendedRestaurantLoading(),
        RecommendedRestaurantFetched(restaurants: restaurants),
      ],
    );

    blocTest<RecommendedBloc, RecommendedState>(
      'should emit [RecommendationState(status: ItemStatus.loading), RecommendationState(status: ItemStatus.error)] when the call to the GetRecommendedEvent(page: 1) is unsuccessful',
      build: () {
        when(
          mockGetRecommendedUseCase(testRecommendedParams),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return recommendedBloc;
      },
      act: (bloc) => bloc.add(
        GetRecommendedEvent(
          page: 1,
          limit: 7,
          latitude: 0,
          longitude: 0,
          tags: [],
        ),
      ),
      expect: () => [
        RecommendedRestaurantLoading(),
        RecommendedRestaurantFailure(errorMessage: ""),
      ],
    );

    blocTest<RecommendedBloc, RecommendedState>(
      'should emit [ RecommendationState(status: ItemStatus.loaded)] when the call to the GetRecommendedEvent(page: 2) is successful',
      build: () {
        when(
          mockGetRecommendedUseCase(testRecommendedNextParams),
        ).thenAnswer((_) async => Right(restaurants));
        return recommendedBloc;
      },
      act: (bloc) => bloc.add(
        GetRecommendedEvent(
          page: 2,
          limit: 7,
          latitude: 0,
          longitude: 0,
          tags: [],
        ),
      ),
      expect: () => [
        RecommendedRestaurantNextLoading(restaurants: [], page: 2),
        RecommendedRestaurantFetched(restaurants: restaurants),
      ],
    );

    blocTest<RecommendedBloc, RecommendedState>(
      'should emit [ RecommendationState(status: ItemStatus.nextError)] when the call to the GetRecommendedEvent(page: 2) is unsuccessful',
      build: () {
        when(
          mockGetRecommendedUseCase(testRecommendedNextParams),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return recommendedBloc;
      },
      act: (bloc) => bloc.add(
        GetRecommendedEvent(
          page: 2,
          limit: 7,
          latitude: 0,
          longitude: 0,
          tags: [],
        ),
      ),
      expect: () => [
        RecommendedRestaurantNextLoading(restaurants: [], page: 2),
        const RecommendedRestaurantFetched(
          restaurants: [],
        ),
      ],
    );
  });
}
