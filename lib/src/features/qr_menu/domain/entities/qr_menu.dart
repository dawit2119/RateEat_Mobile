import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/features/features.dart';

abstract class QRMenu extends Equatable {
  final String backgroundColor;
  final int? totalCategories;
  final String restaurantName;
  final String restaurantId;
  final String? restaurantImageUrl;
  final String itemBackgroundColor;
  final List<QRCategory> categories;
  final Map<QRCategory, List<QRItem>> items;
  final Restaurant? restaurant;

  const QRMenu({
    required this.restaurantName,
    required this.restaurantId,
    required this.restaurantImageUrl,
    required this.backgroundColor,
    required this.itemBackgroundColor,
    required this.categories,
    required this.items,
    required this.totalCategories,
    required this.restaurant,
  });

  @override
  List<Object?> get props => [
        backgroundColor,
        restaurantName,
        restaurantImageUrl,
        itemBackgroundColor,
        categories,
        items,
        totalCategories,
        restaurantId,
        restaurant,
      ];
}
