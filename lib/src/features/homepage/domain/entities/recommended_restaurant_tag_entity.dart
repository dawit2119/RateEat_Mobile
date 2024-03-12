import 'package:equatable/equatable.dart';

class RecommendedRestaurantTagEntity extends Equatable {
  final String? id;
  final String? name;

  const RecommendedRestaurantTagEntity({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}
