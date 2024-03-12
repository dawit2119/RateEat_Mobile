import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/data_sources/catagories_data_provider.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/catagory_model.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/repositories/categories_repository_impl.dart';

import 'categories_repository_impl_test.mocks.dart';

@GenerateMocks([CatagoriesDataProvider])
void main() {
  late CategoriesRepositoryImpl repository;
  late MockCatagoriesDataProvider mockDataProvider;

  setUp(() {
    mockDataProvider = MockCatagoriesDataProvider();
    repository =
        CategoriesRepositoryImpl(getCategoriesDataProvider: mockDataProvider);
  });

  const restaurantId = '123';
  final mockCategories = [
    Category(
      id: '1',
      name: 'category1',
      isApproved: true,
      menuId: 'menu1',
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      item: [],
      totalItems: 10,
    ),
    Category(
      id: '2',
      name: 'category2',
      isApproved: true,
      menuId: 'menu2',
      createdAt: DateTime.now().toString(),
      updatedAt: DateTime.now().toString(),
      item: [],
      totalItems: 5,
    ),
  ];

  test('should return list of categories when the call is successful',
      () async {
    when(mockDataProvider.getCatagories(restaurantId))
        .thenAnswer((_) async => mockCategories);

    final result = await repository.getCategories(restaurantId: restaurantId);

    expect(result, Right(mockCategories));
    verify(mockDataProvider.getCatagories(restaurantId));
    verifyNoMoreInteractions(mockDataProvider);
  });

  test('should return ServerFailure when the call is unsuccessful', () async {
    when(mockDataProvider.getCatagories(restaurantId))
        .thenThrow(Exception('Server error'));

    final result = await repository.getCategories(restaurantId: restaurantId);

    expect(
        result, Left(ServerFailure(errorMessage: 'Exception: Server error')));
    verify(mockDataProvider.getCatagories(restaurantId));
    verifyNoMoreInteractions(mockDataProvider);
  });
}
