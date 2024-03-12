import 'package:rateeat_mobile/src/core/error/exception.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';

Failure mapExceptionToFailure({required exception}) {
  switch (exception) {
    case CacheException _:
      return CacheFailure();
    case ServerException _:
      return ServerFailure(
        errorMessage: exception.errorMessage ?? "server failure",
      );
    case NetworkException _:
      return NetworkFailure();
    case UnauthorizedRequestException _:
      return UnauthorizedRequestFailure();
    default:
      return DefaultFailure();
  }
}
