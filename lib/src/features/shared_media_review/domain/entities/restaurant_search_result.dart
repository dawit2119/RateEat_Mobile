import 'package:equatable/equatable.dart';

class RestaurantSearchResult extends Equatable {
  final String? id;
  final String? name;
  final String? currency;

  const RestaurantSearchResult({this.id, this.name, this.currency});

  @override
  bool get stringify => true;

  @override
  List<Object?> get props => [id, name, currency];
}
