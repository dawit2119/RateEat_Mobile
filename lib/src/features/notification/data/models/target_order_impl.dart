import 'package:rateeat_mobile/src/features/notification/domain/entities/target_order.dart';

class TargetOrderImpl extends TargetOrder {
  const TargetOrderImpl({required super.id, required super.restaurantId});

  factory TargetOrderImpl.fromMap(map) {
    return TargetOrderImpl(id: map["id"], restaurantId: map["restaurant_id"]);
  }
}
