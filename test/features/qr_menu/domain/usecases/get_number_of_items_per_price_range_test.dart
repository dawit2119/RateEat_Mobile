import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'get_number_of_items_per_price_range_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<QRMenuRepository>(),
])
void main() {
  late GetNumberOfItemsPerPriceRangeUsecase
      getNumberOfItemsPerPriceRangeUsecase;
  late MockQRMenuRepository mockQRMenuRepository;

  setUp(() {
    mockQRMenuRepository = MockQRMenuRepository();
    getNumberOfItemsPerPriceRangeUsecase = GetNumberOfItemsPerPriceRangeUsecase(
      qrMenuRepository: mockQRMenuRepository,
    );
  });

  group('GetNumberOfItemsPerPriceRangeUsecase', () {
    test(
        'should return list of PriceRange when the repository call is successful',
        () async {
      // Given
      final params = GetNumberOfItemsPerPriceRangeParams(
        restaurantId: 'restaurant_id',
        isFasting: false,
        category: null,
        minRating: null,
        query: '',
      );

      final priceRanges = [
        PriceRangeModel(minPrice: 0, maxPrice: 100, count: 5),
        PriceRangeModel(minPrice: 101, maxPrice: 200, count: 10),
      ];

      when(
        mockQRMenuRepository.getNumberOfItemsPerPriceRange(
          restaurantId: anyNamed("restaurantId"),
          isFasting: anyNamed('isFasting'),
          category: anyNamed("category"),
          minRating: anyNamed('minRating'),
          query: anyNamed('query'),
        ),
      ).thenAnswer((_) async => Right(priceRanges));

      // When
      final result = await getNumberOfItemsPerPriceRangeUsecase.call(params);

      // Then
      expect(result, Right(priceRanges));
      verify(
        mockQRMenuRepository.getNumberOfItemsPerPriceRange(
          restaurantId: anyNamed("restaurantId"),
          isFasting: anyNamed('isFasting'),
          category: anyNamed("category"),
          minRating: anyNamed('minRating'),
          query: anyNamed('query'),
        ),
      ).called(1);
    });

    test('should return ServerFailure when the repository call fails',
        () async {
      // Given
      final params = GetNumberOfItemsPerPriceRangeParams(
        restaurantId: 'restaurant_id',
        isFasting: false,
        category: null,
        minRating: null,
        query: '',
      );

      when(
        mockQRMenuRepository.getNumberOfItemsPerPriceRange(
          restaurantId: anyNamed("restaurantId"),
          isFasting: anyNamed('isFasting'),
          category: anyNamed("category"),
          minRating: anyNamed('minRating'),
          query: anyNamed('query'),
        ),
      ).thenAnswer((_) async => Left(ServerFailure(errorMessage: "error")));

      // When
      final result = await getNumberOfItemsPerPriceRangeUsecase.call(params);

      // Then
      expect(result, Left(ServerFailure(errorMessage: "error")));
      verify(
        mockQRMenuRepository.getNumberOfItemsPerPriceRange(
          restaurantId: anyNamed("restaurantId"),
          isFasting: anyNamed('isFasting'),
          category: anyNamed("category"),
          minRating: anyNamed('minRating'),
          query: anyNamed('query'),
        ),
      ).called(1);
    });
  });
}
