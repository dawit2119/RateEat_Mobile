import 'package:rateeat_mobile/src/features/candidate_restaurant/domain/entities/candid_rest_request.dart';

class CandidRest extends CandidRestaurant {
  CandidRest(
      {required super.name,
      super.description,
      required super.menuImages,
      super.restImages});
}
