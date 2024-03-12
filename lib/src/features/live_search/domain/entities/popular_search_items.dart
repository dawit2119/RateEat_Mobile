import 'package:equatable/equatable.dart';

class PopularSearchItems extends Equatable {
  final List<String> items;
  final List<String> restaurants;
  const PopularSearchItems({
    required this.items,
    required this.restaurants,
  });
  @override
  List<Object> get props => [items, restaurants];
}
