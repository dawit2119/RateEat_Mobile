import 'package:dartz/dartz.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

import '../../../../features.dart';
import '../../../../live_search/data/data_sources/local_search_history_data_source.dart';
import '../../../../live_search/presentation/bloc/local_history/local_search_history_bloc.dart';
import '../../../../live_search/presentation/bloc/local_history/local_search_history_event.dart';

class AuthenticationBloc
    extends Bloc<AuthenticationEvent, AuthenticationState> {
  final SignInWithGoogleUseCase signInWithGoogleUseCase;
  final SignOutWithGoogleUseCase signOutWithGoogleUseCase;
  final SignInWithFacebookUseCase signInWithFacebookUseCase;
  final SignOutWithFacebookUseCase signOutWithFacebookUseCase;
  final SignInWithAppleUsecase signInWithAppleUseCase;
  final LogoutWithAppleUsecase signOutWithAppleUseCase;
  final LoginGoogleUseCase loginGoogleUseCase;
  final LoginFacebookUseCase loginFacebookUseCase;
  final SendPhoneOtpUseCase sendPhoneOtpUseCase;
  final SendEmailOtpUseCase sendEmailOtpUseCase;
  final SendEditPhoneOtpUseCase sendEditPhoneOtpUseCase;
  final SendEditEmailOtpUseCase sendEditEmailOtpUseCase;
  final VerifyOtpUseCase verifyOtpUseCase;
  final VerifyEmailOtpUseCase verifyEmailOtpUseCase;
  final SignupUseCase signUpUseCase;
  final ResendOtpUseCase resendOtpUseCase;
  final ResendEmailOtpUseCase resendEmailOtpUseCase;
  final LogoutUseCase logoutUseCase;
  final DeleteAccountUseCase deleteAccountUseCase;
  final LocalSearchHistoryBloc localSearchHistoryBloc;

  AuthenticationBloc({
    required this.signInWithGoogleUseCase,
    required this.signOutWithGoogleUseCase,
    required this.signInWithFacebookUseCase,
    required this.signOutWithFacebookUseCase,
    required this.signInWithAppleUseCase,
    required this.signOutWithAppleUseCase,
    required this.loginFacebookUseCase,
    required this.loginGoogleUseCase,
    required this.sendPhoneOtpUseCase,
    required this.sendEmailOtpUseCase,
    required this.sendEditPhoneOtpUseCase,
    required this.sendEditEmailOtpUseCase,
    required this.verifyOtpUseCase,
    required this.verifyEmailOtpUseCase,
    required this.resendEmailOtpUseCase,
    required this.resendOtpUseCase,
    required this.signUpUseCase,
    required this.logoutUseCase,
    required this.deleteAccountUseCase,
    required this.localSearchHistoryBloc,
  }) : super(AuthenticationInitial()) {
    on<SignInWithGoogleEvent>(_onSignInWithGoogle);
    on<SignOutWithGoogleEvent>(_onSignOutWithGoogle);
    on<SignInWithFacebookEvent>(_onSignInWithFacebook);
    on<SignOutWithFacebookEvent>(_onSignOutWithFacebook);
    on<SignInWithAppleEvent>(_onSignInWithApple);
    on<SignOutWithAppleEvent>(_onSignOutWithApple);
    on<SendPhoneOtpEvent>(_onSendPhoneOtp);
    on<SendEmailOtpEvent>(_onSendEmailOtp);
    on<SendEditEmailOtpEvent>(_onSendEditEmailOtp);
    on<SendEditPhoneOtpEvent>(_onSendEditPhoneOtp);
    on<VerifyOtpEvent>(_onVerifyOtp);
    on<VerifyEmailOtpEvent>(_onVerifyEmailOtp);
    on<ResendOtpEvent>(_onResendOtp);
    on<ResendEmailOtpEvent>(_onResendEmailOtp);
    on<SignUpEvent>(_onSignUp);
    on<LogoutEvent>(_onLogout);
    on<DeleteAccountEvent>(_onDeleteAccount);
  }

//! Messages
  String _mapFailureToMessage(Failure failure) {
    switch (failure) {
      case ServerFailure _:
        return "Server Error";
      case NetworkFailure _:
        return "Network Error";
      case CacheFailure _:
        return "Cache Error";
      case UnauthorizedRequestFailure _:
        return "It's Unauthorized Request";
      case SignInWithGoogleFailure _:
        return failure.errorMessage;
      case SignInWithAppleFailure _:
        return failure.errorMessage;
      case AnonymousFailure _:
        return "";
      default:
        return "Something Went Wrong, Try Again Later";
    }
  }

//* SingUp
  void _onSignUp(SignUpEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SignUpState(status: AuthStatus.loading));

    final failureOrSignUp = await signUpUseCase(
      SignUpParams(
        user: event.user,
      ),
    );
    emit(_eitherSignUpOrFailure(failureOrSignUp));
  }

  AuthenticationState _eitherSignUpOrFailure(
      Either<Failure, User> failureOrSignUp) {
    return failureOrSignUp.fold(
      (error) => SignUpState(
          status: AuthStatus.error, errorMessage: error.errorMessage),
      (success) => SignUpState(status: AuthStatus.loaded, user: success),
    );
  }

