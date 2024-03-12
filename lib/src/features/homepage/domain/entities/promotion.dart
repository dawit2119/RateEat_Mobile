import 'package:equatable/equatable.dart';

class Promotion extends Equatable {
  final String itemId;
  final String foodName;
  final String restaurantName;
  final String imageUrl;
  final int discount;

  const Promotion({
    required this.itemId,
    required this.foodName,
    required this.restaurantName,
    required this.imageUrl,
    required this.discount,
  });

  @override
  List<Object?> get props =>
      [itemId, foodName, restaurantName, imageUrl, discount];

  Promotion copyWith({
    String? itemId,
    String? foodName,
    String? restaurantName,
    String? imageUrl,
    int? discount,
  }) {
    return Promotion(
      itemId: itemId ?? this.itemId,
      foodName: foodName ?? this.foodName,
      restaurantName: restaurantName ?? this.restaurantName,
      imageUrl: imageUrl ?? this.imageUrl,
      discount: discount ?? this.discount,
    );
  }
}
