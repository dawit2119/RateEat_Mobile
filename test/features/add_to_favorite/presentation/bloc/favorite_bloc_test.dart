import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/use_cases/use_cases.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/presentation/bloc/favorite_bloc.dart';

import 'favorite_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AddItemToFavoriteUseCase>(),
  MockSpec<RemoveItemFromFavoriteUseCase>(),
  MockSpec<AddRestaurantToFavoriteUseCase>(),
  MockSpec<RemoveRestaurantFromFavoriteUseCase>()
])
void main() {
  late MockAddItemToFavoriteUseCase mockAddItemToFavorite;
  late MockRemoveItemFromFavoriteUseCase mockRemoveItemFromFavorite;
  late MockAddRestaurantToFavoriteUseCase mockAddRestaurantToFavorite;
  late MockRemoveRestaurantFromFavoriteUseCase mockRemoveRestaurantFromFavorite;
  late FavoriteBloc favoriteBloc;

  setUp(() {
    mockAddItemToFavorite = MockAddItemToFavoriteUseCase();
    mockRemoveItemFromFavorite = MockRemoveItemFromFavoriteUseCase();
    mockAddRestaurantToFavorite = MockAddRestaurantToFavoriteUseCase();
    mockRemoveRestaurantFromFavorite =
        MockRemoveRestaurantFromFavoriteUseCase();

    favoriteBloc = FavoriteBloc(
      addToFavorite: mockAddItemToFavorite,
      removeFromFavorite: mockRemoveItemFromFavorite,
      addRestaurantToFavorite: mockAddRestaurantToFavorite,
      removeRestaurantFromFavorite: mockRemoveRestaurantFromFavorite,
    );
  });

  group('FavoriteBloc', () {
    test('initial state is FavoriteInitial', () {
      expect(favoriteBloc.state, FavoriteInitial());
    });

    group('AddToFavorite', () {
      const String itemId = '123';
      const String restaurantId = '456';

      test('emits FavoriteLoading and FavoriteAdded when adding item succeeds',
          () async {
        when(mockAddItemToFavorite(const ItemFavoriteParams(itemId: itemId)))
            .thenAnswer((_) async => const Right(true));

        final expected = [
          FavoriteLoading(),
          const FavoriteAdded(),
        ];

        expectLater(favoriteBloc.stream, emitsInOrder(expected));

        favoriteBloc
            .add(const AddToFavorite(itemId: itemId, restaurantId: null));
      });

      test('emits FavoriteLoading and FavoriteFailed when adding item fails',
          () async {
        when(mockAddItemToFavorite(const ItemFavoriteParams(itemId: itemId)))
            .thenAnswer(
                (_) async => Left(ServerFailure(errorMessage: 'Error')));

        final expected = [
          FavoriteLoading(),
          const FavoriteFailed(message: 'Error'),
        ];

        expectLater(favoriteBloc.stream, emitsInOrder(expected));

        favoriteBloc
            .add(const AddToFavorite(itemId: itemId, restaurantId: null));
      });

      test(
          'emits FavoriteLoading and FavoriteAdded when adding restaurant succeeds',
          () async {
        when(mockAddRestaurantToFavorite(
                const RestaurantFavoriteParams(restaurantId: restaurantId)))
            .thenAnswer((_) async => const Right(true));

        final expected = [
          FavoriteLoading(),
          const FavoriteAdded(),
        ];

        expectLater(favoriteBloc.stream, emitsInOrder(expected));

        favoriteBloc
            .add(const AddToFavorite(itemId: null, restaurantId: restaurantId));
      });
    });

    group('RemoveFromFavorite', () {
      const String itemId = '123';
      const String restaurantId = '456';

      test(
          'emits FavoriteLoading and FavoriteRemoved when removing item succeeds',
          () async {
        when(mockRemoveItemFromFavorite(
                const ItemFavoriteParams(itemId: itemId)))
            .thenAnswer((_) async => const Right(true));

        final expected = [
          FavoriteLoading(),
          const FavoriteRemoved(),
        ];

        expectLater(favoriteBloc.stream, emitsInOrder(expected));

        favoriteBloc
            .add(const RemoveFromFavorite(itemId: itemId, restaurantId: null));
      });

      test('emits FavoriteLoading and FavoriteFailed when removing item fails',
          () async {
        when(mockRemoveItemFromFavorite(
                const ItemFavoriteParams(itemId: itemId)))
            .thenAnswer(
                (_) async => Left(ServerFailure(errorMessage: 'Error')));

        final expected = [
          FavoriteLoading(),
          const FavoriteFailed(message: 'Error'),
        ];

        expectLater(favoriteBloc.stream, emitsInOrder(expected));

        favoriteBloc
            .add(const RemoveFromFavorite(itemId: itemId, restaurantId: null));
      });

      test(
          'emits FavoriteLoading and FavoriteRemoved when removing restaurant succeeds',
          () async {
        when(mockRemoveRestaurantFromFavorite(
                const RestaurantFavoriteParams(restaurantId: restaurantId)))
            .thenAnswer((_) async => const Right(true));

        final expected = [
          FavoriteLoading(),
          const FavoriteRemoved(),
        ];

        expectLater(favoriteBloc.stream, emitsInOrder(expected));

        favoriteBloc.add(
            const RemoveFromFavorite(itemId: null, restaurantId: restaurantId));
      });
    });

    test('emits FavoriteInitial when ResetFavorite event is added', () async {
      final expected = [
        FavoriteInitial(),
      ];

      expectLater(favoriteBloc.stream, emitsInOrder(expected));

      favoriteBloc.add(ResetFavorite());
    });
  });

  tearDown(() {
    favoriteBloc.close();
  });
}
