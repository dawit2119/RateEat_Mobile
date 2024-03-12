import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'get_tag_sugggestion_usecase_test.mocks.dart';

void main() {
  late SearchFoodCategoryUseCase searchFoodCategoryUseCase;
  late MockFoodCategoryRepository mockFoodCategoryRepository;

  setUp(() {
    mockFoodCategoryRepository = MockFoodCategoryRepository();
    searchFoodCategoryUseCase = SearchFoodCategoryUseCase(
      repository: mockFoodCategoryRepository,
    );
  });

  const query = 'test';
  const pageNumber = 1;
  const testCategories = [
    ItemCategoryModel(
      id: '1',
      name: 'test',
    )
  ];
  const searchParams =
      SearchFoodCategoryUseCaseParams(query: 'test', pageNumber: 1);

  group('SearchFoodCategoryUseCase', () {
    test(
        'should return a list of item categories when the call to the repository is successful',
        () async {
      // arrange
      when(mockFoodCategoryRepository.searchFoodCategory(query, pageNumber))
          .thenAnswer((_) async => const Right(testCategories));
      // act
      final result = await searchFoodCategoryUseCase(searchParams);
      // assert
      expect(result, const Right(testCategories));
      verify(mockFoodCategoryRepository.searchFoodCategory(query, pageNumber));
      verifyNoMoreInteractions(mockFoodCategoryRepository);
    });
  });
}
