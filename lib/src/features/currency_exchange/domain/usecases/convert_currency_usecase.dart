import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/domain/entities/currency_conversion.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/domain/repositories/currency_repository.dart';

class ConvertCurrencyUseCase extends UseCase<CurrencyConversion, ConvertCurrencyParams> {
  final CurrencyRepository repository;

  ConvertCurrencyUseCase({required this.repository});

  @override
  Future<Either<Failure, CurrencyConversion>> call(ConvertCurrencyParams params) async {
    return await repository.convertCurrency(
      from: params.from,
      to: params.to,
      amount: params.amount,
    );
  }
}

class ConvertCurrencyParams extends Equatable {
  final String from;
  final String to;
  final double amount;

  const ConvertCurrencyParams({
    required this.from,
    required this.to,
    required this.amount,
  });

  @override
  List<Object?> get props => [from, to, amount];
}
