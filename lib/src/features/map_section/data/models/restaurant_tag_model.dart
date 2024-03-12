import 'dart:convert';
import 'package:rateeat_mobile/src/features/map_section/domain/entities/restaurant_tag.dart';

class RestaurantTagModel extends RestaurantTag {
  const RestaurantTagModel({super.id, super.name});

  factory RestaurantTagModel.fromMap(Map<String, dynamic> data) =>
      RestaurantTagModel(
        id: data['id'] as String?,
        name: data['name'] as String?,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
      };

  /// `dart:convert`
  ///
  /// Parses the string and returns the resulting Json object as [RestaurantTag].
  factory RestaurantTagModel.fromJson(String data) {
    return RestaurantTagModel.fromMap(
        json.decode(data) as Map<String, dynamic>);
  }

  /// `dart:convert`
  ///
  /// Converts [RestaurantTag] to a JSON string.
  String toJson() => json.encode(toMap());

  RestaurantTagModel copyWith({
    String? id,
    String? name,
  }) {
    return RestaurantTagModel(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];
}
