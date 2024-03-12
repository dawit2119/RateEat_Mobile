import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/restaurant_category.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/use_cases/get_restaurant_menu_categories.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/bloc/restaurant_category/restaurant_category_bloc.dart';

import 'restaurant_category_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetRestaurantMenuCategories>(),
])
void main() {
  late RestaurantCategoryBloc restaurantCategoryBloc;
  late MockGetRestaurantMenuCategories mockGetRestaurantMenuCategories;

  setUp(() {
    mockGetRestaurantMenuCategories = MockGetRestaurantMenuCategories();
    restaurantCategoryBloc = RestaurantCategoryBloc(
      getRestaurantMenuCategories: mockGetRestaurantMenuCategories,
    );
  });

  const params = '1';
  const testResponse = [
    RestaurantMenuCategoryModel(
      id: '1',
      name: 'name',
      menuId: '1',
      isApproved: false,
    ),
  ];

  group('Restaurant Category Bloc', () {
    test('initial state should be RestaurantCategoriesLoading', () {
      // assert
      expect(restaurantCategoryBloc.state, RestaurantCategoriesLoading());
    });

    group('get restaurant categories', () {
      blocTest<RestaurantCategoryBloc, RestaurantCategoryState>(
        'should emit [ RestaurantCategoriesLoading,  RestaurantCategoriesLoaded] when GetRestaurantCategoriesEvent is called.',
        build: () {
          when(
            mockGetRestaurantMenuCategories(
              params,
            ),
          ).thenAnswer((_) async => const Right(testResponse));
          return restaurantCategoryBloc;
        },
        act: (bloc) => bloc.add(const GetRestaurantCategoriesEvent(
          restaurantId: params,
        )),
        expect: () => [
          const RestaurantCategoriesLoaded(
            categories: testResponse,
          ),
        ],
      );

      blocTest<RestaurantCategoryBloc, RestaurantCategoryState>(
        'should emit [ RestaurantCategoriesLoading,  RestaurantCategoriesLoadingFailed] when GetRestaurantCategoriesEvent is called.',
        build: () {
          when(
            mockGetRestaurantMenuCategories(
              params,
            ),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure(errorMessage: 'Server Error'),
            ),
          );
          return restaurantCategoryBloc;
        },
        act: (bloc) => bloc.add(const GetRestaurantCategoriesEvent(
          restaurantId: params,
        )),
        expect: () => [
          const RestaurantCategoriesLoadingFailed(
            message: "Unable to load categories",
          ),
        ],
      );
    });
  });
}
