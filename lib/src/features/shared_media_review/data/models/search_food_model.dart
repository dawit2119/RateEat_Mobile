import 'dart:convert';

import '../../domain/entities/food_search_result.dart';

class FoodSearchResultModel extends FoodSearchResult {
  const FoodSearchResultModel({
    required super.id,
    required super.name,
    required super.imageUri,
  });

  factory FoodSearchResultModel.fromMap(Map<String, dynamic> data) {
    return FoodSearchResultModel(
      id: data['id'] as String?,
      name: data['name'] as String?,
      imageUri: data['image_url'] as String?,
    );
  }

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'currency': imageUri,
      };

  factory FoodSearchResultModel.fromJson(String data) {
    return FoodSearchResultModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  FoodSearchResult copyWith({
    String? id,
    String? name,
    String? imageUri,
  }) {
    return FoodSearchResult(
      id: id ?? this.id,
      name: name ?? this.name,
      imageUri: imageUri ?? this.imageUri,
    );
  }

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, imageUri];
}
