import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'user_recommendation.g.dart';

@HiveType(typeId: 20)
class UserRecommendation extends Equatable {
  @HiveField(0)
  final RecommendationItem? item;
  @HiveField(1)
  final RecommendationRestaurant? restaurant;
  @HiveField(2)
  final String? recommendationContent;

  const UserRecommendation(
      {required this.item,
      required this.restaurant,
      required this.recommendationContent});

  @override
  List<Object?> get props => [recommendationContent, item, restaurant];
}

@HiveType(typeId: 21)
class RecommendationRestaurant extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final double review;
  @HiveField(2)
  final String id;
  @HiveField(3)
  final String imageUrl;

  const RecommendationRestaurant(
      {required this.imageUrl,
      required this.name,
      required this.review,
      required this.id});

  @override
  List<Object?> get props => [name, review, id];
}

@HiveType(typeId: 22)
class RecommendationItem extends Equatable {
  @HiveField(0)
  final String name;
  @HiveField(1)
  final double review;
  @HiveField(2)
  final String restaurantName;
  @HiveField(3)
  final String id;
  @HiveField(4)
  final String imageUrl;

  const RecommendationItem(
      {required this.imageUrl,
      required this.id,
      required this.name,
      required this.review,
      required this.restaurantName});

  @override
  List<Object?> get props => [id, review, restaurantName, name];
}
