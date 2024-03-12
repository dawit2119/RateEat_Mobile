import 'package:rateeat_mobile/src/features/live_search/domain/entities/popular_search_items.dart';

class PopularSearchModel extends PopularSearchItems {
  const PopularSearchModel({
    required super.restaurants,
    required super.items,
  });

  factory PopularSearchModel.fromJson(Map<String, dynamic> json) {
    return PopularSearchModel(
      restaurants: json['restaurant'],
      items: json['item'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      "restaurants": restaurants,
      "items": items,
    };
  }
}
