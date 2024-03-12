import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'get_tag_sugggestion_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FoodCategoryRepository>(),
])
void main() {
  late GeTagSuggestionUseCase geTagSuggestionUseCase;
  late MockFoodCategoryRepository mockFoodCategoryRepository;

  setUp(() {
    mockFoodCategoryRepository = MockFoodCategoryRepository();
    geTagSuggestionUseCase = GeTagSuggestionUseCase(
      repository: mockFoodCategoryRepository,
    );
  });

  const testCategories = [
    ItemCategoryModel(
      id: '1',
      name: 'test',
    )
  ];

  group('GeTagSuggestionUseCase', () {
    test(
        'should return a list of item categories when the call to the repository is successful',
        () async {
      // arrange
      when(mockFoodCategoryRepository.getTagSuggestion())
          .thenAnswer((_) async => const Right(testCategories));
      // act
      final result = await geTagSuggestionUseCase(NoParams());
      // assert
      expect(result, const Right(testCategories));
      verify(mockFoodCategoryRepository.getTagSuggestion());
      verifyNoMoreInteractions(mockFoodCategoryRepository);
    });
  });
}
