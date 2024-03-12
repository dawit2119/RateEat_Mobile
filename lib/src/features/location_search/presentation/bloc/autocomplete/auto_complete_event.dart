import 'package:equatable/equatable.dart';

abstract class AutoCompleteEvent extends Equatable {
  @override
  List<Object> get props => [];
}

class SearchLocationEvent extends AutoCompleteEvent {
  final String place;

  SearchLocationEvent({required this.place});

  @override
  List<Object> get props => [place];
}

class TriggerInitialEvent extends AutoCompleteEvent {}

class GetPlacesEvent extends AutoCompleteEvent {
  final String place;

  GetPlacesEvent({required this.place});

  @override
  List<Object> get props => [place];
}
