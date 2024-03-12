import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/domain/entities/currency_conversion.dart';

abstract class CurrencyRepository {
  Future<Either<Failure, CurrencyConversion>> convertCurrency({
    required String from,
    required String to,
    required double amount,
  });
}
