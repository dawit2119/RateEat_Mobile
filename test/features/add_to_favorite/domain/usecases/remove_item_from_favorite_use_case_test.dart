import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/use_cases/add_item_to_favorite_use_case.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/use_cases/remove_item_from_favorite_use_case.dart';

import 'add_item_to_favorite_use_case_test.mocks.dart';

void main() {
  late MockFavoriteRepository mockFavoriteRepository;
  late RemoveItemFromFavoriteUseCase removeItemFromFavoriteUseCase;

  setUp(() {
    mockFavoriteRepository = MockFavoriteRepository();
    removeItemFromFavoriteUseCase =
        RemoveItemFromFavoriteUseCase(repository: mockFavoriteRepository);
  });

  const String itemId = '123';
  const params = ItemFavoriteParams(itemId: itemId);

  group('RemoveItemFromFavoriteUseCase', () {
    test('should return true when the repository returns true', () async {
      when(mockFavoriteRepository.removeItemFromFavorite(itemId: itemId))
          .thenAnswer((_) async => const Right(true));

      final result = await removeItemFromFavoriteUseCase(params);

      expect(result, const Right(true));
      verify(mockFavoriteRepository.removeItemFromFavorite(itemId: itemId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });

    test(
        'should return UnauthorizedRequestFailure when the repository returns UnauthorizedRequestFailure',
        () async {
      when(mockFavoriteRepository.removeItemFromFavorite(itemId: itemId))
          .thenAnswer((_) async => Left(UnauthorizedRequestFailure()));

      final result = await removeItemFromFavoriteUseCase(params);

      expect(result, Left(UnauthorizedRequestFailure()));
      verify(mockFavoriteRepository.removeItemFromFavorite(itemId: itemId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });

    test(
        'should return ServerFailure when the repository returns ServerFailure',
        () async {
      when(mockFavoriteRepository.removeItemFromFavorite(itemId: itemId))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Error')));

      final result = await removeItemFromFavoriteUseCase(params);

      expect(result, Left(ServerFailure(errorMessage: 'Error')));
      verify(mockFavoriteRepository.removeItemFromFavorite(itemId: itemId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });

    test('should return CacheFailure when the repository returns cache failure',
        () async {
      when(mockFavoriteRepository.removeItemFromFavorite(itemId: itemId))
          .thenAnswer((_) async => Left(CacheFailure()));

      final result = await removeItemFromFavoriteUseCase(params);

      expect(result, Left(CacheFailure()));
      verify(mockFavoriteRepository.removeItemFromFavorite(itemId: itemId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });
  });
}
