import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/settings/domain/repostiory/feedbackrepo.dart';

class FeedbackUseCase {
  final FeedbackRepository feedbackRepository;
  FeedbackUseCase({required this.feedbackRepository});
  Future<Either<Failure, String>> giveFeedback(String comment) async {
    return await feedbackRepository.giveFeedback(comment);
  }
}
