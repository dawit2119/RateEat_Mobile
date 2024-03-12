import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/repositories/favorite_repository.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/domain/use_cases/use_cases.dart';

import 'add_item_to_favorite_use_case_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FavoriteRepository>(),
])
void main() {
  late MockFavoriteRepository mockFavoriteRepository;
  late AddItemToFavoriteUseCase addItemToFavoriteUseCase;

  setUp(() {
    mockFavoriteRepository = MockFavoriteRepository();
    addItemToFavoriteUseCase =
        AddItemToFavoriteUseCase(repository: mockFavoriteRepository);
  });

  const String itemId = '123';
  const params = ItemFavoriteParams(itemId: itemId);

  group('AddItemToFavoriteUseCase', () {
    test('should return true when the repository returns true', () async {
      when(mockFavoriteRepository.addItemToFavorite(itemId: itemId))
          .thenAnswer((_) async => const Right(true));

      final result = await addItemToFavoriteUseCase(params);

      expect(result, const Right(true));
      verify(mockFavoriteRepository.addItemToFavorite(itemId: itemId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });

    test(
        'should return Server failure when the repository returns server failure',
        () async {
      when(mockFavoriteRepository.addItemToFavorite(itemId: itemId))
          .thenAnswer((_) async => Left(ServerFailure(errorMessage: 'Error')));

      final result = await addItemToFavoriteUseCase(params);

      expect(result, Left(ServerFailure(errorMessage: 'Error')));
      verify(mockFavoriteRepository.addItemToFavorite(itemId: itemId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });

    test('should return CacheFailure when the repository returns cache failure',
        () async {
      when(mockFavoriteRepository.addItemToFavorite(itemId: itemId))
          .thenAnswer((_) async => Left(CacheFailure(errorMessage: 'Error')));

      final result = await addItemToFavoriteUseCase(params);

      expect(result, Left(CacheFailure()));
      verify(mockFavoriteRepository.addItemToFavorite(itemId: itemId));
      verifyNoMoreInteractions(mockFavoriteRepository);
    });
  });
}
