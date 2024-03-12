// import 'dart:io';

// import 'package:flutter/material.dart';
// import 'package:flutter_bloc/flutter_bloc.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:get_it/get_it.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:rateeat_mobile/src/core/constants/size_config.dart';
// import 'package:rateeat_mobile/src/features/map_section/domain/entities/entities.dart';
// import 'package:rateeat_mobile/src/features/order/presentation/bloc/order_socket_status/order_socket_status_bloc.dart';
// import 'package:rateeat_mobile/src/features/order/presentation/bloc/order_status/order_status_bloc.dart';
// import 'package:rateeat_mobile/src/features/order/presentation/pages/order_status_page.dart';
// import 'package:responsive_sizer/responsive_sizer.dart';

// import '../../../search/unit_test/data/data/restaurants.dart';
// import 'order_status_page_test.mocks.dart';

// class MockOrderStatusBloc extends Mock implements OrderStatusBloc {}

// class MockOrderSocketStatusBloc extends Mock implements OrderSocketStatusBloc {}

// @GenerateNiceMocks([
//   MockSpec<MockOrderStatusBloc>(),
//   MockSpec<MockOrderSocketStatusBloc>(),
// ])
// void main() {
//   late MockOrderStatusBloc mockOrderStatusBloc;
//   late MockOrderSocketStatusBloc mockOrderSocketStatusBloc;
//   late Restaurant restaurant;
//   final sl = GetIt.instance;

//   setUp(() {
//     sl.registerFactory<OrderSocketStatusBloc>(
//         () => MockOrderSocketStatusBloc());
//     sl.registerFactory<OrderStatusBloc>(() => MockOrderStatusBloc());
//     mockOrderStatusBloc = MockMockOrderStatusBloc();
//     mockOrderSocketStatusBloc = MockMockOrderSocketStatusBloc();

//     restaurant = dummyRestaurants[0];

//     when(mockOrderStatusBloc.state).thenReturn(OrderStatusUpdatedInProgress());
//     when(mockOrderSocketStatusBloc.state).thenReturn(OrderSocketLoadingState());

//     provideDummy<OrderStatusState>(OrderStatusUpdated());
//     SizeConfig.blockSizeVertical = 8;
//     SizeConfig.screenHeight = 2000;
//     SizeConfig.screenWidth = 1000;
//     HttpOverrides.global = null;
//   });

//   Widget ordersStatusPage() {
//     return MaterialApp(
//       home: MultiBlocProvider(
//         providers: [
//           BlocProvider<OrderSocketStatusBloc>(
//               create: (_) => mockOrderSocketStatusBloc),
//           BlocProvider<OrderStatusBloc>(create: (_) => mockOrderStatusBloc),
//         ],
//         child: ResponsiveSizer(
//           builder: (context, orientation, screenType) {
//             return OrderStatusPage(orderId: '123', restaurant: restaurant);
//           },
//         ),
//       ),
//     );
//   }

//   group('Order Status Page test', () {
//     testWidgets('displays loading animation while connecting',
//         (WidgetTester tester) async {
//       // Set the mock state for loading
//       when(mockOrderSocketStatusBloc.state)
//           .thenReturn(OrderSocketLoadingState());

//       // Build the widget.await tester.pumpAndSettle(const Duration(seconds: 1));
//       await tester.runAsync(() async {
//         await tester.pumpWidget(ordersStatusPage());
//       });

//       // Trigger a state change to simulate loading
//       mockOrderSocketStatusBloc.add(OrderConnectSocket());

//       // Mock the subsequent state change to simulate the end of loading
//       when(mockOrderSocketStatusBloc.state)
//           .thenReturn(OrderSocketConnectedState());

//       // Allow the widget to rebuild after state change
//       for (int i = 0; i < 5; i++) {
//         // because pumpAndSettle doesn't work with riverpod
//         await tester.pump(const Duration(seconds: 1));
//       }

//       // Print the current widget tree to the console for debugging
//       debugDumpApp(); // This will print the widget tree
//       // expect(find.byWidget(CircularProgressIndicator()), findsOneWidget);
//       // Verify the loading widget is displayed.
//       expect(
//           find.byKey(const Key('socket_connection_loading')), findsOneWidget);
//       expect(find.text('Connecting ...'), findsOneWidget);
//     });

//     testWidgets('displays loading indicator for order status when in progress',
//         (WidgetTester tester) async {
//       // Arrange
//       when(mockOrderSocketStatusBloc.state)
//           .thenReturn(OrderSocketConnectedState());
//       when(mockOrderStatusBloc.state)
//           .thenReturn(OrderStatusUpdatedInProgress());

//       // Act
//       await tester.runAsync(() async {
//         await tester.pumpWidget(ordersStatusPage());
//       });

//       for (int i = 0; i < 5; i++) {
//         // because pumpAndSettle doesn't work with riverpod
//         await tester.pump(const Duration(seconds: 1));
//       }

//       // Assert
//       expect(find.byKey(const Key('order_status_loading')), findsOneWidget);
//       expect(find.text("loading order status"), findsOneWidget);
//     });

// //     testWidgets('displays error message when order status update fails', (WidgetTester tester) async {
// //   // Arrange
// //   when(mockOrderSocketStatusBloc.state).thenReturn(OrderSocketConnectedState());
// //   when(mockOrderStatusBloc.state).thenReturn(OrderStatusUpdateFailed(errorMessage: 'could not get order status'));

// //   // Act
// //   await tester.runAsync(() async {
// //     await tester.pumpWidget(ordersStatusPage());
// //   });

// //   // Wait for the UI to settle since we're using Riverpod.
// //   for (int i = 0; i < 5; i++) {
// //     await tester.pump(Duration(seconds: 1));
// //   }

// //   // Assert
// //   expect(find.byWidget(ErrorAndInfoDisplayWidget), findsOneWidget);
// //   // expect(find.text("Error loading order status"), findsOneWidget); // Verify the title in the Error widget
// //   // expect(find.text("could not get order status"), findsOneWidget); // Verify the error message in the Error widget
// // });

//     testWidgets('displays rejected order message', (WidgetTester tester) async {
//       // Arrange
//       when(mockOrderSocketStatusBloc.state)
//           .thenReturn(OrderSocketConnectedState());
//       when(mockOrderStatusBloc.state).thenReturn(OrderRejected());

//       // Act
//       await tester.runAsync(() async {
//         await tester.pumpWidget(ordersStatusPage());
//       });

//       for (int i = 0; i < 5; i++) {
//         // because pumpAndSettle doesn't work with riverpod
//         await tester.pump(const Duration(seconds: 1));
//       }
//       // Assert
//       expect(find.text("Order rejected"), findsOneWidget);
//     });
//   });

//   tearDown(() {
//     mockOrderStatusBloc.close();
//     mockOrderSocketStatusBloc.close();
//   });
// }
