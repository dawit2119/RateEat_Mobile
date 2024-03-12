import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'get_qr_menu_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<QRMenuRepository>(),
])
void main() {
  late GetQRMenuUsecase getQRMenuUsecase;
  late MockQRMenuRepository mockQRMenuRepository;

  setUp(() {
    mockQRMenuRepository = MockQRMenuRepository();
    getQRMenuUsecase = GetQRMenuUsecase(qrMenuRepository: mockQRMenuRepository);
  });

  group('GetQRMenuUsecase', () {
    test('should return QRMenu when the repository call is successful',
        () async {
      // Given
      final params = GetQRMenuUseCaseParams(
        restaurantid: 'restaurant_id',
        page: 1,
        category: null,
        isFasting: false,
        limit: 10,
        query: '',
        sortBy: 'name',
        minPrice: null,
        maxPrice: null,
        minRating: null,
        sortType: 'asc',
      );

      final qrMenu = QRMenuModel(
        restaurantName: 'Test Restaurant',
        restaurantId: 'restaurant_id',
        restaurantImageUrl: 'https://example.com/image.jpg',
        backgroundColor: '#FFFFFF',
        itemBackgroundColor: '#F0F0F0',
        totalCategories: 1,
        categories: [],
        items: {},
        restaurant: null,
      );

      when(mockQRMenuRepository.getQRMenu(
        restaurantId: anyNamed('restaurantId'),
        page: anyNamed('page'),
        category: anyNamed('category'),
        isFasting: anyNamed('isFasting'),
        limit: anyNamed('limit'),
        query: anyNamed('query'),
        sortBy: anyNamed('sortBy'),
        minPrice: anyNamed('minPrice'),
        maxPrice: anyNamed('maxPrice'),
        minRating: anyNamed('minRating'),
        sortType: anyNamed('sortType'),
      )).thenAnswer((_) async => Right(qrMenu));

      // When
      final result = await getQRMenuUsecase.call(params);

      // Then
      expect(result, Right(qrMenu));
      verify(mockQRMenuRepository.getQRMenu(
        restaurantId: anyNamed('restaurantId'),
        page: anyNamed('page'),
        category: anyNamed('category'),
        isFasting: anyNamed('isFasting'),
        limit: anyNamed('limit'),
        query: anyNamed('query'),
        sortBy: anyNamed('sortBy'),
        minPrice: anyNamed('minPrice'),
        maxPrice: anyNamed('maxPrice'),
        minRating: anyNamed('minRating'),
        sortType: anyNamed('sortType'),
      )).called(1);
    });

    test('should return ServerFailure when the repository call fails',
        () async {
      // Given
      final params = GetQRMenuUseCaseParams(
        restaurantid: 'restaurant_id',
        page: 1,
        category: null,
        isFasting: false,
        limit: 10,
        query: '',
        sortBy: 'name',
        minPrice: null,
        maxPrice: null,
        minRating: null,
        sortType: 'asc',
      );

      when(mockQRMenuRepository.getQRMenu(
        restaurantId: anyNamed('restaurantId'),
        page: anyNamed('page'),
        category: anyNamed('category'),
        isFasting: anyNamed('isFasting'),
        limit: anyNamed('limit'),
        query: anyNamed('query'),
        sortBy: anyNamed('sortBy'),
        minPrice: anyNamed('minPrice'),
        maxPrice: anyNamed('maxPrice'),
        minRating: anyNamed('minRating'),
        sortType: anyNamed('sortType'),
      )).thenAnswer((_) async => Left(ServerFailure(errorMessage: "error")));

      // When
      final result = await getQRMenuUsecase.call(params);

      // Then
      expect(result, Left(ServerFailure(errorMessage: "error")));
      verify(mockQRMenuRepository.getQRMenu(
        restaurantId: anyNamed('restaurantId'),
        page: anyNamed('page'),
        category: anyNamed('category'),
        isFasting: anyNamed('isFasting'),
        limit: anyNamed('limit'),
        query: anyNamed('query'),
        sortBy: anyNamed('sortBy'),
        minPrice: anyNamed('minPrice'),
        maxPrice: anyNamed('maxPrice'),
        minRating: anyNamed('minRating'),
        sortType: anyNamed('sortType'),
      )).called(1);
    });
  });
}
