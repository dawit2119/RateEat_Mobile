import 'package:rateeat_mobile/src/features/currency_exchange/domain/entities/currency_conversion.dart';

class CurrencyConversionModel extends CurrencyConversion {
  CurrencyConversionModel({
    required super.from,
    required super.to,
    required super.amount,
    required super.convertedAmount,
    required super.exchangeRate,
  });

  factory CurrencyConversionModel.fromJson(Map<String, dynamic> json) =>
      CurrencyConversionModel(
        from: json['from'],
        to: json['to'],
        amount: json['amount'].toDouble(),
        convertedAmount: json['converted_amount'].toDouble(),
        exchangeRate: json['exchange_rate'].toDouble(),
      );

  Map<String, dynamic> toJson() => {
        'from': from,
        'to': to,
        'amount': amount,
        'convertedAmount': convertedAmount,
        'exchangeRate': exchangeRate,
      };

  CurrencyConversion toEntity() => CurrencyConversion(
        from: from,
        to: to,
        amount: amount,
        convertedAmount: convertedAmount,
        exchangeRate: exchangeRate,
      );
}
