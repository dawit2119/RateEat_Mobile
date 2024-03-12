import 'dart:convert';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_response.dart';

class NearByItemResponseModel extends NearByItemResponse {
  const NearByItemResponseModel({
    required super.id,
    required super.name,
    required super.imageUri,
  });

  factory NearByItemResponseModel.fromMap(Map<String, dynamic> data) {
    return NearByItemResponseModel(
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

  factory NearByItemResponseModel.fromJson(String data) {
    return NearByItemResponseModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  NearByItemResponseModel copyWith({
    String? id,
    String? name,
    String? imageUri,
  }) {
    return NearByItemResponseModel(
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

// class NearByItemIngredientsModel extends NearByItemIngredients {
//   NearByItemIngredientsModel({
//     required super.id,
//     required super.name,
//     super.itemId,
//     super.createdAt,
//     required super.updatedAt,
//   });

//   factory NearByItemIngredientsModel.fromJson(Map<String, dynamic> json) =>
//       NearByItemIngredientsModel(
//         id: json["id"],
//         name: json["name"],
//         itemId: json["item_id"] ?? "",
//         createdAt: json["createdAt"] != null
//             ? DateTime.parse(json["createdAt"])
//             : DateTime.now(),
//         updatedAt: json["updatedAt"] != null
//             ? DateTime.parse(json["updatedAt"])
//             : DateTime.now(),
//       );
// }
