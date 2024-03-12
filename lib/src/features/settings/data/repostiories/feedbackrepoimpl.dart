import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/settings/data/datasources/remote_feedback_datasource.dart';
import 'package:rateeat_mobile/src/features/settings/domain/repostiory/feedbackrepo.dart';

class FeedbackRepoImpl extends FeedbackRepository {
  final FeedbackDataSource feedbackDataSource;
  FeedbackRepoImpl({required this.feedbackDataSource});
  @override
  Future<Either<Failure, String>> giveFeedback(String comment) async {
    try {
      final res = await feedbackDataSource.giveFeedback(comment);
      return Right(res);
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }
}
