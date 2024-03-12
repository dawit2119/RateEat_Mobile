import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/models/candid_rest.dart';

abstract class CandidateRepository {
  Future<Either<Failure, String>> createCandidateRestaurant(
      {required CandidRest candidRest});
}