//* Send Otp to phone
  void _onSendPhoneOtp(
      SendPhoneOtpEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SendPhoneOtpState(status: AuthStatus.loading));

    final failureOrOtp = await sendPhoneOtpUseCase(
        SendPhoneOtpParams(phoneNumber: event.phoneNumber));
    emit(_eitherPhoneOtpOrError(failureOrOtp, event.phoneNumber));
  }

  AuthenticationState _eitherPhoneOtpOrError(
      Either<Failure, void> failureOrOtp, String phoneNumber) {
    return failureOrOtp.fold(
      (failure) => SendPhoneOtpState(
          status: AuthStatus.error,
          errorMessage: _mapFailureToMessage(failure),
          phoneNumber: phoneNumber),
      (success) => SendPhoneOtpState(
          status: AuthStatus.loaded, phoneNumber: phoneNumber),
    );
  }

  //* Send Otp to email
  void _onSendEmailOtp(
      SendEmailOtpEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SendEmailOtpState(status: AuthStatus.loading));

    final failureOrOtp =
        await sendEmailOtpUseCase(SendEmailOtpParams(email: event.email));
    emit(_eitherEmailOtpOrError(failureOrOtp, event.email));
  }

  AuthenticationState _eitherEmailOtpOrError(
      Either<Failure, void> failureOrOtp, String email) {
    return failureOrOtp.fold(
      (failure) => SendEmailOtpState(
          status: AuthStatus.error,
          errorMessage: _mapFailureToMessage(failure),
          email: email),
      (success) => SendEmailOtpState(status: AuthStatus.loaded, email: email),
    );
  }

  //* Send Edit Otp to phone
  void _onSendEditPhoneOtp(
      SendEditPhoneOtpEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SendEditPhoneOtpState(status: AuthStatus.loading));

    final failureOrOtp = await sendEditPhoneOtpUseCase(
        SendEditPhoneOtpParams(phoneNumber: event.phoneNumber));
    emit(_eitherEditPhoneOtpOrError(failureOrOtp, event.phoneNumber));
  }

  AuthenticationState _eitherEditPhoneOtpOrError(
      Either<Failure, void> failureOrOtp, String phoneNumber) {
    return failureOrOtp.fold(
      (failure) => SendEditPhoneOtpState(
          status: AuthStatus.error,
          errorMessage: failure.errorMessage,
          phoneNumber: phoneNumber),
      (success) => SendEditPhoneOtpState(
          status: AuthStatus.loaded, phoneNumber: phoneNumber),
    );
  }

  //* Send Otp to Email
  void _onSendEditEmailOtp(
      SendEditEmailOtpEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SendEditEmailOtpState(status: AuthStatus.loading));

    final failureOrOtp = await sendEditEmailOtpUseCase(
        SendEditEmailOtpParams(email: event.email));
    emit(_eitherEditEmailOtpOrError(failureOrOtp, event.email));
  }

  AuthenticationState _eitherEditEmailOtpOrError(
      Either<Failure, void> failureOrOtp, String email) {
    return failureOrOtp.fold(
      (failure) => SendEditEmailOtpState(
          status: AuthStatus.error,
          errorMessage: failure.errorMessage,
          email: email),
      (success) =>
          SendEditEmailOtpState(status: AuthStatus.loaded, email: email),
    );
  }

  //* Verify Otp
  void _onVerifyOtp(
      VerifyOtpEvent event, Emitter<AuthenticationState> emit) async {
    emit(const VerifyOtpState(status: AuthStatus.loading));

    final failureOrOtp = await verifyOtpUseCase(
        VerifyOtpParams(phoneNumber: event.phoneNumber, code: event.code));
    emit(_eitherVerifyOrError(failureOrOtp, event.phoneNumber, event.code));
  }

  AuthenticationState _eitherVerifyOrError(
      Either<Failure, UserLoginResponse> failureOrOtp,
      String phoneNumber,
      code) {
    return failureOrOtp.fold((failure) {
      if (failure is UnauthorizedRequestFailure) {
        return const VerifyOtpState(
          status: AuthStatus.error,
          errorMessage: "Unauthorized Request",
        );
      }
      return const VerifyOtpState(
          status: AuthStatus.error, errorMessage: "Invalid OTP");
    }, (success) {
      localSearchHistoryBloc.add(
        ClearLocalSearchHistory(localSearchType: LocalSearchType.items),
      );
      localSearchHistoryBloc.add(
        ClearLocalSearchHistory(localSearchType: LocalSearchType.restaurants),
      );
      return VerifyOtpState(status: AuthStatus.loaded, response: success);
    });
  }

  //* Verify Email Otp

  void _onVerifyEmailOtp(
      VerifyEmailOtpEvent event, Emitter<AuthenticationState> emit) async {
    emit(const VerifyEmailOtpState(status: AuthStatus.loading));
    final failureOrOtp = await verifyEmailOtpUseCase(
        VerifyEmailOtpParams(email: event.email, code: event.code));
    emit(_eitherVerifyEmailOrError(failureOrOtp, event.email, event.code));
  }

  AuthenticationState _eitherVerifyEmailOrError(
      Either<Failure, UserLoginResponse> failureOrOtp, String email, code) {
    return failureOrOtp.fold((failure) {
      if (failure is UnauthorizedRequestFailure) {
        return const VerifyEmailOtpState(
          status: AuthStatus.error,
          errorMessage: "Unauthorized Request",
        );
      }
      return const VerifyEmailOtpState(
          status: AuthStatus.error, errorMessage: "Invalid OTP");
    }, (success) {
      localSearchHistoryBloc.add(
        ClearLocalSearchHistory(localSearchType: LocalSearchType.items),
      );
      localSearchHistoryBloc.add(
        ClearLocalSearchHistory(localSearchType: LocalSearchType.restaurants),
      );
      return VerifyEmailOtpState(status: AuthStatus.loaded, response: success);
    });
  }

  //* Resend Otp
  void _onResendOtp(
      ResendOtpEvent event, Emitter<AuthenticationState> emit) async {
    emit(const ResendOtpState(status: AuthStatus.loading));

    final failureOrOtp = await resendOtpUseCase(
      ResendOtpParams(
        phoneNumber: event.phoneNumber,
      ),
    );
    emit(_eitherResendOrError(failureOrOtp, event.phoneNumber));
  }

  AuthenticationState _eitherResendOrError(
      Either<Failure, void> failureOrOtp, String phoneNumber) {
    return failureOrOtp.fold(
      (failure) => ResendOtpState(
        status: AuthStatus.error,
        errorMessage: _mapFailureToMessage(failure),
      ),
      (success) =>
          ResendOtpState(status: AuthStatus.loaded, phoneNumber: phoneNumber),
    );
  }

  //* Resend Email Otp
  void _onResendEmailOtp(
      ResendEmailOtpEvent event, Emitter<AuthenticationState> emit) async {
    emit(const ResendEmailOtpState(status: AuthStatus.loading));

    final failureOrOtp = await resendEmailOtpUseCase(
      ResendEmailOtpParams(
        email: event.email,
      ),
    );
    emit(_eitherResendEmailOrError(failureOrOtp, event.email));
  }

  AuthenticationState _eitherResendEmailOrError(
      Either<Failure, void> failureOrOtp, String email) {
    return failureOrOtp.fold(
      (failure) => ResendEmailOtpState(
        status: AuthStatus.error,
        errorMessage: _mapFailureToMessage(failure),
      ),
      (success) => ResendEmailOtpState(status: AuthStatus.loaded, email: email),
    );
  }

