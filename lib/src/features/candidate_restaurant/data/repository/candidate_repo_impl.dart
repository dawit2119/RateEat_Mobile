import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/data_sources/candid_rest_data_sources.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/models/candid_rest.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/domain/repository/candidate_repo.dart';

class CandidateRepoImpl extends CandidateRepository {
  final CandidateDataSource candidateDataSource;
  CandidateRepoImpl({required this.candidateDataSource});
  @override
  Future<Either<Failure, String>> createCandidateRestaurant(
      {required CandidRest candidRest}) async {
    try {
      final res = await candidateDataSource.createCandidate(candidRest);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
