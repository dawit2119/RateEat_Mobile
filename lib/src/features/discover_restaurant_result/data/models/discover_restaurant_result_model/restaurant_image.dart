import 'package:equatable/equatable.dart';

class RestaurantImage extends Equatable {
  final String? id;
  final String? url;

  const RestaurantImage({this.id, this.url});

  factory RestaurantImage.fromJson(Map<String, dynamic> data) {
    return RestaurantImage(
      id: data['id'] as String?,
      url: data['url'] as String?,
    );
  }

  RestaurantImage copyWith({
    String? id,
    String? url,
  }) {
    return RestaurantImage(
      id: id ?? this.id,
      url: url ?? this.url,
    );
  }

  @override
  List<Object?> get props => [id, url];
}
