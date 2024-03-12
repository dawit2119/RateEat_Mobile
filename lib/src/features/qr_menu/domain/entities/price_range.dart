import 'package:equatable/equatable.dart';

abstract class PriceRange extends Equatable {
  final int? minPrice;
  final int? maxPrice;
  final int? count;
  const PriceRange(
      {required this.minPrice, required this.maxPrice, required this.count});

  @override
  List<Object?> get props => [
        minPrice,
        maxPrice,
        count,
      ];
}