//* Sign-in with Google
  void _onSignInWithGoogle(event, emit) async {
    emit(const SignInWithGoogleState(status: AuthStatus.loading));

    final failureOrSignInWithGoogle = await signInWithGoogleUseCase(
      NoParams(),
    );

    if (failureOrSignInWithGoogle.isLeft()) {
      final failure = failureOrSignInWithGoogle.fold((l) => l, (r) => null);
      emit(SignInWithGoogleState(
        status: AuthStatus.error,
        errorMessage: _mapFailureToMessage(failure!),
      ));
    } else if (failureOrSignInWithGoogle.isRight()) {
      final user = failureOrSignInWithGoogle.fold((_) => null, (r) => r);
      final failureOrLoginEmail = await loginGoogleUseCase(
        LoginEmailParams(
          email: user!.email!,
          accessToken: user.token!,
          firstName: user.firstName!,
          lastName: user.lastName,
        ),
      );
      emit(_eitherSignInWithGoogleOrFailure(failureOrLoginEmail, user));
    }
  }

  AuthenticationState _eitherSignInWithGoogleOrFailure(
      Either<Failure, UserLoginResponse> failureOrLoginEmail, User user) {
    return failureOrLoginEmail.fold((error) {
      if (error is UnauthorizedRequestFailure) {
        return const SignInWithGoogleState(
          status: AuthStatus.error,
          errorMessage: "Unauthorized Request",
        );
      }
      return SignInWithGoogleState(
          status: AuthStatus.error, errorMessage: _mapFailureToMessage(error));
    }, (success) {
      localSearchHistoryBloc.add(
        ClearLocalSearchHistory(localSearchType: LocalSearchType.items),
      );
      localSearchHistoryBloc.add(
        ClearLocalSearchHistory(localSearchType: LocalSearchType.restaurants),
      );
      return SignInWithGoogleState(
        status: AuthStatus.loaded,
        response: success,
      );
    });
  }

