import 'dart:convert';

import '../../domain/entities/restaurant_search_result.dart';

class RestaurantSearchResultModel extends RestaurantSearchResult {
  const RestaurantSearchResultModel({
    required super.id,
    required super.name,
    required super.currency,
  });

  factory RestaurantSearchResultModel.fromMap(Map<String, dynamic> data) {
    return RestaurantSearchResultModel(
      id: data['id'] as String?,
      name: data['name'] as String?,
      currency: data['currency'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'currency': currency,
      };

  factory RestaurantSearchResultModel.fromJson(String data) {
    return RestaurantSearchResultModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  RestaurantSearchResult copyWith({
    String? id,
    String? name,
    String? currency,
  }) {
    return RestaurantSearchResult(
      id: id ?? this.id,
      name: name ?? this.name,
      currency: currency ?? this.currency,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, currency];
}
