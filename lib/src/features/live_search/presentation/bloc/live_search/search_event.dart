import 'package:equatable/equatable.dart';

class SearchEvent extends Equatable {
  @override
  List<Object?> get props => [];
}

class RestaurantSearchEvent extends SearchEvent {
  final String query;
  RestaurantSearchEvent({required this.query});
}

class ItemSearchEvent extends SearchEvent {
  final String query;
  final double latitude;
  final double longitude;
  ItemSearchEvent({
    required this.query,
    required this.latitude,
    required this.longitude,
  });
}

class TriggerInitial extends SearchEvent {}
