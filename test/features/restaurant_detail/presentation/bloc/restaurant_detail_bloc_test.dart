import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/datasources/local_restaurant_detail_data_provider.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/use_cases/restaurant_detail_usecase.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_event.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_state.dart';

import 'restaurant_detail_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<RestaurantDetailUseCase>(),
  MockSpec<RestaurantLocalDataSource>(),
])
void main() {
  late RestaurantDetailBloc restaurantDetailBloc;
  late MockRestaurantDetailUseCase mockRestaurantDetailUseCase;
  late MockRestaurantLocalDataSource mockRestaurantLocalDataSource;

  setUp(() async {
    mockRestaurantDetailUseCase = MockRestaurantDetailUseCase();
    restaurantDetailBloc = RestaurantDetailBloc(
      restaurantUseCase: mockRestaurantDetailUseCase,
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
  const testRestaurantModel = RestaurantModel(
    id: 'testRestaurantId',
    numberOfReviews: 0,
  );

  group('Restaurant Detail Bloc', () {
    test('initial state should be RestaurantDetailInitial', () {
      // assert
      expect(restaurantDetailBloc.state, RestaurantDetailInitial());
    });
    blocTest<RestaurantDetailBloc, RestaurantDetailState>(
      'should emit [ RestaurantDetailLoading, RestaurantDetailSuccess] when GetRestaurantDetailEvent is added.',
      build: () {
        when(
          mockRestaurantDetailUseCase(
              const GetRestaurantDetailParams(restaurantId: testRestaurantId)),
        ).thenAnswer((_) async => const Right(testRestaurantModel));

        return restaurantDetailBloc;
      },
      act: (bloc) =>
          bloc.add(GetRestaurantDetailEvent(restaurantId: testRestaurantId)),
      expect: () => <RestaurantDetailState>[
        RestaurantDetailLoading(),
        RestaurantDetailSuccess(restaurant: testRestaurantModel),
      ],
    );

    blocTest<RestaurantDetailBloc, RestaurantDetailState>(
      'should emit [ RestaurantDetailLoading, RestaurantDetailError] when GetRestaurantDetailEvent is added.',
      build: () {
        when(
          mockRestaurantDetailUseCase(
              const GetRestaurantDetailParams(restaurantId: testRestaurantId)),
        ).thenAnswer((_) async => Left(ServerFailure()));

        return restaurantDetailBloc;
      },
      act: (bloc) =>
          bloc.add(GetRestaurantDetailEvent(restaurantId: testRestaurantId)),
      expect: () => <RestaurantDetailState>[
        RestaurantDetailLoading(),
        RestaurantDetailError(error: ServerFailure().errorMessage),
      ],
    );
  });
}
