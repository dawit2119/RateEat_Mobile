import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_request.dart';

class NearByItemRequestModel extends NearByItemRequest {
  NearByItemRequestModel({
    required super.restaurantId,
    required super.itemName,
    required super.page,
    super.limit,
  });
}
