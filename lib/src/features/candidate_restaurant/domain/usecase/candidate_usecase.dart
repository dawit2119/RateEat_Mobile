import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/models/candid_rest.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/domain/repository/candidate_repo.dart';

class CandidateUseCase {
  final CandidateRepository candidateRepository;
  CandidateUseCase({required this.candidateRepository});

  Future<Either<Failure, String>> createCandidateRestaurant(
      {required CandidRest candidRest}) async {
    return await candidateRepository.createCandidateRestaurant(
        candidRest: candidRest);
  }
}
