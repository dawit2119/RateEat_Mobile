import 'package:dartz/dartz.dart';
import 'package:mockito/mockito.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/catagory_model.dart';
import 'package:rateeat_mobile/src/features/discover_item/domain/use_cases/categories_usecase.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/category/category_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/category/category_event.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/category/category_state.dart';

import 'category_bloc_test.mocks.dart';

class MockCategoriesUsecase extends Mock implements CategoriesUsecase {}

@GenerateMocks([MockCategoriesUsecase])
void main() {
  group('CategoryBloc', () {
    late CategoryBloc categoryBloc;
    late MockCategoriesUsecase mockCategoriesUsecase;

    setUp(() {
      mockCategoriesUsecase = MockMockCategoriesUsecase();
      categoryBloc = CategoryBloc(categoriesUsecase: mockCategoriesUsecase);
    });

    const String restaurantId = 'restaurantId';
    final mockedCategory = Category(
        id: 'id',
        name: 'Burger',
        isApproved: true,
        menuId: '123',
        createdAt: DateTime.now().toString(),
        updatedAt: DateTime.now().toString(),
        item: [Item(id: '123'), Item(id: 'id')],
        totalItems: 2);

    // test for the category loading and the category loaded
    test(
        'emits loading and success states when category is fetched successfully',
        () async {
      // mock the getCategories method
      when(mockCategoriesUsecase.getCategories(restaurantId))
          .thenAnswer((_) async => Right([mockedCategory]));
      // add the event to the bloc
      categoryBloc.add(GetCategoriesEvent(restaurantId: restaurantId));
      // expect the stream to emit the loading and the loaded states
      await expectLater(
          categoryBloc.stream,
          emitsInOrder([
            CategoryLoading(),
            CategoryLoaded(categories: [mockedCategory])
          ]));
    });

    // test the catergory bloc loading and error states
    test('test the category bloc loading and error states', () async {
      final failure = ServerFailure(errorMessage: 'Failed');
      // mock the get categories method
      when(mockCategoriesUsecase.getCategories(restaurantId))
          .thenAnswer((_) async => Left(failure));

      // add the event to the bloc
      final expected = [
        CategoryLoading(),
        CategoryError(error: failure.errorMessage),
      ];

      expectLater(categoryBloc.stream, emitsInOrder(expected));

      categoryBloc.add(GetCategoriesEvent(restaurantId: restaurantId));
    });
  });
}
