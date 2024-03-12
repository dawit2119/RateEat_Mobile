import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/exception.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'filter_screen_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FilterDataProvider>(),
])
void main() {
  late FilterRepositoryImpl filterRepositoryImpl;
  late MockFilterDataProvider mockFilterDataProvider;

  setUp(() {
    mockFilterDataProvider = MockFilterDataProvider();
    filterRepositoryImpl =
        FilterRepositoryImpl(filterDataProvider: mockFilterDataProvider);
  });

  group('FilterRepositoryImpl', () {
    group('filterRestaurant', () {
      test('should call the repository that filters restaurants', () async {
        // Arrange
        when(
          mockFilterDataProvider.filterRestaurant(
            'testQuery',
          ),
        ).thenAnswer((_) async => const []);
        // Act
        final result = await filterRepositoryImpl.filterRestaurant('testQuery');

        // Assert
        expect(result, equals(const Right([])));
      });

      test(
          'should return a ServerFailure when the call to the repository is unsuccessful',
          () async {
        // Arrange
        when(
          mockFilterDataProvider.filterRestaurant(
            'testQuery',
          ),
        ).thenThrow(ServerException());
        // Act
        final result = await filterRepositoryImpl.filterRestaurant('testQuery');

        // Assert
        expect(
          result,
          equals(
            Left(
              ServerFailure(errorMessage: 'ServerException'),
            ),
          ),
        );
      });
    });

    group('priceQuery', () {
      test('should call the repository that filters restaurants by price',
          () async {
        // Arrange
        when(
          mockFilterDataProvider.priceQuery(
            'testPrice',
            'testLocation',
          ),
        ).thenAnswer((_) async => 'testPriceQuery');
        // Act
        final result =
            await filterRepositoryImpl.priceQuery('testPrice', 'testLocation');

        // Assert
        expect(result, equals(const Right('testPriceQuery')));
      });

      test(
          'should return a ServerFailure when the call to the repository is unsuccessful',
          () async {
        // Arrange
        when(
          mockFilterDataProvider.priceQuery(
            'testPrice',
            'testLocation',
          ),
        ).thenThrow(ServerException());
        // Act
        final result =
            await filterRepositoryImpl.priceQuery('testPrice', 'testLocation');

        // Assert
        expect(
          result,
          equals(
            Left(
              ServerFailure(errorMessage: 'ServerException'),
            ),
          ),
        );
      });
    });

    group('priceRangeQuery', () {
      test('should call the repository that filters restaurants by price range',
          () async {
        // Arrange
        when(
          mockFilterDataProvider.priceRangeQuery(
            'testPriceRange',
            'testLocation',
          ),
        ).thenAnswer((_) async => 'testPriceRangeQuery');
        // Act
        final result = await filterRepositoryImpl.priceRangeQuery(
            'testPriceRange', 'testLocation');

        // Assert
        expect(result, equals(const Right('testPriceRangeQuery')));
      });

      test(
          'should return a ServerFailure when the call to the repository is unsuccessful',
          () async {
        // Arrange
        when(
          mockFilterDataProvider.priceRangeQuery(
            'testPriceRange',
            'testLocation',
          ),
        ).thenThrow(ServerException());
        // Act
        final result = await filterRepositoryImpl.priceRangeQuery(
            'testPriceRange', 'testLocation');

        // Assert
        expect(
          result,
          equals(
            Left(
              ServerFailure(errorMessage: 'ServerException'),
            ),
          ),
        );
      });
    });

    group('ratingQuery', () {
      test('should call the repository that filters restaurants by rating',
          () async {
        // Arrange
        when(
          mockFilterDataProvider.ratingQuery(
            'testRating',
            'testLocation',
          ),
        ).thenAnswer((_) async => 'testRatingQuery');
        // Act
        final result = await filterRepositoryImpl.ratingQuery(
            'testRating', 'testLocation');

        // Assert
        expect(result, equals(const Right('testRatingQuery')));
      });

      test(
          'should return a ServerFailure when the call to the repository is unsuccessful',
          () async {
        // Arrange
        when(
          mockFilterDataProvider.ratingQuery(
            'testRating',
            'testLocation',
          ),
        ).thenThrow(ServerException());
        // Act
        final result = await filterRepositoryImpl.ratingQuery(
            'testRating', 'testLocation');

        // Assert
        expect(
          result,
          equals(
            Left(
              ServerFailure(errorMessage: 'ServerException'),
            ),
          ),
        );
      });
    });
  });
}
