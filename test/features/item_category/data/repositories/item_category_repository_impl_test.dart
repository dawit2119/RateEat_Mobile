import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'item_category_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<FoodCategoryDataProvider>(),
])
void main() {
  late FoodCategoryRepositoryImpl foodCategoryRepositoryImpl;
  late MockFoodCategoryDataProvider mockFoodCategoryDataProvider;

  setUp(() {
    mockFoodCategoryDataProvider = MockFoodCategoryDataProvider();
    foodCategoryRepositoryImpl = FoodCategoryRepositoryImpl(
      searchDataProvider: mockFoodCategoryDataProvider,
    );
  });

  const query = 'test';
  const pageNumber = 1;
  const testCategories = [
    ItemCategoryModel(
      id: '1',
      name: 'test',
    )
  ];

  group('FoodCategoryRepositoryImpl', () {
    test('should be a FoodCategoryRepository', () {
      expect(foodCategoryRepositoryImpl, isA<FoodCategoryRepository>());
    });
    group('searchFoodCategory', () {
      test(
          'should return a list of item categories when the call to the data provider is successful',
          () async {
        // arrange
        when(mockFoodCategoryDataProvider.searchFoodCategory(query, pageNumber))
            .thenAnswer(
          (_) async => testCategories,
        );
        // act
        final result = await foodCategoryRepositoryImpl.searchFoodCategory(
          query,
          pageNumber,
        );
        // assert
        expect(result, const Right(testCategories));
        verify(
            mockFoodCategoryDataProvider.searchFoodCategory(query, pageNumber));
        verifyNoMoreInteractions(mockFoodCategoryDataProvider);
      });

      test(
          'should return a ServerFailure when the call to the data provider is unsuccessful',
          () async {
        // arrange
        when(mockFoodCategoryDataProvider.searchFoodCategory(query, pageNumber))
            .thenThrow(ServerException(errorMessage: 'Server Error'));
        // act
        final result = await foodCategoryRepositoryImpl.searchFoodCategory(
            query, pageNumber);
        // assert
        expect(result, Left(ServerFailure(errorMessage: 'Server Error')));
        verify(
            mockFoodCategoryDataProvider.searchFoodCategory(query, pageNumber));
        verifyNoMoreInteractions(mockFoodCategoryDataProvider);
      });
    });

    group('getTagSuggestion', () {
      test(
          'should return a list of item categories when the call to the data provider is successful',
          () async {
        // arrange
        when(mockFoodCategoryDataProvider.getTagSuggestion())
            .thenAnswer((_) async => testCategories);
        // act
        final result = await foodCategoryRepositoryImpl.getTagSuggestion();
        // assert
        expect(result, const Right(testCategories));
        verify(mockFoodCategoryDataProvider.getTagSuggestion());
        verifyNoMoreInteractions(mockFoodCategoryDataProvider);
      });

      test(
          'should return a ServerFailure when the call to the data provider is unsuccessful',
          () async {
        // arrange
        when(mockFoodCategoryDataProvider.getTagSuggestion())
            .thenThrow(ServerException(errorMessage: 'Server Error'));
        // act
        final result = await foodCategoryRepositoryImpl.getTagSuggestion();
        // assert
        expect(result, Left(ServerFailure(errorMessage: 'Server Error')));
        verify(mockFoodCategoryDataProvider.getTagSuggestion());
        verifyNoMoreInteractions(mockFoodCategoryDataProvider);
      });
    });
  });
}
