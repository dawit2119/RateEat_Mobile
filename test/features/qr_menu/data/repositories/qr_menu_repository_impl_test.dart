import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'qr_menu_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<QRMenuRemoteDatasource>(),
])
void main() {
  late QRMenuRepositoryImpl repository;
  late MockQRMenuRemoteDatasource mockRemoteDataSource;

  setUp(() {
    mockRemoteDataSource = MockQRMenuRemoteDatasource();
    repository =
        QRMenuRepositoryImpl(qrMenuRemoteDataSource: mockRemoteDataSource);
  });

  group('getQRMenu', () {
    const restaurantId = 'testRestaurantId';
    const page = 1;
    const limit = 20;
    const sortBy = 'price';
    const sortType = 'asc';

    final qrMenu = QRMenuModel(
      items: <QRCategory, List<QRItem>>{},
      categories: [],
      totalCategories: 0,
      restaurantName: 'Test Restaurant',
      restaurantId: 'testRestaurantId',
      restaurantImageUrl: '',
      backgroundColor: '',
      itemBackgroundColor: '',
      restaurant: null,
    );

    test('should return QRMenu on success', () async {
      when(mockRemoteDataSource.getQRMenu(
        restaurantId: restaurantId,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortType: sortType,
        isFasting: false,
        category: null,
        query: null,
        minPrice: null,
        maxPrice: null,
        minRating: null,
      )).thenAnswer((_) async => qrMenu);

      final result = await repository.getQRMenu(
          restaurantId: restaurantId,
          page: page,
          limit: limit,
          sortBy: sortBy,
          sortType: sortType,
          isFasting: false,
          category: null,
          query: null,
          minPrice: null,
          maxPrice: null,
          minRating: null);

      expect(result, Right(qrMenu));
      verify(mockRemoteDataSource.getQRMenu(
        restaurantId: restaurantId,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortType: sortType,
        isFasting: false,
        category: null,
        query: null,
        minPrice: null,
        maxPrice: null,
        minRating: null,
      ));
    });

    test('should return ServerFailure on ServerException', () async {
      when(mockRemoteDataSource.getQRMenu(
        restaurantId: restaurantId,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortType: sortType,
        isFasting: false,
        category: null,
        query: null,
        minPrice: null,
        maxPrice: null,
        minRating: null,
      )).thenThrow(ServerException(errorMessage: 'test error'));

      final result = await repository.getQRMenu(
          restaurantId: restaurantId,
          page: page,
          limit: limit,
          sortBy: sortBy,
          sortType: sortType,
          isFasting: false,
          category: null,
          query: null,
          minPrice: null,
          maxPrice: null,
          minRating: null);

      expect(result, Left(ServerFailure(errorMessage: 'test error')));
    });

    test('should return ServerFailure on other exceptions', () async {
      when(mockRemoteDataSource.getQRMenu(
        restaurantId: restaurantId,
        page: page,
        limit: limit,
        sortBy: sortBy,
        sortType: sortType,
        isFasting: false,
        category: null,
        query: null,
        minPrice: null,
        maxPrice: null,
        minRating: null,
      )).thenThrow(Exception('test exception'));

      final result = await repository.getQRMenu(
          restaurantId: restaurantId,
          page: page,
          limit: limit,
          sortBy: sortBy,
          sortType: sortType,
          isFasting: false,
          category: null,
          query: null,
          minPrice: null,
          maxPrice: null,
          minRating: null);

      expect(result, Left(ServerFailure(errorMessage: 'test exception')));
    });
  });

  group('getNumberOfItemsPerPriceRange', () {
    const restaurantId = 'testRestaurantId';
    final priceRanges = <PriceRange>[];

    test('should return List<PriceRange> on success', () async {
      when(mockRemoteDataSource.getNumberOfItemsPerPriceRange(
        restaurantId: restaurantId,
        isFasting: false,
        category: null,
        minRating: null,
        query: '',
      )).thenAnswer((_) async => priceRanges);

      final result = await repository.getNumberOfItemsPerPriceRange(
          restaurantId: restaurantId,
          isFasting: false,
          category: null,
          minRating: null,
          query: '');

      expect(result, Right(priceRanges));
      verify(mockRemoteDataSource.getNumberOfItemsPerPriceRange(
        restaurantId: restaurantId,
        isFasting: false,
        category: null,
        minRating: null,
        query: '',
      ));
    });

    test('should return ServerFailure on ServerException', () async {
      when(mockRemoteDataSource.getNumberOfItemsPerPriceRange(
        restaurantId: restaurantId,
        isFasting: false,
        category: null,
        minRating: null,
        query: '',
      )).thenThrow(ServerException(errorMessage: 'test error'));

      final result = await repository.getNumberOfItemsPerPriceRange(
          restaurantId: restaurantId,
          isFasting: false,
          category: null,
          minRating: null,
          query: '');

      expect(result, Left(ServerFailure(errorMessage: 'test error')));
    });

    test('should return ServerFailure on other exceptions', () async {
      when(mockRemoteDataSource.getNumberOfItemsPerPriceRange(
        restaurantId: restaurantId,
        isFasting: false,
        category: null,
        minRating: null,
        query: '',
      )).thenThrow(Exception('test exception'));

      final result = await repository.getNumberOfItemsPerPriceRange(
          restaurantId: restaurantId,
          isFasting: false,
          category: null,
          minRating: null,
          query: '');

      expect(result, Left(ServerFailure(errorMessage: 'test exception')));
    });
  });
}
