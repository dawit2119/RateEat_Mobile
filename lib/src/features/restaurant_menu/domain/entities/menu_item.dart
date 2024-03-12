import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'menu_item.g.dart';

@HiveType(typeId: 35)
class RestaurantMenuItem extends Equatable {
  @HiveField(0)
  final String? id;
  @HiveField(1)
  final String? name;
  @HiveField(2)
  final String? description;
  @HiveField(3)
  final String? imageUrl;
  @HiveField(4)
  final int? numberOfReviews;
  @HiveField(5)
  final double? averageRating;
  @HiveField(6)
  final double? price;

  const RestaurantMenuItem({
    this.id,
    this.name,
    this.description,
    this.imageUrl,
    this.numberOfReviews,
    this.averageRating,
    this.price,
  });

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'description': description,
      'imageUrl': imageUrl,
      'numberOfReviews': numberOfReviews,
      'averageRating': averageRating,
      'price': price,
    };
  }

  factory RestaurantMenuItem.fromJson(Map<String, dynamic> json) {
    return RestaurantMenuItem(
      id: json['id'] as String?,
      name: json['name'] as String?,
      description: json['description'] as String?,
      imageUrl: json['imageUrl'] as String?,
      numberOfReviews: json['numberOfReviews'] as int?,
      averageRating: (json['averageRating'] as num?)?.toDouble(),
      price: (json['price'] as num?)?.toDouble(),
    );
  }

  @override
  List<Object?> get props => [
        id,
        name,
        description,
        imageUrl,
        numberOfReviews,
        averageRating,
        price,
      ];
}
