import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/datasources/local_restaurant_detail_data_provider.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/get_popular_items_usecase.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_items/popular_restaurant_items_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_items/restaurant_items_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/entities.dart';

import 'popular_restaurant_items_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetPopularItemsUseCase>(),
  MockSpec<RestaurantLocalDataSource>(),
])
void main() {
  late RestaurantPopularItemsBloc restaurantPopularItemsBloc;
  late MockGetPopularItemsUseCase mockGetPopularItemsUseCase;
  late MockRestaurantLocalDataSource mockRestaurantLocalDataSource;

  setUp(() async {
    mockGetPopularItemsUseCase = MockGetPopularItemsUseCase();
    restaurantPopularItemsBloc = RestaurantPopularItemsBloc(
      getPopularItemsUseCase: mockGetPopularItemsUseCase,
    );
    mockRestaurantLocalDataSource = MockRestaurantLocalDataSource();

    await dpLocator.reset();
    dpLocator.registerSingleton<RestaurantLocalDataSource>(
        mockRestaurantLocalDataSource);
    when(mockRestaurantLocalDataSource.getCachedRestaurantDetail(any))
        .thenAnswer((_) async => null);
    when(mockRestaurantLocalDataSource.getCachedRestaurantItems(any))
        .thenAnswer((_) async => []);
    when(mockRestaurantLocalDataSource.getCachedPopularItems(any))
        .thenAnswer((_) async => []);
    when(mockRestaurantLocalDataSource.getCachedPopularReviews(any))
        .thenAnswer((_) async => null);
  });

  tearDown(() {
    dpLocator.reset();
  });

  const testRestaurantId = 'testRestaurantId';
  const testParams = GetPopularItemsParams(
    restaurantId: testRestaurantId,
  );

  const testRestaurantMenuItem = [
    RestaurantMenuItem(
      id: "restaurantId",
      name: "restaurantName",
      price: 0,
      description: "description",
      imageUrl: "imageUrl",
    )
  ];

  group('Restaurant Popular Items Bloc', () {
    test('initial state should be RestaurantPopularItemsFetching', () {
      // assert
      expect(
          restaurantPopularItemsBloc.state, RestaurantPopularItemsFetching());
    });
    blocTest<RestaurantPopularItemsBloc, RestaurantItemsState>(
      'should emit [ RestaurantPopularItemsFetching, RestaurantPopularItemsFetched] when GetRestaurantPopularItems is added.',
      build: () {
        when(
          mockGetPopularItemsUseCase(testParams),
        ).thenAnswer((_) async => const Right(testRestaurantMenuItem));

        return restaurantPopularItemsBloc;
      },
      act: (bloc) =>
          bloc.add(GetRestaurantPopularItems(restaurantId: testRestaurantId)),
      expect: () => <RestaurantItemsState>[
        RestaurantPopularItemsFetching(),
        RestaurantPopularItemsFetched(popularItems: testRestaurantMenuItem),
      ],
    );

    blocTest<RestaurantPopularItemsBloc, RestaurantItemsState>(
      'should emit [ RestaurantPopularItemsFetching, RestaurantPopularItemsFetchingFailed] when GetRestaurantPopularItems is added.',
      build: () {
        when(
          mockGetPopularItemsUseCase(testParams),
        ).thenAnswer((_) async =>
            Left(ServerFailure(errorMessage: "Failed to fetch popular items")));

        return restaurantPopularItemsBloc;
      },
      act: (bloc) =>
          bloc.add(GetRestaurantPopularItems(restaurantId: testRestaurantId)),
      expect: () => <RestaurantItemsState>[
        RestaurantPopularItemsFetching(),
        RestaurantPopularItemsFetchingFailed(
            message: "Failed to fetch popular items"),
      ],
    );
  });
}