//* Sign-out with Google
  void _onSignOutWithGoogle(
      SignOutWithGoogleEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SignOutWithGoogleState(status: AuthStatus.loading));
    final failureOrSignOutWithGoogle = await signOutWithGoogleUseCase(
      NoParams(),
    );
    emit(_eitherSignOutWithGoogleOrFailure(failureOrSignOutWithGoogle));
  }

  AuthenticationState _eitherSignOutWithGoogleOrFailure(
      Either<Failure, void> failureOrSignOutWithGoogle) {
    return failureOrSignOutWithGoogle.fold(
      (error) => SignOutWithGoogleState(
        status: AuthStatus.error,
        errorMessage: error.errorMessage,
      ),
      (success) => const SignOutWithGoogleState(
        status: AuthStatus.loaded,
      ),
    );
  }

  // * Sign-in with Facebook
  void _onSignInWithFacebook(event, emit) async {
    emit(const SignInWithFacebookState(status: AuthStatus.loading));

    final failureOrSignInWithFacebook = await signInWithFacebookUseCase(
      NoParams(),
    );

    if (failureOrSignInWithFacebook.isLeft()) {
      final failure = failureOrSignInWithFacebook.fold((l) => l, (r) => null);
      emit(SignInWithFacebookState(
        status: AuthStatus.error,
        errorMessage: _mapFailureToMessage(failure!),
      ));
    } else if (failureOrSignInWithFacebook.isRight()) {
      final user = failureOrSignInWithFacebook.fold((_) => null, (r) => r);
      final failureOrLoginEmail = await loginFacebookUseCase(
        LoginEmailParams(
          email: user!.email!,
          accessToken: user.token!,
          firstName: user.firstName!,
          lastName: user.lastName,
        ),
      );
      emit(_eitherSignInWithFacebookOrFailure(failureOrLoginEmail, user));
    }
  }

  AuthenticationState _eitherSignInWithFacebookOrFailure(
      Either<Failure, UserLoginResponse> failureOrLoginEmail, User user) {
    return failureOrLoginEmail.fold((error) {
      if (error is UnauthorizedRequestFailure) {
        return SignInWithFacebookState(
          status: AuthStatus.error,
          errorMessage: _mapFailureToMessage(error),
        );
      }
      return SignInWithFacebookState(
          status: AuthStatus.error, errorMessage: _mapFailureToMessage(error));
    }, (success) {
      localSearchHistoryBloc.add(
        ClearLocalSearchHistory(localSearchType: LocalSearchType.items),
      );
      localSearchHistoryBloc.add(
        ClearLocalSearchHistory(localSearchType: LocalSearchType.restaurants),
      );
      return SignInWithFacebookState(
        status: AuthStatus.loaded,
        response: success,
      );
    });
  }

