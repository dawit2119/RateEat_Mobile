import 'package:rateeat_mobile/src/features/features.dart';

abstract class ItemsCountPerPriceEvent {}

class GetItemsCountPerPriceRange extends ItemsCountPerPriceEvent {
  QRCategory? category;
  bool? isFasting;
  int? minRating;
  String restaurantId;
  String query;
  GetItemsCountPerPriceRange({
    required this.category,
    required this.isFasting,
    required this.minRating,
    required this.restaurantId,
    required this.query,
  });
}
