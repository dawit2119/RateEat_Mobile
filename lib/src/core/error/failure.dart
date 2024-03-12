import 'package:equatable/equatable.dart';
import 'exception.dart';

abstract class Failure extends Equatable {
  abstract final String errorMessage;
  @override
  List<Object?> get props => [];
}

class ServerFailure extends Failure {
  @override
  final String errorMessage;
  ServerFailure({this.errorMessage = 'Server failure'});
}

class CacheFailure extends Failure {
  @override
  final String errorMessage;
  CacheFailure({this.errorMessage = 'Cache failure'});
}

class NetworkFailure extends Failure {
  @override
  final String errorMessage;
  NetworkFailure({this.errorMessage = 'No internet connection'});
}

class UnauthorizedRequestFailure extends Failure {
  @override
  final String errorMessage;

  UnauthorizedRequestFailure({this.errorMessage = 'User not authenticated'});
}

class AnonymousFailure extends Failure {
  @override
  final String errorMessage;
  AnonymousFailure({this.errorMessage = 'Unknown error happened'});
}

class DefaultFailure extends Failure {
  @override
  final String errorMessage;
  DefaultFailure({this.errorMessage = "Something Went Wrong, Try Again Later"});
}

class SignInWithGoogleFailure extends Failure {
  @override
  final String errorMessage;

  SignInWithGoogleFailure({
    this.errorMessage = 'Sign In With Google Failed',
  });
}

SignInWithGoogleFailure handleGoogleSignInException(
    SignInWithGoogleException exception) {
  return SignInWithGoogleFailure(errorMessage: exception.errorMessage);
}

class SignOutWithGoogleFailure extends Failure {
  @override
  final String errorMessage;

  SignOutWithGoogleFailure({
    this.errorMessage = 'Sign Out With Google Failed',
  });
}

SignOutWithGoogleFailure handleGoogleSignOutException(
    SignOutWithGoogleException exception) {
  return SignOutWithGoogleFailure(errorMessage: exception.errorMessage);
}

class SignInWithFacebookFailure extends Failure {
  @override
  final String errorMessage;

  SignInWithFacebookFailure({
    this.errorMessage = 'Sign In With Facebook Failed',
  });
}

SignInWithFacebookFailure handleFacebookSignInException(
    SignInWithFacebookException exception) {
  return SignInWithFacebookFailure(errorMessage: exception.errorMessage);
}

class SignOutWithFacebookFailure extends Failure {
  @override
  final String errorMessage;

  SignOutWithFacebookFailure({
    this.errorMessage = 'Sign Out With Google Failed',
  });
}

SignOutWithFacebookFailure handleFacebookSignOutException(
    SignOutWithFacebookException exception) {
  return SignOutWithFacebookFailure(errorMessage: exception.errorMessage);
}

class SignInWithAppleFailure extends Failure {
  @override
  final String errorMessage;

  SignInWithAppleFailure({
    this.errorMessage = 'Sign In With Apple Failed',
  });
}

SignInWithAppleFailure handleAppleSignInException(
    SignInWithAppleException exception) {
  return SignInWithAppleFailure(errorMessage: exception.errorMessage);
}

class SignOutWithAppleFailure extends Failure {
  @override
  final String errorMessage;

  SignOutWithAppleFailure({
    this.errorMessage = 'Sign Out With Apple Failed',
  });
}

SignOutWithAppleFailure handleAppleSignOutException(
    SignOutWithAppleException exception) {
  return SignOutWithAppleFailure(errorMessage: exception.errorMessage);
}
