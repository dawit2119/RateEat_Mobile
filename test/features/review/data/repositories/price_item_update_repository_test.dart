import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_item_price_review.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/repositories/price_item_review_repository_impl.dart';

import 'price_item_update_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<ItemPriceReviewDataSource>(),
])
void main() {
  late PriceItemReviewRepoImpl priceItemReviewRepoImpl;
  late MockItemPriceReviewDataSource mockItemPriceReviewDataSource;

  setUp(() {
    mockItemPriceReviewDataSource = MockItemPriceReviewDataSource();
    priceItemReviewRepoImpl = PriceItemReviewRepoImpl(
        itemPriceReviewDataSource: mockItemPriceReviewDataSource);
  });

  final testPriceUpdate = PriceItemReviewRequestModel(
    itemId: '1',
    price: 5,
  );

  group('PriceItemReviewRepoImpl', () {
    test('should return a string when item price update is successful',
        () async {
      // arrange
      when(
        mockItemPriceReviewDataSource.itemPriceReviewRequest(
          itemPriceReviewRequestModel: testPriceUpdate,
        ),
      ).thenAnswer((_) async => 'Review added successfully');
      // act
      final result = await priceItemReviewRepoImpl.priceReviewRequest(
        priceItemReviewRequestModel: testPriceUpdate,
      );
      // assert
      expect(result, const Right('Review added successfully'));
      verify(
        mockItemPriceReviewDataSource.itemPriceReviewRequest(
          itemPriceReviewRequestModel: testPriceUpdate,
        ),
      );
      verifyNoMoreInteractions(mockItemPriceReviewDataSource);
    });

    test(
        'should return a ServerFailure when item price updates is unsuccessful',
        () async {
      // arrange
      when(
        mockItemPriceReviewDataSource.itemPriceReviewRequest(
          itemPriceReviewRequestModel: testPriceUpdate,
        ),
      ).thenThrow(ServerException(errorMessage: 'Server Error'));
      // act
      final result = await priceItemReviewRepoImpl.priceReviewRequest(
        priceItemReviewRequestModel: testPriceUpdate,
      );
      // assert
      expect(result, Left(ServerFailure(errorMessage: 'Server Error')));
      verify(
        mockItemPriceReviewDataSource.itemPriceReviewRequest(
          itemPriceReviewRequestModel: testPriceUpdate,
        ),
      );
      verifyNoMoreInteractions(mockItemPriceReviewDataSource);
    });
  });
}
