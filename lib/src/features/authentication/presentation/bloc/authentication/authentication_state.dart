import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/authentication/domain/entities/user_login_response.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

abstract class AuthenticationState extends Equatable {
  const AuthenticationState();

  @override
  List<Object> get props => [];
}

enum AuthStatus { loaded, loading, error, profileCreated }

final class AuthenticationInitial extends AuthenticationState {}

class SendPhoneOtpState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final String? phoneNumber;

  const SendPhoneOtpState({
    required this.status,
    this.phoneNumber,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class SendEmailOtpState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final String? email;

  const SendEmailOtpState({
    required this.status,
    this.email,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class SendEditPhoneOtpState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final String? phoneNumber;

  const SendEditPhoneOtpState({
    required this.status,
    this.phoneNumber,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class SendEditEmailOtpState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final String? email;

  const SendEditEmailOtpState({
    required this.status,
    this.email,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class VerifyOtpState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final String? code;
  final UserLoginResponse? response;

  const VerifyOtpState({
    required this.status,
    this.response,
    this.code,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class VerifyEmailOtpState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final String? code;
  final UserLoginResponse? response;

  const VerifyEmailOtpState({
    required this.status,
    this.response,
    this.code,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class ResendOtpState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final String? phoneNumber;

  const ResendOtpState({
    required this.status,
    this.phoneNumber,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class ResendEmailOtpState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final String? email;

  const ResendEmailOtpState({
    required this.status,
    this.email,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class SignUpState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final User? user;

  const SignUpState({required this.status, this.errorMessage, this.user});

  @override
  List<Object> get props => [status];
}

class SignInWithGoogleState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final UserLoginResponse? response;

  const SignInWithGoogleState({
    required this.status,
    this.response,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class SignOutWithGoogleState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;

  const SignOutWithGoogleState({
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class SignInWithFacebookState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final UserLoginResponse? response;

  const SignInWithFacebookState({
    required this.status,
    this.response,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class SignOutWithFacebookState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;

  const SignOutWithFacebookState({
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class LogoutState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;

  const LogoutState({
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class SignInWithAppleState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;
  final UserLoginResponse? response;

  const SignInWithAppleState({
    required this.status,
    this.response,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}

class SignOutWithAppleState extends AuthenticationState {
  final AuthStatus status;
  final String? errorMessage;

  const SignOutWithAppleState({
    required this.status,
    this.errorMessage,
  });

  @override
  List<Object> get props => [status];
}
