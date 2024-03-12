import 'package:equatable/equatable.dart';

class TotalPrice extends Equatable {
  final int totalItems;
  final double totalPrice;
  const TotalPrice({
    required this.totalItems,
    required this.totalPrice,
  });

  @override
  List<Object?> get props => [totalItems, totalPrice];
}
