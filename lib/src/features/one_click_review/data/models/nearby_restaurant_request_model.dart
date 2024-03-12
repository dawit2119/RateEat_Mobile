import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_request.dart';

class NearByRestaurantRequestModel extends NearByRestaurantRequest {
  NearByRestaurantRequestModel({
    required super.latitude,
    required super.longitude,
    required super.radius,
    required super.page,
    super.searchQuery,
    super.limit,
  });
}
