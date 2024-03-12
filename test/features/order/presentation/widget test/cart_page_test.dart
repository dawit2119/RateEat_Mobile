// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
// import 'package:rateeat_mobile/src/core/constants/size_config.dart';
// import 'package:rateeat_mobile/src/features/map_section/domain/entities/restaurant.dart';
// import 'package:rateeat_mobile/src/features/order/order.dart';

// import 'package:rateeat_mobile/src/features/order/presentation/bloc/create_order/create_order_bloc.dart';
// import 'package:rateeat_mobile/src/features/order/presentation/bloc/total_price/total_price_bloc.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// import '../../../search/unit_test/data/data/restaurants.dart';

// import 'cart_page_test.mocks.dart';

// class MockTotalPriceBloc extends Mock implements TotalPriceBloc {}

// class MockCreateOrderBloc extends Mock implements CreateOrderBloc {}

// class MockCartCubit extends Mock implements CartCubit {}

// @GenerateNiceMocks([
//   MockSpec<MockTotalPriceBloc>(),
//   MockSpec<MockCreateOrderBloc>(),
//   MockSpec<MockCartCubit>(),
// ])
// void main() {
//   late MockTotalPriceBloc mockTotalPriceBloc;
//   late MockCreateOrderBloc mockCreateOrderBloc;
//   late MockCartCubit mockCartCubit;
//   late Restaurant restaurant;

//   setUp(() {
//     restaurant = dummyRestaurants[0];
//     provideDummy(const TotalPriceLoaded(
//         totalPrice: TotalPrice(totalPrice: 0, totalItems: 0)));
//     mockTotalPriceBloc = MockMockTotalPriceBloc();
//     mockCreateOrderBloc = MockMockCreateOrderBloc();
//     mockCartCubit = MockMockCartCubit();

//     const totalPrice = TotalPrice(
//       totalPrice: 0,
//       totalItems: 0,
//     );

//     when(mockTotalPriceBloc.state)
//         .thenReturn(const TotalPriceLoaded(totalPrice: totalPrice));
//     when(mockCreateOrderBloc.state).thenReturn(CreateOrderInitial());

//     SizeConfig.blockSizeVertical = 8;
//     SizeConfig.screenWidth = 1000;
//     SizeConfig.screenHeight = 2000;
//     HttpOverrides.global = null;
//   });

//   Widget createWidgetUnderTest() {
//     return MultiBlocProvider(
//         providers: [
//           BlocProvider<TotalPriceBloc>.value(
//             value: mockTotalPriceBloc,
//           ),
//           BlocProvider<CreateOrderBloc>.value(
//             value: mockCreateOrderBloc,
//           ),
//           BlocProvider<CartCubit>.value(
//             value: mockCartCubit,
//           )
//         ],
//         child: MaterialApp(
//           locale: const Locale('en', 'US'),
//           supportedLocales: AppLocalizations.supportedLocales,
//           localizationsDelegates: AppLocalizations.localizationsDelegates,
//           home: ResponsiveSizer(builder: (context, orientation, screenType) {
//             return CartPage(restaurant: restaurant);
//           }),
//         ));
//   }

//   group('test cart page', () {
//     testWidgets('check test cart page loaded', (WidgetTester tester) async {
//       when(mockTotalPriceBloc.state).thenReturn(TotalPriceLoading());

//       await tester.runAsync(() async {
//         await tester.pumpWidget(createWidgetUnderTest());
//       });

//       for (var i = 0; i < 5; i++) {
//         await tester.pump(const Duration(seconds: 1));
//       }

//       expect(find.byKey(const Key('cart_loading')), findsOneWidget);
//     });

//     testWidgets('test the cart page TotalPriceLoaded',
//         (WidgetTester tester) async {
//       when(mockTotalPriceBloc.state).thenReturn(const TotalPriceLoaded(
//           totalPrice: TotalPrice(totalPrice: 0, totalItems: 0)));

//       await tester.runAsync(() async {
//         await tester.pumpWidget(createWidgetUnderTest());
//       });

//       for (var i = 0; i < 5; i++) {
//         await tester.pump(const Duration(seconds: 1));
//       }

//       expect(find.byKey(const Key('total_price_loaded')), findsOneWidget);
//     });

//     testWidgets('test cart page total price failed',
//         (WidgetTester tester) async {
//       when(mockTotalPriceBloc.state)
//           .thenReturn(const TotalPriceFailed(errorMessage: 'error'));

//       await tester.runAsync(() async {
//         await tester.pumpWidget(createWidgetUnderTest());
//       });

//       for (var i = 0; i < 5; i++) {
//         await tester.pump(const Duration(seconds: 1));
//       }

//       expect(find.byKey(const Key('total_price_failed')), findsOneWidget);
//     });
//   });
// }
