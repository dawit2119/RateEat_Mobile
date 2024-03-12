import 'dart:convert';
import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';
import 'menu.dart';

part 'categories.g.dart';

@HiveType(typeId: 43)
class Categories extends Equatable {
  @HiveField(0)
  final String? id; // id can be null, so handle it accordingly.

  @HiveField(1)
  final String? name; // name can be null, so handle it accordingly.

  @HiveField(2)
  final Menu? menu; // menu can be null, handle with a conditional check.

  @HiveField(3)
  final String menuId; // menuId is non-nullable, ensure it is passed.

  // Constructor with default values handling for nullable fields.
  const Categories({
    this.id,
    this.name,
    this.menu,
    required this.menuId,
  });

  // Factory constructor to create Categories from a map.
  factory Categories.fromMap(Map<String, dynamic> data) => Categories(
        id: data['id'] as String?, // Handle id as nullable.
        name: data['name'] as String?, // Handle name as nullable.
        menu: data['menu'] == null
            ? null
            : Menu.fromMap(
                data['menu'] as Map<String, dynamic>), // Handle null for menu
        menuId: '',
      );

  // Convert Categories to Map.
  Map<String, dynamic> toMap() => {
        'id': id, // If id is null, it will be stored as null.
        'name': name, // If name is null, it will be stored as null.
        'menu': menu
            ?.toMap(), // If menu is null, it won't include the 'menu' field.
      };

  // Factory constructor to create Categories from a JSON string.
  factory Categories.fromJson(String data) {
    return Categories.fromMap(json.decode(data) as Map<String, dynamic>);
  }

  // Convert Categories to JSON string.
  String toJson() => json.encode(toMap());

  // Copy method to create a new Categories instance with updated values.
  Categories copyWith({
    String? id,
    String? name,
    Menu? menu,
    String? menuId,
  }) {
    return Categories(
      id: id ?? this.id, // Use existing id if not provided.
      name: name ?? this.name, // Use existing name if not provided.
      menu: menu ?? this.menu, // Use existing menu if not provided.
      menuId: '',
    );
  }

  @override
  List<Object?> get props =>
      [id, name, menu]; // Equatable support for comparison.
}
