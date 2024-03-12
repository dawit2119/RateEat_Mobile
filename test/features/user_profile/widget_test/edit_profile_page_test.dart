import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/incentive_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/username_availability/username_availability_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/edit_profile.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import './edit_profile_page_test.mocks.dart';
import 'dart:io';

class MockEditProfileBloc extends Mock implements EditProfileBloc {}

class MockAuthenticationBloc extends Mock implements AuthenticationBloc {}

class MockUsernameAvailabilityBloc extends Mock
    implements UsernameAvailabilityBloc {}

@GenerateNiceMocks([
  MockSpec<MockEditProfileBloc>(),
  MockSpec<MockAuthenticationBloc>(),
  MockSpec<MockUsernameAvailabilityBloc>(),
])
void main() {
  group('EditProfilePage Widget Test', () {
    late MockEditProfileBloc mockEditProfileBloc;
    late MockAuthenticationBloc mockAuthenticationBloc;
    late MockUsernameAvailabilityBloc mockUsernameAvailabilityBloc;
    late UserModel testUserModel;
    setUp(() {
      dpLocator.reset();
      mockEditProfileBloc = MockMockEditProfileBloc();
      mockAuthenticationBloc = MockMockAuthenticationBloc();
      mockUsernameAvailabilityBloc = MockMockUsernameAvailabilityBloc();

      testUserModel = UserModel(
          id: "1",
          telegramId: "exampleTelegramId123",
          facebookId: "exampleFacebookId123",
          userName: "john_doe",
          firstName: "John",
          lastName: "Doe",
          dateOfBirth: "1985-07-15",
          email: "john.doe@example.com",
          gender: "Male",
          roleId: "admin",
          phoneNumber: "+1234567890",
          image: "https://example.com/path/to/image.jpg",
          createdAt: DateTime.now()
              .subtract(const Duration(days: 365)), // One year ago
          updatedAt: DateTime.now(),
          token: "aVerySecureToken123456",
          incentive: const IncentiveModel(
            pendingIncentive: 100,
            totalIncentivized: 200,
            id: "inc001",
          ),
          verified: 1);

      dpLocator.registerFactory<EditProfileBloc>(
        () => mockEditProfileBloc,
      );
      dpLocator.registerFactory<AuthenticationBloc>(
        () => mockAuthenticationBloc,
      );
      dpLocator.registerFactory<UsernameAvailabilityBloc>(
        () => mockUsernameAvailabilityBloc,
      );

      SizeConfig.blockSizeVertical = 8;
      SizeConfig.screenWidth = 1000;
      SizeConfig.screenHeight = 2000;
      HttpOverrides.global = null;
    });

    Widget makeTestableWidget(Widget body) {
      return MultiBlocProvider(
        providers: [
          BlocProvider<EditProfileBloc>(
            create: (_) => dpLocator<EditProfileBloc>(),
          ),
          BlocProvider<AuthenticationBloc>(
            create: (_) => dpLocator<AuthenticationBloc>(),
          ),
          BlocProvider<UsernameAvailabilityBloc>(
            create: (_) => dpLocator<UsernameAvailabilityBloc>(),
          ),
        ],
        child: MaterialApp(
          locale: const Locale('en', 'US'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ResponsiveSizer(
            builder: (context, orientation, screenType) {
              return body;
            },
          ),
        ),
      );
    }

    testWidgets('Should display loading animation when profile is updating',
        (WidgetTester tester) async {
      when(mockEditProfileBloc.state).thenReturn(EditProfileLoading());
      when(mockUsernameAvailabilityBloc.state).thenReturn(
        const UsernameAvailabilitySuccess(status: "Available"),
      );
      await tester.pumpWidget(
          makeTestableWidget(EditProfilePage(userModel: testUserModel)));
      expect(
        find.byType(SingleChildScrollView),
        findsOneWidget,
      );
    });

    testWidgets('Should display user data in form fields',
        (WidgetTester tester) async {
      when(mockUsernameAvailabilityBloc.state).thenReturn(
        const UsernameAvailabilitySuccess(status: "Available"),
      );
      await tester.pumpWidget(
          makeTestableWidget(EditProfilePage(userModel: testUserModel)));

      expect(find.text(testUserModel.userName!), findsWidgets);
      expect(find.text(testUserModel.email!), findsWidgets);
    });

    testWidgets('Should validate form fields correctly',
        (WidgetTester tester) async {
      when(mockUsernameAvailabilityBloc.state).thenReturn(
        const UsernameAvailabilitySuccess(status: "Available"),
      );
      await tester.pumpWidget(
          makeTestableWidget(EditProfilePage(userModel: testUserModel)));

      final Finder userNameField = find.widgetWithText(
          TextFormField, testUserModel.userName ?? 'user name');
      await tester.enterText(userNameField, '');
      await tester.pump();

      expect(
          find.text(AppLocalizations.of(tester.element(userNameField))!
              .userNameErrorText),
          findsOneWidget);
    });

    testWidgets('Should validate invalid email input',
        (WidgetTester tester) async {
      when(mockUsernameAvailabilityBloc.state).thenReturn(
        const UsernameAvailabilitySuccess(status: "Available"),
      );
      final emptyEmailUser = testUserModel.copyWith(email: "");
      await tester.pumpWidget(
        makeTestableWidget(
          EditProfilePage(
            userModel: emptyEmailUser,
          ),
        ),
      );

      final Finder emailField = find.byKey(
        const Key("Edit Profile Email Field"),
      );
      await tester.enterText(emailField, "Invalid email");
      await tester.pump();

      expect(
          find.text(
            AppLocalizations.of(tester.element(emailField))!.emailError,
          ),
          findsOneWidget);
    });
  });
}
