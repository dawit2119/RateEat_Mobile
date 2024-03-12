// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';

// import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
// import 'package:rateeat_mobile/src/core/constants/size_config.dart';
// import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
// import 'package:rateeat_mobile/src/features/map_section/domain/entities/restaurant.dart';
// import 'package:rateeat_mobile/src/features/order/presentation/bloc/total_price/total_price_bloc.dart';
// import 'package:rateeat_mobile/src/features/order/presentation/pages/cart_page.dart';
// import 'package:rateeat_mobile/src/features/order/presentation/pages/select_orders_page.dart';
// import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/bloc/restaurant_menu/restaurant_menu_bloc.dart';
// import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/bloc/restaurant_category/restaurant_category_bloc.dart';
// import 'package:rateeat_mobile/src/features/order/presentation/bloc/order_socket_status/order_socket_status_bloc.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// import '../../../search/unit_test/data/data/restaurants.dart';

// import 'select_order_page_test.mocks.dart';

// // Mock classes
// class MockCartCubit extends Mock implements CartCubit {}

// class MockTotalPriceBloc extends Mock implements TotalPriceBloc {}

// class MockRestaurantCategoryBloc extends Mock
//     implements RestaurantCategoryBloc {}

// class MockRestaurantMenuBloc extends Mock implements RestaurantMenuBloc {}

// class MockOrderSocketStatusBloc extends Mock implements OrderSocketStatusBloc {}

// @GenerateNiceMocks([
//   MockSpec<MockCartCubit>(),
//   MockSpec<MockRestaurantCategoryBloc>(),
//   MockSpec<MockRestaurantMenuBloc>(),
//   MockSpec<MockTotalPriceBloc>(),
//   MockSpec<MockOrderSocketStatusBloc>(),
// ])
// void main() {
//   late MockCartCubit mockCartCubit;
//   late MockTotalPriceBloc mockTotalPriceBloc;
//   late MockRestaurantCategoryBloc mockRestaurantCategoryBloc;
//   late MockRestaurantMenuBloc mockRestaurantMenuBloc;
//   late MockOrderSocketStatusBloc mockOrderSocketStatusBloc;
//   late Restaurant restaurant;

//   setUp(() {
//     // Provide a dummy value for RestaurantCategoryState
//     provideDummy<RestaurantCategoryState>(
//       RestaurantCategoriesLoading(),
//     );

//     // Initialize mock instances
//     mockCartCubit = MockMockCartCubit();
//     mockTotalPriceBloc = MockMockTotalPriceBloc();
//     mockRestaurantCategoryBloc = MockMockRestaurantCategoryBloc();
//     mockRestaurantMenuBloc = MockMockRestaurantMenuBloc();
//     mockOrderSocketStatusBloc = MockMockOrderSocketStatusBloc();
//     restaurant = dummyRestaurants[0];

//     // Setup initial mock states for bloc states
//     when(mockRestaurantMenuBloc.state).thenReturn(
//       RestaurantMenuCategoryItemsFetching(),
//     );
//     when(mockRestaurantCategoryBloc.state).thenReturn(
//       RestaurantCategoriesLoading(),
//     );
//     when(mockOrderSocketStatusBloc.state).thenReturn(
//       OrderSocketLoadingState(),
//     );

//     // Configure SizeConfig for tests
//     SizeConfig.blockSizeVertical = 8;
//     SizeConfig.screenWidth = 1000;
//     SizeConfig.screenHeight = 2000;
//     HttpOverrides.global = null;
//   });

//   Widget createWidgetUnderTest() {
//     return MultiBlocProvider(
//       providers: [
//         BlocProvider<CartCubit>.value(value: mockCartCubit),
//         BlocProvider<TotalPriceBloc>.value(value: mockTotalPriceBloc),
//         BlocProvider<RestaurantCategoryBloc>.value(
//             value: mockRestaurantCategoryBloc),
//         BlocProvider<RestaurantMenuBloc>.value(value: mockRestaurantMenuBloc),
//         BlocProvider<OrderSocketStatusBloc>.value(
//             value: mockOrderSocketStatusBloc),
//       ],
//       child: MaterialApp(
//         locale: const Locale('en', 'US'),
//         supportedLocales: AppLocalizations.supportedLocales,
//         localizationsDelegates: AppLocalizations.localizationsDelegates,
//         home: ResponsiveSizer(
//           builder: (context, orientation, screenType) {
//             return const SelectOrdersPage(
//               restaurant: Restaurant(
//                 id: '1',
//                 name: 'Test Restaurant',
//                 currencyCode: 'USD',
//               ),
//             );
//           },
//         ),
//       ),
//     );
//   }

//   group('SelectOrdersPage Tests', () {
//     testWidgets('should reset cart and connect to order socket on init',
//         (WidgetTester tester) async {
//       // Verify the methods are called in initState
//       verify(mockCartCubit.resetCart()).called(1);
//       verify(mockOrderSocketStatusBloc.add(OrderConnectSocket())).called(1);
//     });

//     testWidgets('displays loading indicator when categories are loading',
//         (WidgetTester tester) async {
//       when(mockRestaurantCategoryBloc.state).thenReturn(
//         RestaurantCategoriesLoading(),
//       );

//       await tester.runAsync(() async {
//         await tester.pumpWidget(createWidgetUnderTest());
//       });

//       for (var i = 0; i < 5; i++) {
//         await tester.pump(const Duration(seconds: 1));
//       }

//       // Assert: Verify the loading indicator is displayed
//       expect(find.byKey(const Key('restaurant_menu_categories_loading')),
//           findsOneWidget);
//     });

//     testWidgets('navigates to cart page when checkout button tapped',
//         (WidgetTester tester) async {
//       final item = Item(
//           itemId: '123',
//           itemName: 'Test Item',
//           price: 10.0,
//           numberOfReviews: 0);
//       when(mockCartCubit.state).thenReturn({item: 1});
//       when(mockCartCubit.stream).thenAnswer((_) => Stream.value({item: 1}));

//       await tester.runAsync(() async {
//         await tester.pumpWidget(createWidgetUnderTest());
//       });

//       for (var i = 0; i < 5; i++) {
//         await tester.pump(const Duration(seconds: 1));
//       }

//       // Tap the checkout button
//       await tester.tap(find.byType(InkWell));
//       for (var i = 0; i < 5; i++) {
//         await tester.pump(const Duration(seconds: 1));
//       }

//       // Verify navigation
//       expect(find.byType(CartPage), findsOneWidget);
//     });

//     testWidgets('shows error widget when menu loading fails',
//         (WidgetTester tester) async {
//       when(mockRestaurantMenuBloc.state).thenReturn(
//           const RestaurantMenuCategoryItemsFetchingFailed(
//               message: 'Failed to load'));

//       await tester.runAsync(() async {
//         await tester.pumpWidget(createWidgetUnderTest());
//       });

//       for (var i = 0; i < 5; i++) {
//         await tester.pump(const Duration(seconds: 1));
//       }

//       expect(find.text('Failed to load'), findsOneWidget);
//     });
//   });
// }
