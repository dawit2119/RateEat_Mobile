import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/constants/app_states.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/datasources/local_restaurant_detail_data_provider.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/get_restaurant_items_use_case.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_items/restaurant_items_bloc.dart';

import 'restaurant_items_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetRestaurantItemsUseCase>(),
  MockSpec<RestaurantLocalDataSource>(),
])
void main() {
  late RestaurantItemsBloc restaurantItemsBloc;
  late MockGetRestaurantItemsUseCase mockGetRestaurantItemsUseCase;
  late MockRestaurantLocalDataSource mockRestaurantLocalDataSource;

  setUp(() async {
    mockGetRestaurantItemsUseCase = MockGetRestaurantItemsUseCase();
    restaurantItemsBloc = RestaurantItemsBloc(
      getRestaurantItemsUseCase: mockGetRestaurantItemsUseCase,
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

  tearDown(() async {
    await dpLocator.reset();
  });

  const testRestaurantId = 'testRestaurantId';
  const testPage = 1;
  const testLimit = 7;
  const testParams = GetRestaurantItemsParams(
    page: testPage,
    limit: testLimit,
    restaurantId: testRestaurantId,
  );
  final testRestaurantItems = [
    ItemModel(
      itemId: 'testItemId',
      itemName: 'testItemName',
      price: 0,
      description: 'testItemDescription',
      imageUrl: 'testImageUrl',
      numberOfReviews: 0,
    ),
  ];

  group('Restaurant Items Bloc', () {
    test('initial state should be GetRestaurantItemsState', () {
      // assert
      expect(restaurantItemsBloc.state, GetRestaurantItemsState());
    });
    // blocTest<RestaurantItemsBloc, RestaurantItemsState>(
    //   'should emit [ GetRestaurantItemsState(status: ItemStatus.loading), GetRestaurantItemsState(status: ItemStatus.loaded)] when GetRestaurantItems is added.',
    //   build: () {
    //     when(mockRestaurantLocalDataSource.cacheRestaurantItems(any, any))
    //         .thenAnswer((_) async => {});
    //     when(mockGetRestaurantItemsUseCase(any))
    //         .thenAnswer((_) async => Right(testRestaurantItems));

    //     return restaurantItemsBloc;
    //   },
    //   act: (bloc) => bloc.add(GetRestaurantItems(
    //       restaurantId: testRestaurantId, page: testPage, limit: testLimit)),
    //   expect: () => <RestaurantItemsState>[
    //     GetRestaurantItemsState(
    //       status: ItemStatus.loading,
    //     ),
    //     GetRestaurantItemsState(
    //       status: ItemStatus.loaded,
    //       items: testRestaurantItems,
    //     ),
    //   ],
    // );

    blocTest<RestaurantItemsBloc, RestaurantItemsState>(
      'should emit [ GetRestaurantItemsState(status: ItemStatus.loading), GetRestaurantItemsState(status: ItemStatus.error)] when GetRestaurantItems is added.',
      build: () {
        when(mockGetRestaurantItemsUseCase.call(testParams))
            .thenAnswer((_) async => Left(ServerFailure()));

        return restaurantItemsBloc;
      },
      act: (bloc) => bloc.add(GetRestaurantItems(
          restaurantId: testRestaurantId, page: testPage, limit: testLimit)),
      expect: () => <RestaurantItemsState>[
        GetRestaurantItemsState(
          status: ItemStatus.loading,
        ),
        GetRestaurantItemsState(
            status: ItemStatus.error, errorMessage: "Error"),
      ],
    );
  });
}
