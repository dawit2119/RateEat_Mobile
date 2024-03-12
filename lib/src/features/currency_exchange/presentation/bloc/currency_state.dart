import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/domain/entities/currency_conversion.dart';

abstract class CurrencyState extends Equatable {
  @override
  List<Object?> get props => [];
}

class CurrencyInitial extends CurrencyState {}

class CurrencyLoading extends CurrencyState {}

class CurrencySuccess extends CurrencyState {
  final CurrencyConversion conversion;
  CurrencySuccess({required this.conversion});

  @override
  List<Object?> get props => [conversion];
}

// NEW: State that holds the global exchange rate for the restaurant
class CurrencyRateUpdated extends CurrencyState {
  final String fromCurrency;
  final String targetCurrency;
  final double exchangeRate;

  CurrencyRateUpdated({
    required this.fromCurrency,
    required this.targetCurrency,
    required this.exchangeRate,
  });

  @override
  List<Object?> get props => [fromCurrency, targetCurrency, exchangeRate];
}

class CurrencyError extends CurrencyState {
  final String message;
  CurrencyError({required this.message});

  @override
  List<Object?> get props => [message];
}
