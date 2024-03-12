import 'package:equatable/equatable.dart';

class SearchAutocomplete extends Equatable {
  final String description;
  final String placeId;
  final String? name;
  final String? latitude;
  final String? longitude;

  const SearchAutocomplete({
    required this.description,
    required this.placeId,
    this.latitude,
    this.longitude,
    this.name,
  });

  @override
  List<Object?> get props => [description, placeId, latitude, longitude, name];

  SearchAutocomplete copyWith({
    String? description,
    String? placeId,
    String? latitude,
    String? longitude,
    String? name,
  }) {
    return SearchAutocomplete(
      name: name ?? this.name,
      description: description ?? this.description,
      placeId: placeId ?? this.placeId,
      latitude: latitude ?? this.latitude,
      longitude: longitude ?? this.longitude,
    );
  }
}
