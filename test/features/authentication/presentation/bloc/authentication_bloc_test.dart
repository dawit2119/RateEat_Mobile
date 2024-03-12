import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/local_history/local_search_history_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';

import 'authentication_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SignInWithGoogleUseCase>(),
  MockSpec<SignOutWithGoogleUseCase>(),
  MockSpec<SignInWithFacebookUseCase>(),
  MockSpec<SignOutWithFacebookUseCase>(),
  MockSpec<SignInWithAppleUsecase>(),
  MockSpec<LoginGoogleUseCase>(),
  MockSpec<LoginFacebookUseCase>(),
  MockSpec<SendPhoneOtpUseCase>(),
  MockSpec<SendEditPhoneOtpUseCase>(),
  MockSpec<SendEditEmailOtpUseCase>(),
  MockSpec<VerifyOtpUseCase>(),
  MockSpec<SignupUseCase>(),
  MockSpec<ResendOtpUseCase>(),
  MockSpec<LogoutUseCase>(),
  MockSpec<DeleteAccountUseCase>(),
  MockSpec<LocalSearchHistoryBloc>(),
  MockSpec<SendEmailOtpUseCase>(),
  MockSpec<LogoutWithAppleUsecase>(),
  MockSpec<VerifyEmailOtpUseCase>(),
  MockSpec<ResendEmailOtpUseCase>(),
])
void main() {
  late AuthenticationBloc authenticationBloc;
  late SignInWithAppleUsecase signInWithAppleUsecase;
  late LogoutWithAppleUsecase logoutWithAppleUsecase;
  late MockSignInWithGoogleUseCase mockSignInWithGoogleUseCase;
  late MockSignOutWithGoogleUseCase mockSignOutWithGoogleUseCase;
  late MockSignInWithFacebookUseCase mockSignInWithFacebookUseCase;
  late MockSignOutWithFacebookUseCase mockSignOutWithFacebookUseCase;
  late MockLoginGoogleUseCase mockLoginGoogleUseCase;
  late MockLoginFacebookUseCase mockLoginFacebookUseCase;
  late MockSendPhoneOtpUseCase mockSendPhoneOtpUseCase;
  late MockSendEditPhoneOtpUseCase mockSendEditPhoneOtpUseCase;
  late MockSendEditEmailOtpUseCase mockSendEditEmailOtpUseCase;
  late MockVerifyOtpUseCase mockVerifyOtpUseCase;
  late MockSignupUseCase mockSignupUseCase;
  late MockResendOtpUseCase mockResendOtpUseCase;
  late MockLogoutUseCase mockLogoutUseCase;
  late MockDeleteAccountUseCase mockDeleteAccountUseCase;
  late MockLocalSearchHistoryBloc mockLocalSearchHistoryBloc;
  late SendEmailOtpUseCase sendEmailOtpUseCase;
  late VerifyEmailOtpUseCase verifyEmailOtpUseCase;
  late ResendEmailOtpUseCase resendEmailOtpUseCase;
  setUp(() {
    mockSignInWithGoogleUseCase = MockSignInWithGoogleUseCase();
    signInWithAppleUsecase = MockSignInWithAppleUsecase();
    logoutWithAppleUsecase = MockLogoutWithAppleUsecase();
    sendEmailOtpUseCase = MockSendEmailOtpUseCase();
    verifyEmailOtpUseCase = MockVerifyEmailOtpUseCase();
    resendEmailOtpUseCase = MockResendEmailOtpUseCase();
    mockSignOutWithGoogleUseCase = MockSignOutWithGoogleUseCase();
    mockSignInWithFacebookUseCase = MockSignInWithFacebookUseCase();
    mockSignOutWithFacebookUseCase = MockSignOutWithFacebookUseCase();
    mockLoginGoogleUseCase = MockLoginGoogleUseCase();
    mockLoginFacebookUseCase = MockLoginFacebookUseCase();
    mockSendPhoneOtpUseCase = MockSendPhoneOtpUseCase();
    mockSendEditPhoneOtpUseCase = MockSendEditPhoneOtpUseCase();
    mockSendEditEmailOtpUseCase = MockSendEditEmailOtpUseCase();
    mockVerifyOtpUseCase = MockVerifyOtpUseCase();
    mockSignupUseCase = MockSignupUseCase();
    mockResendOtpUseCase = MockResendOtpUseCase();
    mockLogoutUseCase = MockLogoutUseCase();
    mockDeleteAccountUseCase = MockDeleteAccountUseCase();
    mockLocalSearchHistoryBloc = MockLocalSearchHistoryBloc();

    authenticationBloc = AuthenticationBloc(
      signInWithAppleUseCase: signInWithAppleUsecase,
      signOutWithAppleUseCase: logoutWithAppleUsecase,
      sendEmailOtpUseCase: sendEmailOtpUseCase,
      verifyEmailOtpUseCase: verifyEmailOtpUseCase,
      resendEmailOtpUseCase: resendEmailOtpUseCase,
      signInWithGoogleUseCase: mockSignInWithGoogleUseCase,
      signOutWithGoogleUseCase: mockSignOutWithGoogleUseCase,
      signInWithFacebookUseCase: mockSignInWithFacebookUseCase,
      signOutWithFacebookUseCase: mockSignOutWithFacebookUseCase,
      loginGoogleUseCase: mockLoginGoogleUseCase,
      loginFacebookUseCase: mockLoginFacebookUseCase,
      sendPhoneOtpUseCase: mockSendPhoneOtpUseCase,
      sendEditPhoneOtpUseCase: mockSendEditPhoneOtpUseCase,
      sendEditEmailOtpUseCase: mockSendEditEmailOtpUseCase,
      verifyOtpUseCase: mockVerifyOtpUseCase,
      signUpUseCase: mockSignupUseCase,
      resendOtpUseCase: mockResendOtpUseCase,
      logoutUseCase: mockLogoutUseCase,
      deleteAccountUseCase: mockDeleteAccountUseCase,
      localSearchHistoryBloc: mockLocalSearchHistoryBloc,
    );
  });

  const phoneNumber = "=251989373788";
  const code = "3800";

  const testOtp = VerifyOtpParams(code: code, phoneNumber: phoneNumber);
  const user = LoginEmailParams(
    accessToken: "token",
    email: "john@example",
    firstName: "John",
    lastName: "Doe",
  );
  final testResponse = UserLoginResponse(
    user: UserModel(
      id: "1",
      telegramId: "1",
      facebookId: "1",
      userName: "John",
      firstName: 'John',
      lastName: 'Doe',
      dateOfBirth: '2013-04-20 12:00:00',
      email: 'john@example',
      token: "token",
    ),
    statusCode: 200,
  );

  group('Authentication Bloc', () {
    test('initial state should be AuthenticationInitial', () {
      // assert
      expect(authenticationBloc.state, AuthenticationInitial());
    });
    group('login with google', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ SignInWithGoogleState(status: AuthStatus.loading),  SignInWithGoogleState(status: AuthStatus.loaded)] when SignInWithGoogleEvent is added.',
        build: () {
          when(
            mockSignInWithGoogleUseCase(any),
          ).thenAnswer((_) async => Right(testResponse.user));
          when(
            mockLoginGoogleUseCase(user),
          ).thenAnswer((_) async => Right(testResponse));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(SignInWithGoogleEvent()),
        expect: () => const <AuthenticationState>[
          SignInWithGoogleState(status: AuthStatus.loading),
          SignInWithGoogleState(status: AuthStatus.loaded),
        ],
      );

      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ SignInWithGoogleState(status: AuthStatus.loading),  SignInWithGoogleState(status: AuthStatus.error)] when SignInWithGoogleEvent is added.',
        build: () {
          when(mockSignInWithGoogleUseCase(any)).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'server error')));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(SignInWithGoogleEvent()),
        expect: () => [
          const SignInWithGoogleState(status: AuthStatus.loading),
          const SignInWithGoogleState(
            status: AuthStatus.error,
          ),
        ],
      );
    });

    group('login with facebook', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ SignInWithFacebookState(status: AuthStatus.loading),  SignInWithFacebookState(status: AuthStatus.loaded)] when SignInWithFacebookEvent is added.',
        build: () {
          when(
            mockSignInWithFacebookUseCase(any),
          ).thenAnswer((_) async => Right(testResponse.user));
          when(
            mockLoginFacebookUseCase(user),
          ).thenAnswer((_) async => Right(testResponse));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(SignInWithFacebookEvent()),
        expect: () => const <AuthenticationState>[
          SignInWithFacebookState(status: AuthStatus.loading),
          SignInWithFacebookState(status: AuthStatus.loaded),
        ],
      );
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ SignInWithFacebookState(status: AuthStatus.loading),  SignInWithFacebookState(status: AuthStatus.error)] when SignInWithFacebookEvent is added.',
        build: () {
          when(
            mockSignInWithFacebookUseCase(any),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'server error')));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(SignInWithFacebookEvent()),
        expect: () => const <AuthenticationState>[
          SignInWithFacebookState(status: AuthStatus.loading),
          SignInWithFacebookState(status: AuthStatus.error),
        ],
      );
    });

    group('sign up', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ SignUpState(status: AuthStatus.loading),  SignUpState(status: AuthStatus.loaded)] when SignUpEvent is added.',
        build: () {
          when(
            mockSignupUseCase(
              SignUpParams(
                user: testResponse.user,
              ),
            ),
          ).thenAnswer((_) async => Right(testResponse.user));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(SignUpEvent(user: testResponse.user)),
        expect: () => const <AuthenticationState>[
          SignUpState(status: AuthStatus.loading),
          SignUpState(status: AuthStatus.loaded),
        ],
      );
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ SignUpState(status: AuthStatus.loading),  SignUpState(status: AuthStatus.error)] when SignUpEvent is added.',
        build: () {
          when(
            mockSignupUseCase(
              SignUpParams(
                user: testResponse.user,
              ),
            ),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'server error')));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(SignUpEvent(user: testResponse.user)),
        expect: () => const <AuthenticationState>[
          SignUpState(status: AuthStatus.loading),
          SignUpState(status: AuthStatus.error),
        ],
      );
    });

    group('send otp to phone', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ SendPhoneOtpState(status: AuthStatus.loading),  SendPhoneOtpState(status: AuthStatus.loaded)] when SendPhoneOtpEvent is added.',
        build: () {
          when(
            mockSendPhoneOtpUseCase(
              const SendPhoneOtpParams(phoneNumber: phoneNumber),
            ),
          ).thenAnswer((_) async => const Right(unit));
          return authenticationBloc;
        },
        act: (bloc) =>
            bloc.add(const SendPhoneOtpEvent(phoneNumber: phoneNumber)),
        expect: () => const <AuthenticationState>[
          SendPhoneOtpState(status: AuthStatus.loading),
          SendPhoneOtpState(status: AuthStatus.loaded),
        ],
      );
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ SendPhoneOtpState(status: AuthStatus.loading),  SendPhoneOtpState(status: AuthStatus.error)] when SendPhoneOtpEvent is added.',
        build: () {
          when(
            mockSendPhoneOtpUseCase(
              const SendPhoneOtpParams(phoneNumber: phoneNumber),
            ),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'server error')));
          return authenticationBloc;
        },
        act: (bloc) =>
            bloc.add(const SendPhoneOtpEvent(phoneNumber: phoneNumber)),
        expect: () => const <AuthenticationState>[
          SendPhoneOtpState(status: AuthStatus.loading),
          SendPhoneOtpState(status: AuthStatus.error),
        ],
      );
    });

    group('send otp to phone when editing profile', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ SendEditPhoneOtpState(status: AuthStatus.loading),  SendEditPhoneOtpState(status: AuthStatus.loaded)] when SendEditPhoneOtpEvent is added.',
        build: () {
          when(
            mockSendEditPhoneOtpUseCase(
              const SendEditPhoneOtpParams(phoneNumber: phoneNumber),
            ),
          ).thenAnswer((_) async => const Right(unit));
          return authenticationBloc;
        },
        act: (bloc) =>
            bloc.add(const SendEditPhoneOtpEvent(phoneNumber: phoneNumber)),
        expect: () => const <AuthenticationState>[
          SendEditPhoneOtpState(status: AuthStatus.loading),
          SendEditPhoneOtpState(status: AuthStatus.loaded),
        ],
      );
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ SendEditPhoneOtpState(status: AuthStatus.loading),  SendEditPhoneOtpState(status: AuthStatus.error)] when SendEditPhoneOtpEvent is added.',
        build: () {
          when(
            mockSendEditPhoneOtpUseCase(
              const SendEditPhoneOtpParams(phoneNumber: phoneNumber),
            ),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'server error')));
          return authenticationBloc;
        },
        act: (bloc) =>
            bloc.add(const SendEditPhoneOtpEvent(phoneNumber: phoneNumber)),
        expect: () => const <AuthenticationState>[
          SendEditPhoneOtpState(status: AuthStatus.loading),
          SendEditPhoneOtpState(status: AuthStatus.error),
        ],
      );
    });

    group('send otp to Email when editing profile', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ SendEditEmailOtpState(status: AuthStatus.loading),  SendEditEmailOtpState(status: AuthStatus.loaded)] when SendEditEmailOtpEvent is added.',
        build: () {
          when(
            mockSendEditEmailOtpUseCase(
              SendEditEmailOtpParams(email: user.email!),
            ),
          ).thenAnswer((_) async => const Right(unit));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(SendEditEmailOtpEvent(email: user.email!)),
        expect: () => const <AuthenticationState>[
          SendEditEmailOtpState(status: AuthStatus.loading),
          SendEditEmailOtpState(status: AuthStatus.loaded),
        ],
      );
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ SendEditEmailOtpState(status: AuthStatus.loading),  SendEditEmailOtpState(status: AuthStatus.error)] when SendEditEmailOtpEvent is added.',
        build: () {
          when(
            mockSendEditEmailOtpUseCase(
              SendEditEmailOtpParams(email: user.email!),
            ),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'server error')));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(SendEditEmailOtpEvent(email: user.email!)),
        expect: () => const <AuthenticationState>[
          SendEditEmailOtpState(status: AuthStatus.loading),
          SendEditEmailOtpState(status: AuthStatus.error),
        ],
      );
    });

    group('Verify phone', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ VerifyOtpState(status: AuthStatus.loading),  VerifyOtpState(status: AuthStatus.loaded)] when VerifyOtpEvent is added.',
        build: () {
          when(
            mockVerifyOtpUseCase(testOtp),
          ).thenAnswer((_) async => Right(testResponse));
          return authenticationBloc;
        },
        act: (bloc) => bloc
            .add(const VerifyOtpEvent(phoneNumber: phoneNumber, code: code)),
        expect: () => const <AuthenticationState>[
          VerifyOtpState(status: AuthStatus.loading),
          VerifyOtpState(status: AuthStatus.loaded),
        ],
      );
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [SignInWithGoogleState(status: AuthStatus.loading),  SignInWithGoogleState(status: AuthStatus.error)] when VerifyOtpEvent is added.',
        build: () {
          when(
            mockVerifyOtpUseCase(testOtp),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'server error')));
          return authenticationBloc;
        },
        act: (bloc) => bloc
            .add(const VerifyOtpEvent(phoneNumber: phoneNumber, code: code)),
        expect: () => const <AuthenticationState>[
          VerifyOtpState(status: AuthStatus.loading),
          VerifyOtpState(status: AuthStatus.error),
        ],
      );
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ SignInWithGoogleState(status: AuthStatus.loading),  SignInWithGoogleState(status: AuthStatus.error)] when VerifyOtpEvent is added.',
        build: () {
          when(
            mockVerifyOtpUseCase(testOtp),
          ).thenAnswer((_) async =>
              Left(UnauthorizedRequestFailure(errorMessage: 'server error')));
          return authenticationBloc;
        },
        act: (bloc) => bloc
            .add(const VerifyOtpEvent(phoneNumber: phoneNumber, code: code)),
        expect: () => const <AuthenticationState>[
          VerifyOtpState(status: AuthStatus.loading),
          VerifyOtpState(status: AuthStatus.error),
        ],
      );
    });

    group('resend otp', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ ResendOtpState(status: AuthStatus.loading),  ResendOtpState(status: AuthStatus.loaded)] when ResendOtpEvent is added.',
        build: () {
          when(
            mockResendOtpUseCase(
              const ResendOtpParams(
                phoneNumber: phoneNumber,
              ),
            ),
          ).thenAnswer((_) async => const Right(unit));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(const ResendOtpEvent(phoneNumber: phoneNumber)),
        expect: () => const <AuthenticationState>[
          ResendOtpState(status: AuthStatus.loading),
          ResendOtpState(status: AuthStatus.loaded),
        ],
      );
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ ResendOtpState(status: AuthStatus.loading),  ResendOtpState(status: AuthStatus.error)] when ResendOtpEvent is added.',
        build: () {
          when(
            mockResendOtpUseCase(
              const ResendOtpParams(
                phoneNumber: phoneNumber,
              ),
            ),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'server error')));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(const ResendOtpEvent(phoneNumber: phoneNumber)),
        expect: () => const <AuthenticationState>[
          ResendOtpState(status: AuthStatus.loading),
          ResendOtpState(status: AuthStatus.error),
        ],
      );
    });

    group('logout', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ LogoutState(status: AuthStatus.loading),  LogoutState(status: AuthStatus.loaded)] when LogoutEvent is added.',
        build: () {
          when(
            mockLogoutUseCase(NoParams()),
          ).thenAnswer((_) async => const Right(unit));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(LogoutEvent()),
        expect: () => const <AuthenticationState>[
          LogoutState(status: AuthStatus.loading),
          LogoutState(status: AuthStatus.loaded),
        ],
      );
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ LogoutState(status: AuthStatus.loading),  LogoutState(status: AuthStatus.error)] when LogoutEvent is added.',
        build: () {
          when(
            mockLogoutUseCase(NoParams()),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'server error')));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(LogoutEvent()),
        expect: () => const <AuthenticationState>[
          LogoutState(status: AuthStatus.loading),
          LogoutState(status: AuthStatus.error),
        ],
      );
    });

    group('delete account', () {
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ LogoutState(status: AuthStatus.loading),  LogoutState(status: AuthStatus.loaded)] when DeleteAccountEvent is added.',
        build: () {
          when(
            mockDeleteAccountUseCase(NoParams()),
          ).thenAnswer((_) async => const Right(unit));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(DeleteAccountEvent()),
        expect: () => const <AuthenticationState>[
          LogoutState(status: AuthStatus.loading),
          LogoutState(status: AuthStatus.loaded),
        ],
      );
      blocTest<AuthenticationBloc, AuthenticationState>(
        'should emit [ LogoutState(status: AuthStatus.loading),  LogoutState(status: AuthStatus.error)] when DeleteAccountEvent is added.',
        build: () {
          when(
            mockDeleteAccountUseCase(NoParams()),
          ).thenAnswer(
              (_) async => Left(ServerFailure(errorMessage: 'server error')));
          return authenticationBloc;
        },
        act: (bloc) => bloc.add(DeleteAccountEvent()),
        expect: () => const <AuthenticationState>[
          LogoutState(status: AuthStatus.loading),
          LogoutState(status: AuthStatus.error),
        ],
      );
    });
  });
}
