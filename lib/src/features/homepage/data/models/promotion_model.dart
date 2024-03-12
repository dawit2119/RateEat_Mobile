import 'package:rateeat_mobile/src/features/features.dart';

class PromotionModel extends Promotion {
  const PromotionModel({
    required super.itemId,
    required super.foodName,
    required super.restaurantName,
    required super.imageUrl,
    required super.discount,
  });

  factory PromotionModel.fromJson(Map<String, dynamic> json) {
    return PromotionModel(
      itemId: json['itemId'] ?? '',
      foodName: json['foodName'] ?? '',
      restaurantName: json['restaurantName'] ?? '',
      imageUrl: json['imageUrl'] ?? '',
      discount: json['discount'] ?? 0,
    );
  }

  @override
  PromotionModel copyWith({
    String? itemId,
    String? foodName,
    String? restaurantName,
    String? imageUrl,
    int? discount,
  }) {
    return PromotionModel(
      itemId: itemId ?? this.itemId,
      foodName: foodName ?? this.foodName,
      restaurantName: restaurantName ?? this.restaurantName,
      imageUrl: imageUrl ?? this.imageUrl,
      discount: discount ?? this.discount,
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'itemId': itemId,
      'foodName': foodName,
      'restaurantName': restaurantName,
      'imageUrl': imageUrl,
      'discount': discount,
    };
  }
}
