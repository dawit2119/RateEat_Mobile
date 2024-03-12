import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';

abstract class FeedbackRepository {
  Future<Either<Failure, String>> giveFeedback(String comment);
}
