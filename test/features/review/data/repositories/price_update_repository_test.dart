import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/datasources/remote_price_review_datasource.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/data/repositories/price_review_repository_impl.dart';

import 'price_update_repository_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<PriceReviewDataSource>(),
])
void main() {
  late PriceReviewRepoImpl priceReviewRepoImpl;
  late MockPriceReviewDataSource mockPriceReviewDataSource;

  setUp(() {
    mockPriceReviewDataSource = MockPriceReviewDataSource();
    priceReviewRepoImpl = PriceReviewRepoImpl(
      priceReviewDataSource: mockPriceReviewDataSource,
    );
  });

  final testPriceUpdate = PriceReviewRequestModel(
    restaurantId: '',
    images: [],
  );

  group('PriceReviewRepoImpl', () {
    test(
      'should return a string when price review is successful',
      () async {
        // arrange
        when(
          mockPriceReviewDataSource.priceReviewRequest(
            priceReviewRequestModel: testPriceUpdate,
          ),
        ).thenAnswer((_) async => 'Review added successfully');
        // act
        final result = await priceReviewRepoImpl.priceReviewRequest(
          priceReviewRequestModel: testPriceUpdate,
        );
        // assert
        expect(result, const Right('Review added successfully'));
        verify(
          mockPriceReviewDataSource.priceReviewRequest(
            priceReviewRequestModel: testPriceUpdate,
          ),
        );
        verifyNoMoreInteractions(mockPriceReviewDataSource);
      },
    );

    test(
      'should return a ServerFailure when price review is unsuccessful',
      () async {
        // arrange
        when(
          mockPriceReviewDataSource.priceReviewRequest(
            priceReviewRequestModel: testPriceUpdate,
          ),
        ).thenThrow(ServerException(errorMessage: 'Server Error'));
        // act
        final result = await priceReviewRepoImpl.priceReviewRequest(
          priceReviewRequestModel: testPriceUpdate,
        );
        // assert
        expect(result, Left(ServerFailure(errorMessage: 'Server Error')));
        verify(
          mockPriceReviewDataSource.priceReviewRequest(
            priceReviewRequestModel: testPriceUpdate,
          ),
        );
        verifyNoMoreInteractions(mockPriceReviewDataSource);
      },
    );
  });
}
