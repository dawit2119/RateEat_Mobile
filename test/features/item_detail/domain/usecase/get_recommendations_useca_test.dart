import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/domain.dart';

import 'get_item_usecase_test.mocks.dart';

void main() {
  late GetItemRecommendationsUseCase getItemRecommendationsUseCase;
  late MockItemRepository mockItemRepository;

  setUp(() {
    mockItemRepository = MockItemRepository();
    getItemRecommendationsUseCase = GetItemRecommendationsUseCase(
        recommendationRepository: mockItemRepository);
  });

  const testItemId = 'testItemId';
  final testItemModels = [
    ItemModel(
      itemId: 'testItemId',
      itemName: 'testItemName',
      description: 'testItemDescription',
      price: 10.0,
      imageUrl: 'testImageUrl',
      numberOfReviews: 0,
    )
  ];
  group('GetItemRecommendationsUseCase', () {
    test('should call the repository that gets item recommendations', () async {
      // Arrange
      when(
        mockItemRepository.getItemRecommendations(
          itemId: testItemId,
        ),
      ).thenAnswer((_) async => Right(testItemModels));
      // Act
      final result = await getItemRecommendationsUseCase(testItemId);

      // Assert
      expect(result, Right(testItemModels));
      verify(
        mockItemRepository.getItemRecommendations(
          itemId: testItemId,
        ),
      );
      verifyNoMoreInteractions(mockItemRepository);
    });
  });
}
