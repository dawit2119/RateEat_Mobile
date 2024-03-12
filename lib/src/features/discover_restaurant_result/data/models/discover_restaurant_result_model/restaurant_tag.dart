import 'package:equatable/equatable.dart';

class RestaurantTag extends Equatable {
  final String? id;
  final String? name;

  const RestaurantTag({this.id, this.name});

  factory RestaurantTag.fromJson(Map<String, dynamic> data) => RestaurantTag(
        id: data['id'] as String?,
        name: data['name'] as String?,
      );

  RestaurantTag copyWith({
    String? id,
    String? name,
  }) {
    return RestaurantTag(
      id: id ?? this.id,
      name: name ?? this.name,
    );
  }

  @override
  List<Object?> get props => [id, name];
}
