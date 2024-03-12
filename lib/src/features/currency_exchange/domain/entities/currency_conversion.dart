class CurrencyConversion {
  final String from;
  final String to;
  final double amount;
  final double convertedAmount;
  final double exchangeRate;
  CurrencyConversion({
    required this.from,
    required this.to,
    required this.amount,
    required this.convertedAmount,
    required this.exchangeRate,
  });
}
