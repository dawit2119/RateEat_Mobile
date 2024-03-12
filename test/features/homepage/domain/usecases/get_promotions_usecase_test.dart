import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'get_highest_rated_items_usecase_test.mocks.dart';

void main() {
  late GetPromotionUseCase getPromotionUseCase;
  late MockHomeRepository mockHomeRepository;

  setUp(() {
    mockHomeRepository = MockHomeRepository();
    getPromotionUseCase = GetPromotionUseCase(
      repository: mockHomeRepository,
    );
  });

  const promotions = [
    Promotion(
      itemId: "itemId",
      foodName: "foodName",
      restaurantName: "restaurantName",
      imageUrl: "imageUrl",
      discount: 10,
    )
  ];

  group('GetPromotionUseCase', () {
    test(
        'should return a list of promotions when the call to the GetPromotion is successful',
        () async {
      // arrange
      when(
        mockHomeRepository.getPromotions(),
      ).thenAnswer((_) async => const Right(promotions));
      // act
      final result = await getPromotionUseCase(
        NoParams(),
      );
      // assert
      expect(result, const Right(promotions));
      verify(mockHomeRepository.getPromotions());
    });
  });
}
