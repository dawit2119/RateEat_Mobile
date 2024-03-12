import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/src/core/error/exception.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/catagory_model.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/repositories/categories_repository.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/use_cases/categories_usecase.dart';

import 'categories_usecase_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<CategoriesRepository>(),
])
void main() {
  late MockCategoriesRepository mockCategoriesRepository;
  late CategoriesUsecase categoriesUseCase;

  setUp(() {
    mockCategoriesRepository = MockCategoriesRepository();
    categoriesUseCase = CategoriesUsecase(repository: mockCategoriesRepository);
  });

  group('CategoriesUsecase', () {
    const restuarantId = '1';
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
    test('returns list of categories when repository call is successful',
        () async {
      when(mockCategoriesRepository.getCategories(restaurantId: restuarantId))
          .thenAnswer((_) async => Right(mockCategories));

      final result = await categoriesUseCase.getCategories(restuarantId);

      expect(result, Right(mockCategories));
      verify(
          mockCategoriesRepository.getCategories(restaurantId: restuarantId));
      verifyNoMoreInteractions(mockCategoriesRepository);
    });

    test('returns failure when repository call fails', () async {
      final error = ServerFailure(errorMessage: 'Server error');
      when(mockCategoriesRepository.getCategories(restaurantId: restuarantId))
          .thenAnswer((_) async => Left(error));

      final result = await categoriesUseCase.getCategories(restuarantId);

      expect(result, Left(error));
      verify(
          mockCategoriesRepository.getCategories(restaurantId: restuarantId));
      verifyNoMoreInteractions(mockCategoriesRepository);
    });
  });
}
