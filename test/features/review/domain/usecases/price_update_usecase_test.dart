import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/price_update_repository.dart';
import 'package:rateeat_mobile/src/features/review/domain/use_cases/price_update_usecase.dart';

import 'price_update_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PriceReviewRepository>(),
])
void main() {
  late PriceReviewUsecase priceReviewUseCase;
  late MockPriceReviewRepository mockPriceReviewRepository;

  setUp(() {
    mockPriceReviewRepository = MockPriceReviewRepository();
    priceReviewUseCase =
        PriceReviewUsecase(priceReviewRepository: mockPriceReviewRepository);
  });

  final params = PriceReviewUseCaseParams(
    priceReviewRequestModel: PriceReviewRequestModel(
      restaurantId: '1',
      images: [],
    ),
  );

  group('PriceReviewUseCase', () {
    test('should return success message after updating price review', () async {
      // arrange
      when(
        mockPriceReviewRepository.priceReviewRequest(
          priceReviewRequestModel: params.priceReviewRequestModel,
        ),
      ).thenAnswer((_) async => const Right('success'));
      // act
      final result = await priceReviewUseCase(params);
      // assert
      expect(result, const Right('success'));
      verify(
        mockPriceReviewRepository.priceReviewRequest(
          priceReviewRequestModel: params.priceReviewRequestModel,
        ),
      );
      verifyNoMoreInteractions(mockPriceReviewRepository);
    });
  });
}
