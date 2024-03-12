import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/price_item_update_repository.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/price_item_update_usecase.dart';

import 'price_item_update_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ItemPriceReviewRepository>(),
])
void main() {
  late PriceItemUsecase priceItemUseCase;
  late MockItemPriceReviewRepository mockItemPriceReviewRepository;

  setUp(() {
    mockItemPriceReviewRepository = MockItemPriceReviewRepository();
    priceItemUseCase = PriceItemUsecase(
      itemPriceReviewRepository: mockItemPriceReviewRepository,
    );
  });

  final testPriceUpdate = ItemPriceReviewUseCaseParams(
    priceItemReviewRequestModel: PriceItemReviewRequestModel(
      itemId: '1',
      price: 5,
    ),
  );
  // Test the PriceItemUseCase class
  group('PriceItemUseCase', () {
    test('should return a string when the call to the repository is successful',
        () async {
      // arrange
      when(
        mockItemPriceReviewRepository.priceReviewRequest(
          priceItemReviewRequestModel:
              testPriceUpdate.priceItemReviewRequestModel,
        ),
      ).thenAnswer((_) async => const Right('Review added successfully'));
      // act
      final result = await priceItemUseCase(testPriceUpdate);
      // assert
      expect(result, const Right('Review added successfully'));
      verify(
        mockItemPriceReviewRepository.priceReviewRequest(
          priceItemReviewRequestModel:
              testPriceUpdate.priceItemReviewRequestModel,
        ),
      );
      verifyNoMoreInteractions(mockItemPriceReviewRepository);
    });
  });
}
