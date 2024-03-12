import 'package:equatable/equatable.dart';

import '../../../../user_profile/data/data.dart';

abstract class AuthenticationEvent extends Equatable {
  const AuthenticationEvent();

  @override
  List<Object> get props => [];
}

class SendPhoneOtpEvent extends AuthenticationEvent {
  final String phoneNumber;

  const SendPhoneOtpEvent({required this.phoneNumber});
}

class SendEmailOtpEvent extends AuthenticationEvent {
  final String email;

  const SendEmailOtpEvent({required this.email});
}

class SendEditPhoneOtpEvent extends AuthenticationEvent {
  final String phoneNumber;

  const SendEditPhoneOtpEvent({required this.phoneNumber});
}

class SendEditEmailOtpEvent extends AuthenticationEvent {
  final String email;

  const SendEditEmailOtpEvent({required this.email});
}

class VerifyOtpEvent extends AuthenticationEvent {
  final String phoneNumber;
  final String code;

  const VerifyOtpEvent({required this.phoneNumber, required this.code});
}

class VerifyEmailOtpEvent extends AuthenticationEvent {
  final String email;
  final String code;

  const VerifyEmailOtpEvent({required this.email, required this.code});
}

class ResendOtpEvent extends AuthenticationEvent {
  final String phoneNumber;

  const ResendOtpEvent({required this.phoneNumber});
}

class ResendEmailOtpEvent extends AuthenticationEvent {
  final String email;
  const ResendEmailOtpEvent({required this.email});
}

class SignUpEvent extends AuthenticationEvent {
  final UserModel user;

  const SignUpEvent({required this.user});

  @override
  List<Object> get props => [
        user,
      ];
}

class SignInWithGoogleEvent extends AuthenticationEvent {}

class SignOutWithGoogleEvent extends AuthenticationEvent {}

class SignInWithFacebookEvent extends AuthenticationEvent {}

class SignOutWithFacebookEvent extends AuthenticationEvent {}

class SignInWithAppleEvent extends AuthenticationEvent {}

class SignOutWithAppleEvent extends AuthenticationEvent {}

class LogoutEvent extends AuthenticationEvent {}

class DeleteAccountEvent extends AuthenticationEvent {}
