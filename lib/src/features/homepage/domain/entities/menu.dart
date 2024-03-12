import 'dart:convert';

import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'menu.g.dart';

// part 'restaurant.g.dart';

@HiveType(typeId: 44)
class Menu extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final Restaurant? restaurant;

  const Menu({this.id, this.restaurant});

  factory Menu.fromMap(Map<String, dynamic> data) => Menu(
        id: data['id'] as String?,
        restaurant: data['restaurant'] == null
            ? null
            : Restaurant.fromMap(data['restaurant'] as Map<String, dynamic>),
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'restaurant': restaurant?.toMap(),
      };

  factory Menu.fromJson(String data) {
    return Menu.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  Menu copyWith({
    String? id,
    Restaurant? restaurant,
  }) {
    return Menu(
      id: id ?? this.id,
      restaurant: restaurant ?? this.restaurant,
    );
  }

  @override
  List<Object?> get props => [id, restaurant];
}

@HiveType(typeId: 45)
class Restaurant {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String currencyCode;

  const Restaurant({this.id, this.name, this.currencyCode = 'ETB'});

  @override
  String toString() => 'Restaurant(id: $id, name: $name)';

  factory Restaurant.fromMap(Map<String, dynamic> data) => Restaurant(
        id: data['id'] as String?,
        name: data['name'] as String?,
        currencyCode: data['currency'] ?? "ETB",
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'name': name,
        'currency': currencyCode,
      };

  factory Restaurant.fromJson(String data) {
    return Restaurant.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  String toJson() => json.encode(toMap());

  Restaurant copyWith({
    String? id,
    String? name,
  }) {
    return Restaurant(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }
}
