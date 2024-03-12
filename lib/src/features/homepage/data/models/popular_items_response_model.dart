import 'package:rateeat_mobile/src/features/homepage/domain/entities/popular_items_response.dart';

class PopularItemsResponseModel extends PopularItemsResponse {
  const PopularItemsResponseModel(
      {required super.items, required super.totalItems});

  @override
  List<Object?> get props => [items, totalItems];
}