//* Sign-out with Facebook
  void _onSignOutWithFacebook(
      SignOutWithFacebookEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SignOutWithFacebookState(status: AuthStatus.loading));
    final failureOrSignOutWithFacebook = await signOutWithFacebookUseCase(
      NoParams(),
    );
    emit(_eitherSignOutWithFacebookOrFailure(failureOrSignOutWithFacebook));
  }

  AuthenticationState _eitherSignOutWithFacebookOrFailure(
      Either<Failure, void> failureOrSignOutWithFacebook) {
    return failureOrSignOutWithFacebook.fold(
      (error) => SignOutWithFacebookState(
        status: AuthStatus.error,
        errorMessage: error.errorMessage,
      ),
      (success) => const SignOutWithFacebookState(
        status: AuthStatus.loaded,
      ),
    );
  }

  //* Logout
  void _onLogout(LogoutEvent event, Emitter<AuthenticationState> emit) async {
    emit(const LogoutState(status: AuthStatus.loading));
    final failureOrLogout = await logoutUseCase(
      NoParams(),
    );
    emit(_eitherLogoutOrFailure(failureOrLogout));
  }

  AuthenticationState _eitherLogoutOrFailure(
      Either<Failure, void> failureOrLogout) {
    return failureOrLogout.fold(
      (error) => LogoutState(
        status: AuthStatus.error,
        errorMessage: error.errorMessage,
      ),
      (success) => const LogoutState(
        status: AuthStatus.loaded,
      ),
    );
  }

  //* Delete Account
  void _onDeleteAccount(
      DeleteAccountEvent event, Emitter<AuthenticationState> emit) async {
    emit(const LogoutState(status: AuthStatus.loading));
    try {
      final failureOrDeleteAccount = await deleteAccountUseCase(NoParams());
      emit(_eitherDeleteAccountOrFailure(failureOrDeleteAccount));
    } catch (e) {
      // CATCH UNEXPECTED CRASHES HERE
      emit(LogoutState(
        status: AuthStatus.error,
        errorMessage: "Unexpected Error: $e",
      ));
    }
  }

  AuthenticationState _eitherDeleteAccountOrFailure(
      Either<Failure, void> failureOrDeleteAccount) {
    return failureOrDeleteAccount.fold(
      (error) => LogoutState(
        status: AuthStatus.error,
        errorMessage: error.errorMessage,
      ),
      (success) => const LogoutState(
        status: AuthStatus.loaded,
      ),
    );
  }

//* Sign-in with Apple
  void _onSignInWithApple(event, emit) async {
    emit(const SignInWithAppleState(status: AuthStatus.loading));

    final failureOrSignInWithApple = await signInWithAppleUseCase(
      NoParams(),
    );

    emit(_eitherSignInWithAppleOrFailure(failureOrSignInWithApple));
  }

  AuthenticationState _eitherSignInWithAppleOrFailure(
      Either<Failure, UserLoginResponse> failureOrSignInWithApple) {
    return failureOrSignInWithApple.fold((error) {
      if (error is UnauthorizedRequestFailure) {
        return const SignInWithAppleState(
          status: AuthStatus.error,
          errorMessage: "Unauthorized Request",
        );
      }
      return SignInWithAppleState(
          status: AuthStatus.error, errorMessage: _mapFailureToMessage(error));
    }, (success) {
      localSearchHistoryBloc.add(
        ClearLocalSearchHistory(localSearchType: LocalSearchType.items),
      );
      localSearchHistoryBloc.add(
        ClearLocalSearchHistory(localSearchType: LocalSearchType.restaurants),
      );
      return SignInWithAppleState(
        status: AuthStatus.loaded,
        response: success,
      );
    });
  }

//* Sign-out with Apple
  void _onSignOutWithApple(
      SignOutWithAppleEvent event, Emitter<AuthenticationState> emit) async {
    emit(const SignOutWithAppleState(status: AuthStatus.loading));
    final failureOrSignOutWithApple = await signOutWithAppleUseCase(
      NoParams(),
    );
    emit(_eitherSignOutWithAppleOrFailure(failureOrSignOutWithApple));
  }

  AuthenticationState _eitherSignOutWithAppleOrFailure(
      Either<Failure, void> failureOrSignOutWithApple) {
    return failureOrSignOutWithApple.fold(
      (error) => SignOutWithAppleState(
        status: AuthStatus.error,
        errorMessage: error.errorMessage,
      ),
      (success) => const SignOutWithAppleState(
        status: AuthStatus.loaded,
      ),
    );
  }
}
