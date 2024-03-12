import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/data/models/menu.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/menu.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/use_cases/get_restaurant_menu_category_items_use_case.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/use_cases/get_restaurant_menu_items_use_case.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/bloc/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:rateeat_mobile/src/features/homepage/data/models/item_model.dart';

import 'restaurant_menu_bloc_test.mocks.dart';

@GenerateMocks(
    [GetRestaurantMenuCategoryItemsUseCase, GetRestaurantMenuItemsUseCase])
void main() {
  late RestaurantMenuBloc restaurantMenuBloc;
  late MockGetRestaurantMenuCategoryItemsUseCase mockCategoryItemsUseCase;
  late MockGetRestaurantMenuItemsUseCase mockItemsUseCase;

  setUp(() {
    mockCategoryItemsUseCase = MockGetRestaurantMenuCategoryItemsUseCase();
    mockItemsUseCase = MockGetRestaurantMenuItemsUseCase();
    restaurantMenuBloc = RestaurantMenuBloc(
      itemsUseCase: mockItemsUseCase,
      categoryItemsUseCase: mockCategoryItemsUseCase,
    );
  });

  tearDown(() {
    restaurantMenuBloc.close();
  });

  final testMenu = MenuModel(
    id: 'menu123',
    items: [
      ItemModel(
        itemId: 'item1',
        itemName: 'Test Item',
        price: 10.99,
        description: 'Test description',
        numberOfReviews: 0,
      ),
    ],
    totalItemsCount: 1,
    loadedItemsCount: 1,
  );

  group('RestaurantMenuBloc', () {
    test('initial state should be RestaurantMenuCategoryItemsFetching', () {
      expect(
          restaurantMenuBloc.state, isA<RestaurantMenuCategoryItemsFetching>());
    });

    blocTest<RestaurantMenuBloc, RestaurantMenuState>(
      'emits [RestaurantMenuCategoryItemsFetching, RestaurantMenuCategoryItemsFetched] when GetRestaurantMenuCategoryItems is added',
      build: () {
        when(mockCategoryItemsUseCase(any))
            .thenAnswer((_) async => Right(testMenu));
        return restaurantMenuBloc;
      },
      act: (bloc) => bloc.add(const GetRestaurantMenuCategoryItems(
        restaurantId: 'restaurant123',
        categoryId: 'category123',
        page: 1,
        limit: 10,
        query: '',
        sortBy: 'name',
      )),
      expect: () => [
        isA<RestaurantMenuCategoryItemsFetching>(),
        isA<RestaurantMenuCategoryItemsFetched>(),
      ],
      verify: (_) {
        verify(mockCategoryItemsUseCase(GetRestaurantMenuCategoryItemsParams(
          restaurantId: 'restaurant123',
          categoryId: 'category123',
          page: 1,
          limit: 10,
          query: '',
          sortBy: 'name',
        ))).called(1);
      },
    );

    blocTest<RestaurantMenuBloc, RestaurantMenuState>(
      'emits [RestaurantMenuCategoryItemsFetching, RestaurantMenuCategoryItemsFetchingFailed] when GetRestaurantMenuCategoryItems fails',
      build: () {
        when(mockCategoryItemsUseCase(any)).thenAnswer(
            (_) async => Left(ServerFailure(errorMessage: 'Error')));
        return restaurantMenuBloc;
      },
      act: (bloc) => bloc.add(const GetRestaurantMenuCategoryItems(
        restaurantId: 'restaurant123',
        categoryId: 'category123',
        page: 1,
        limit: 10,
        query: '',
        sortBy: 'name',
      )),
      expect: () => [
        isA<RestaurantMenuCategoryItemsFetching>(),
        isA<RestaurantMenuCategoryItemsFetchingFailed>(),
      ],
    );
  });
}
