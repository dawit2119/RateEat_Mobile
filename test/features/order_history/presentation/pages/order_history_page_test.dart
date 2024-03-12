import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';

import 'order_history_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<OrderHistoryBloc>(),
  MockSpec<OrderHistoryStatusBloc>(),
  MockSpec<AuthenticationLocalSource>()
])
void main() {
  late MockOrderHistoryBloc mockOrderHistoryBloc;
  late MockOrderHistoryStatusBloc mockOrderHistoryStatusBloc;
  late MockAuthenticationLocalSource mockAuthenticationLocalSource;

  setUp(() {
    mockOrderHistoryBloc = MockOrderHistoryBloc();
    mockOrderHistoryStatusBloc = MockOrderHistoryStatusBloc();
    mockAuthenticationLocalSource = MockAuthenticationLocalSource();

    // Register mock authentication source
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => mockAuthenticationLocalSource);

    // Mock user authentication credential
    final mockUser = LocalUserModel(
      id: "123",
      telegramId: "tg_456",
      facebookId: "fb_789",
      userName: "JohnDoe",
      firstName: "John",
      lastName: "Doe",
      dateOfBirth: "1990-01-01",
      email: "johndoe@example.com",
      gender: "Male",
      roleId: "admin",
      phoneNumber: "+1234567890",
      image: "https://example.com/profile.jpg",
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      token: "some_token",
      incentive: null, // or provide an Incentive object
      fcmToken: "some_fcm_token",
      verified: 1,
    );

    when(() => mockAuthenticationLocalSource.getUserCredential())
        .thenReturn(mockUser);
  });

  Widget createTestWidget() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<OrderHistoryBloc>.value(value: mockOrderHistoryBloc),
        BlocProvider<OrderHistoryStatusBloc>.value(
            value: mockOrderHistoryStatusBloc),
      ],
      child: const MaterialApp(
        home: OrderHistoryPage(),
      ),
    );
  }

  testWidgets('renders OrderHistoryPage and displays loading state',
      (WidgetTester tester) async {
    // Ensure state is mocked before rendering the widget
    when(() => mockOrderHistoryBloc.state).thenReturn(OrderHistoryLoading());

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.text("Loading orders"), findsOneWidget);
  });

  testWidgets('displays error state when fetching fails',
      (WidgetTester tester) async {
    when(() => mockOrderHistoryBloc.state)
        .thenReturn(OrderHistoryError(errorMessage: "Network Error"));

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.text("Fetching orders failed"), findsOneWidget);
    expect(find.text("Network Error"), findsOneWidget);
  });

  testWidgets('displays order history list when loaded',
      (WidgetTester tester) async {
    final orders = [
      OrderHistoryModel(
        id: "1",
        orderStatus: "Pending",
        totalPrice: 20,
        orderItems: [],
        orderMessage: 'Order Message',
        orderType: "Delivery",
      )
    ];
    when(() => mockOrderHistoryBloc.state).thenReturn(
        OrderHistoryLoaded(orders: orders, page: 1, hasReachedMax: false));

    await tester.pumpWidget(createTestWidget());
    await tester.pump();

    expect(find.byType(OrderHistoryCard), findsOneWidget);
  });
}
