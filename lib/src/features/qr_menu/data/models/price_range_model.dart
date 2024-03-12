import 'package:rateeat_mobile/src/features/features.dart';

class PriceRangeModel extends PriceRange {
  const PriceRangeModel(
      {required super.minPrice, required super.maxPrice, required super.count});

  factory PriceRangeModel.fromMap(map) {
    return PriceRangeModel(
        minPrice: map["min"],
        maxPrice: map["max"] == 9007199254740991 ? null : map["max"],
        count: map["count"]);
  }
}
