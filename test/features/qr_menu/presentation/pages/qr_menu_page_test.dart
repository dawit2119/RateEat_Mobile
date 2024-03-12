// import 'dart:io';

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
// import 'package:rateeat_mobile/src/core/core.dart';
// import 'package:rateeat_mobile/src/features/features.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// import 'qr_menu_page_test.mocks.dart';

// class _EnableHttpOverrides extends HttpOverrides {}

// @GenerateNiceMocks([
//   MockSpec<QRMenuBloc>(),
//   MockSpec<ItemsCountPerPriceBloc>(),
// ])
// void main() {
//   group('QRMenuPage', () {
//     late MockQRMenuBloc mockQRMenuBloc;

//     setUp(() {
//       mockQRMenuBloc = MockQRMenuBloc();
//       HttpOverrides.global = _EnableHttpOverrides();
//     });

//     Widget createWidgetUnderTest() {
//       return MaterialApp(
//         supportedLocales: AppLocalizations.supportedLocales,
//         localizationsDelegates: AppLocalizations.localizationsDelegates,
//         home: BlocProvider<QRMenuBloc>.value(
//           value: mockQRMenuBloc,
//           child: ResponsiveSizer(builder: (context, orientation, type) {
//             SizeConfig().init(context);
//             return QRMenuPage(restaurantId: '123');
//           }), // Use a test restaurant ID
//         ),
//       );
//     }

//     testWidgets('displays loading indicator when loading',
//         (WidgetTester tester) async {
//       when(mockQRMenuBloc.state).thenReturn(QRMenuLoading(
//         minPrice: null,
//         maxPrice: null,
//         minRating: 0,
//         sortType: 'Desc',
//         sortBy: null,
//       ));

//       await tester.pumpWidget(createWidgetUnderTest());
//       expect(find.text("Loading menu"), findsOneWidget);
//     });

//     testWidgets('displays restaurant name and image when loaded',
//         (WidgetTester tester) async {
//       final mockMenu = QRMenuModel(
//         restaurantName: 'Test R',
//         restaurantImageUrl: 'https://example.com/image.jpg',
//         categories: [],
//         items: {},
//         restaurantId: '123',
//         totalCategories: 0,
//         backgroundColor: '',
//         itemBackgroundColor: '',

//       );

//       when(mockQRMenuBloc.state).thenReturn(
//         QRMenuLoaded(
//           menu: mockMenu,
//           page: 1,
//           sortType: 'Desc',
//           sortBy: null,
//           maxPrice: null,
//           minPrice: null,
//           minRating: 0,
//           hasReachedMax: false,
//         ),
//       );

//       await tester.pumpWidget(createWidgetUnderTest());
//       await tester.pump(Duration(seconds: 1));
//       expect(find.text(mockMenu.restaurantName), findsOneWidget);
//       expect(find.byType(CachedNetworkImage),
//           findsOneWidget); // Check for CachedNetworkImage
//     });

//     testWidgets('displays error message when failed',
//         (WidgetTester tester) async {
//       when(mockQRMenuBloc.state).thenReturn(
//         QRMenuFailed(
//           sortType: 'Desc',
//           sortBy: null,
//           maxPrice: null,
//           minPrice: null,
//           minRating: 0,
//         ),
//       );

//       await tester.pumpWidget(createWidgetUnderTest());
//       await tester.pumpAndSettle();
//       expect(find.text('Failed to get data from server'), findsOneWidget);
//     });

//     testWidgets('selecting a category updates the state',
//         (WidgetTester tester) async {
//       // Create a sample category
//       final category = QRCategoryModel(
//           name: 'Category 1',
//           imageUri:
//               "https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/car.svg",
//           id: 'category_id');
//       final mockMenu = QRMenuModel(
//         restaurantName: 'Test Restaurant',
//         restaurantImageUrl: '',
//         categories: [category],
//         items: {},
//         restaurantId: '123',
//         totalCategories: 0,
//         backgroundColor: '',
//         itemBackgroundColor: '',
//       );

//       when(mockQRMenuBloc.state).thenReturn(
//         QRMenuLoaded(
//           menu: mockMenu,
//           page: 1,
//           sortType: 'Desc',
//           sortBy: null,
//           maxPrice: null,
//           minPrice: null,
//           minRating: 0,
//           hasReachedMax: false,
//         ),
//       );

//       await tester.pumpWidget(createWidgetUnderTest());
//       await tester.pumpAndSettle();

//       // Simulate tapping on the category
//       await tester.tap(find.text('All').first);
//       await tester.pumpAndSettle();
//       expect(find.text('See All'), findsOneWidget);
//       await tester.tap(find.text('Category 1').first);
//       await tester.pumpAndSettle();
//       expect(find.text('See All'), findsNothing);
//       await tester.tap(find.text('All').first);
//       await tester.pumpAndSettle();
//       expect(find.text('See All'), findsOneWidget);
//     });

//     testWidgets('searching triggers search event', (WidgetTester tester) async {
//       final mockMenu = QRMenuModel(
//         restaurantName: 'Test Restaurant',
//         restaurantImageUrl: 'https://example.com/image.jpg',
//         categories: [],
//         items: {},
//         restaurantId: '123',
//         totalCategories: 0,
//         backgroundColor: '',
//         itemBackgroundColor: '',
//       );
//       when(mockQRMenuBloc.state).thenReturn(
//         QRMenuLoaded(
//           menu: mockMenu,
//           page: 1,
//           sortType: 'Desc',
//           sortBy: null,
//           maxPrice: null,
//           minPrice: null,
//           minRating: 0,
//           hasReachedMax: false,
//         ),
//       );

//       await tester.pumpWidget(createWidgetUnderTest());
//       await tester.pumpAndSettle();

//       // Find the search field and input text
//       final searchField = find.byType(TextFormField);
//       await tester.enterText(searchField, 'Pizza');
//       await tester.pumpAndSettle();

//       // Verify that the correct event is dispatched
//       verify(mockQRMenuBloc.add(GetQRMenu(
//         restaurantId: '123',
//         page: 1,
//         query: 'Pizza',
//         isFasting: null,
//         sortBy: null,
//         sortType: 'Desc',
//         maxPrice: null,
//         minPrice: null,
//         minRating: 0,
//       ))).called(1);
//     });

//     testWidgets('renders UI elements correctly', (WidgetTester tester) async {
//       final category = QRCategoryModel(
//           name: 'Category 1',
//           imageUri:
//               "https://dev.w3.org/SVG/tools/svgweb/samples/svg-files/car.svg",
//           id: 'category_id');
//       final mockMenu = QRMenuModel(
//         restaurantName: 'Test Restaurant',
//         restaurantImageUrl: 'https://example.com/image.jpg',
//         categories: [category],
//         items: {},
//         restaurantId: '123',
//         totalCategories: 0,
//         backgroundColor: '',
//         itemBackgroundColor: '',
//       );
//       when(mockQRMenuBloc.state).thenReturn(
//         QRMenuLoaded(
//           menu: mockMenu,
//           page: 1,
//           sortType: 'Desc',
//           sortBy: null,
//           maxPrice: null,
//           minPrice: null,
//           minRating: 0,
//           hasReachedMax: false,
//         ),
//       );

//       await tester.pumpWidget(createWidgetUnderTest());
//       await tester.pumpAndSettle();

//       // Check for specific UI elements
//       expect(find.byType(AppBar), findsOneWidget);
//       expect(find.byType(TextFormField), findsOneWidget);
//       expect(find.byType(IconButton),
//           findsWidgets); // More than one icon button for actions
//     });
//   });
// }
