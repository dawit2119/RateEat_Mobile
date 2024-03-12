import 'package:rateeat_mobile/src/features/location_search/domain/entities/search_autocomplete.dart';

class GoogleAutoCompleteModel extends SearchAutocomplete {
  const GoogleAutoCompleteModel({
    required super.description,
    required super.placeId,
  });

  factory GoogleAutoCompleteModel.fromJson(Map<String, dynamic> json) {
    return GoogleAutoCompleteModel(
      description: json['description'],
      placeId: json['place_id'],
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'description': description,
      'place_id': placeId,
    };
  }
}
