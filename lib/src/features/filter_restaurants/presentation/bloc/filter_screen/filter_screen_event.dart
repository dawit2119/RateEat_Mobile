import 'package:equatable/equatable.dart';

class FilterEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RatingChangedEvent extends FilterEvent {
  final String rating;
  final String location;
  RatingChangedEvent({required this.rating, required this.location});
  @override
  List<Object> get props => [rating, location];
}

class PriceChangedEvent extends FilterEvent {
  final String price;
  final String location;
  PriceChangedEvent({required this.price, required this.location});
  @override
  List<Object> get props => [price, location];
}

class PriceRangeChangedEvent extends FilterEvent {
  final String priceRange;
  final String location;
  PriceRangeChangedEvent({required this.priceRange, required this.location});
  @override
  List<Object> get props => [priceRange, location];
}

class FilterSubmittedEvent extends FilterEvent {
  final String query;
  FilterSubmittedEvent({required this.query});
  @override
  List<Object> get props => [query];
}
