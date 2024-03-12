import 'package:equatable/equatable.dart';

abstract class CurrencyEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class ConvertCurrencyEvent extends CurrencyEvent {
  final String from;
  final String to;
  final double amount;

  ConvertCurrencyEvent({
    required this.from,
    required this.to,
    required this.amount,
  });

  @override
  List<Object> get props => [from, to, amount];
}

// NEW: Event to update currency for all items
class UpdateRestaurantCurrencyEvent extends CurrencyEvent {
  final String fromCurrency; // The restaurant's original currency (e.g., 'ETB')
  final String targetCurrency; // The new currency to show (e.g., 'USD')

  UpdateRestaurantCurrencyEvent({
    required this.fromCurrency,
    required this.targetCurrency,
  });

  @override
  List<Object> get props => [fromCurrency, targetCurrency];
}
