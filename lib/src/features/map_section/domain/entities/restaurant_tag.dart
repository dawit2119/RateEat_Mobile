import 'package:equatable/equatable.dart';
import 'package:hive/hive.dart';

part 'restaurant_tag.g.dart';

@HiveType(typeId: 10)
class RestaurantTag extends Equatable {
  @HiveField(0)
  final String? id;

  @HiveField(1)
  final String? name;

  const RestaurantTag({this.id, this.name});

  @override
  List<Object?> get props => [id, name];
}
