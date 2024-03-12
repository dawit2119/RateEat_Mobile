import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/data/datasource/local_homepage_dataprovider.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/popular_items_response.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/highest_rated/popular_event.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/highest_rated/popular_state.dart';

import 'popular_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetPopularUseCase>(),
  MockSpec<AuthenticationLocalSource>(),
  MockSpec<LocalHomepageDataprovider>(),
])
void main() {
  late PopularBloc popularBloc;
  late MockGetPopularUseCase mockGetPopularUseCase;
  late MockAuthenticationLocalSource mockAuthLocalSource;
  late MockLocalHomepageDataprovider mockLocalHomePageDataProvider;

  setUpAll(() {
    mockGetPopularUseCase = MockGetPopularUseCase();
    mockAuthLocalSource = MockAuthenticationLocalSource();
    mockLocalHomePageDataProvider = MockLocalHomepageDataprovider();

    final dpLocator = GetIt.instance;
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => mockAuthLocalSource);
    dpLocator.registerLazySingleton<LocalHomepageDataprovider>(
        () => mockLocalHomePageDataProvider);
  });

  setUp(() {
    popularBloc = PopularBloc(getPopularUseCase: mockGetPopularUseCase);
  });

  final testPopularParams = GetPopularItemsParams(
    page: 1,
    limit: 7,
    lat: 0,
    lng: 0,
    tags: [],
  );
  final testPopularNextParams = GetPopularItemsParams(
    page: 2,
    limit: 7,
    lat: 0,
    lng: 0,
    tags: [],
  );

  final items = [
    ItemModel(
      itemId: '1',
      itemName: 'name',
      description: 'description',
      imageUrl: 'imageUrl',
      numberOfReviews: 0,
    )
  ];

  group('PopularBloc', () {
    test('initial state is TopRatedState', () {
      expect(popularBloc.state, const TopRatedState());
    });

    blocTest<PopularBloc, PopularState>(
      'should emit [TopRatedState(status: ItemStatus.loading), TopRatedState(status: ItemStatus.loaded)] when the call to the GetTopRatedEvent(page: 1) is successful',
      build: () {
        when(
          mockGetPopularUseCase(testPopularParams),
        ).thenAnswer((_) async => Right(
            PopularItemsResponse(items: items, totalItems: items.length)));
        return popularBloc;
      },
      act: (bloc) => bloc.add(const GetTopRatedEvent(
        page: 1,
        limit: 7,
        lat: 0,
        lng: 0,
        tags: [],
      )),
      expect: () => <TopRatedState>[
        const TopRatedState(status: ItemStatus.loading),
        TopRatedState(status: ItemStatus.loaded, popular: items, totalItems: 1),
      ],
    );

    blocTest<PopularBloc, PopularState>(
      'should emit [TopRatedState(status: ItemStatus.error)] when the call to the GetTopRatedEvent(page: 1) is unsuccessful',
      build: () {
        when(
          mockGetPopularUseCase(testPopularParams),
        ).thenAnswer((_) async => Left(ServerFailure()));
        return popularBloc;
      },
      act: (bloc) => bloc.add(const GetTopRatedEvent(
        page: 1,
        limit: 7,
        lat: 0,
        lng: 0,
        tags: [],
      )),
      expect: () => <TopRatedState>[
        const TopRatedState(status: ItemStatus.loading),
        const TopRatedState(
            status: ItemStatus.error, errorMessage: 'Error loading items'),
      ],
    );

    blocTest<PopularBloc, PopularState>(
      'should emit [TopRatedState(status: ItemStatus.loaded)] when the call to the GetTopRatedEvent(page: 2) is successful',
      build: () {
        when(
          mockGetPopularUseCase(testPopularNextParams),
        ).thenAnswer((_) async => Right(
            PopularItemsResponse(items: items, totalItems: items.length)));
        return popularBloc;
      },
      act: (bloc) => bloc.add(const GetTopRatedEvent(
        page: 2,
        limit: 7,
        lat: 0,
        lng: 0,
        tags: [],
      )),
      expect: () => <TopRatedState>[
        TopRatedState(status: ItemStatus.loaded, popular: items, totalItems: 1),
      ],
    );

    blocTest<PopularBloc, PopularState>(
      'should emit [TopRatedState(status: ItemStatus.nextError)] when the call to the GetTopRatedEvent(page: 2) is unsuccessful',
      build: () {
        when(
          mockGetPopularUseCase(testPopularNextParams),
        ).thenAnswer((_) async => Left(NetworkFailure()));
        when(mockLocalHomePageDataProvider.getTopRatedItems())
            .thenAnswer((_) async => []);
        return popularBloc;
      },
      act: (bloc) => bloc.add(const GetTopRatedEvent(
        page: 2,
        limit: 7,
        lat: 0,
        lng: 0,
        tags: [],
      )),
      expect: () => <TopRatedState>[
        const TopRatedState(
            status: ItemStatus.error, errorMessage: 'Error loading items'),
      ],
    );
  });
}
