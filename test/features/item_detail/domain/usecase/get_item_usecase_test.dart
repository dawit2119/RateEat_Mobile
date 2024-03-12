import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/domain.dart';

import 'get_item_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ItemRepository>(),
])
void main() {
  late GetItemUseCase getItemUseCase;
  late MockItemRepository mockItemRepository;

  setUp(() {
    mockItemRepository = MockItemRepository();
    getItemUseCase = GetItemUseCase(itemRepository: mockItemRepository);
  });

  const testItemId = 'testItemId';
  final testItemModel = ItemModel(
    itemId: 'testItemId',
    itemName: 'testItemName',
    description: 'testItemDescription',
    price: 10.0,
    imageUrl: 'testImageUrl',
    numberOfReviews: 0,
  );
  group('GetItemUseCase', () {
    test('should call the repository that gets item details', () async {
      // Arrange
      when(
        mockItemRepository.getItem(
          itemId: testItemId,
        ),
      ).thenAnswer((_) async => Right(testItemModel));
      // Act
      final result = await getItemUseCase(testItemId);

      // Assert
      expect(result, Right(testItemModel));
      verify(
        mockItemRepository.getItem(
          itemId: testItemId,
        ),
      );
      verifyNoMoreInteractions(mockItemRepository);
    });
  });
}
