import 'dart:convert';

import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_response.dart';

class NearByRestaurantResponseModel extends NearByRestaurantResponse {
  const NearByRestaurantResponseModel({
    required super.id,
    required super.name,
    required super.currency,
  });

  factory NearByRestaurantResponseModel.fromMap(Map<String, dynamic> data) {
    return NearByRestaurantResponseModel(
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

  factory NearByRestaurantResponseModel.fromJson(String data) {
    final temp = json.decode(data);

    return NearByRestaurantResponseModel.fromMap(temp);
  }

  String toJson() => json.encode(toMap());

  NearByRestaurantResponseModel copyWith({
    String? id,
    String? name,
    String? currency,
  }) {
    return NearByRestaurantResponseModel(
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

// class NearByRestaurantLocationModel extends NearByRestaurantLocation {
//   const NearByRestaurantLocationModel({
//     super.id,
//     super.latitude,
//     super.longitude,
//     super.description,
//   });

//   factory NearByRestaurantLocationModel.fromJson(Map<String, dynamic> data) {
//     return NearByRestaurantLocationModel(
//       id: data['id'] as String?,
//       latitude: (data['latitude'] as num?)?.toDouble(),
//       longitude: (data['longitude'] as num?)?.toDouble(),
//       description: data['description'] as String?,
//     );
//   }

//   @override
//   List<Object?> get props => [id, latitude, longitude, description];
// }

// class NearByRestaurantTagModel extends NearByRestaurantTag {
//   const NearByRestaurantTagModel({super.id, super.name});

//   factory NearByRestaurantTagModel.fromJson(Map<String, dynamic> data) =>
//       NearByRestaurantTagModel(
//         id: data['id'] as String?,
//         name: data['name'] as String?,
//       );

//   @override
//   List<Object?> get props => [id, name];
// }
