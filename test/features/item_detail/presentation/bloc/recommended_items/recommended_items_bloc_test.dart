import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/data_sources/local_item_detail_datasource.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/recommended_items/recommended_items_event.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/recommended_items/recommended_items_state.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';

import 'recommended_items_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetItemRecommendationsUseCase>(),
  MockSpec<LocalItemDetailDataSource>(),
])
void main() {
  late DetailRecommendationBloc bloc;
  late MockGetItemRecommendationsUseCase mockGetItemRecommendationsUseCase;
  late MockLocalItemDetailDataSource mockLocalItemDetailDataSource;

  setUp(() async {
    mockGetItemRecommendationsUseCase = MockGetItemRecommendationsUseCase();
    mockLocalItemDetailDataSource = MockLocalItemDetailDataSource();
    bloc = DetailRecommendationBloc(
        getItemRecommendationsUseCase: mockGetItemRecommendationsUseCase);
    await dpLocator.reset();
    dpLocator.registerLazySingleton<LocalItemDetailDataSource>(
      () => mockLocalItemDetailDataSource,
    );
  });

  tearDown(() {
    bloc.close();
  });

  group('DetailRecommendationBloc', () {
    const String itemId = 'item1';

    test('initial state is DetailRecommendedInitial', () {
      expect(bloc.state, DetailRecommendedInitial());
    });

    test(
        'emits [DetailRecommendedLoading, DetailRecommendedSuccess] when GetRecommendedItemsEvent is successful',
        () async {
      final recommendations = [
        Item(
          itemId: 'item2',
          itemName: 'Recommendation 1',
          numberOfReviews: 0,
        )
      ];

      when(mockGetItemRecommendationsUseCase(any))
          .thenAnswer((_) async => Right(recommendations));

      bloc.add(GetRecommendedItemsEvent(itemId: itemId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          DetailRecommendedLoading(),
          DetailRecommendedSuccess(
              recommendations: recommendations, isLocal: false),
        ]),
      );
    });

    test(
        'emits [DetailRecommendedLoading, DetailRecommendedSuccess] when local recommendations are retrieved on failure',
        () async {
      final localRecommendations = [
        Item(
            itemId: 'item3',
            itemName: 'Local Recommendation',
            numberOfReviews: 0)
      ];

      when(mockGetItemRecommendationsUseCase(any)).thenAnswer((_) async =>
          Left(ServerFailure(errorMessage: 'Error fetching recommendations')));
      when(mockLocalItemDetailDataSource.getRecommendedItems(itemId))
          .thenAnswer((_) async => localRecommendations);

      bloc.add(GetRecommendedItemsEvent(itemId: itemId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          DetailRecommendedLoading(),
          DetailRecommendedSuccess(
              recommendations: localRecommendations, isLocal: true),
        ]),
      );
    });

    test(
        'emits [DetailRecommendedLoading, DetailRecommendedError] when both use case and local fetch fail',
        () async {
      when(mockGetItemRecommendationsUseCase(any)).thenAnswer((_) async =>
          Left(ServerFailure(errorMessage: 'Error fetching recommendations')));
      when(mockLocalItemDetailDataSource.getRecommendedItems(itemId))
          .thenThrow(Exception('Local fetch error'));

      bloc.add(GetRecommendedItemsEvent(itemId: itemId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          DetailRecommendedLoading(),
          isA<DetailRecommendedError>(),
        ]),
      );
    });

    test(
        'emits [DetailRecommendedLoading, DetailRecommendedError] on unexpected exceptions',
        () async {
      when(mockGetItemRecommendationsUseCase(any))
          .thenThrow(Exception('Unexpected error'));

      bloc.add(GetRecommendedItemsEvent(itemId: itemId));

      await expectLater(
        bloc.stream,
        emitsInOrder([
          DetailRecommendedLoading(),
          isA<DetailRecommendedError>(),
        ]),
      );
    });
  });
}
