import '../../domain/entities/total_price.dart';

class TotalPriceModel extends TotalPrice {
  const TotalPriceModel({required super.totalItems, required super.totalPrice});

  factory TotalPriceModel.fromMap(Map<String, dynamic> map) => TotalPriceModel(
        totalItems: map['totalItems'],
        totalPrice: map['totalPrice'].toDouble(),
      );
}
