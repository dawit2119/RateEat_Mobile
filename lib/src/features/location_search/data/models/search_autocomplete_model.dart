import 'package:rateeat_mobile/src/features/location_search/domain/entities/search_autocomplete.dart';

class SearchAutoCompleteModel extends SearchAutocomplete {
  const SearchAutoCompleteModel({
    required super.description,
    required super.placeId,
    required String super.name,
    required String super.latitude,
    required String super.longitude,
  });

  factory SearchAutoCompleteModel.fromJson(Map<String, dynamic> json) {
    return SearchAutoCompleteModel(
      description: json['display_name'] ?? "",
      placeId: json['place_id'] ?? "",
      name: json['name'] ?? "",
      latitude: json['lat'] ?? "",
      longitude: json['lon'] ?? "",
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'place_id': placeId,
    };
  }
}
