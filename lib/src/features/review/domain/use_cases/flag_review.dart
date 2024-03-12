import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import '../../../../core/core.dart';
import '../entities/flag_review.dart';
import '../repositories/item_review_repository.dart';

class FlagReviewUseCase extends UseCase<String, FlagReviewUseCaseParams> {
  final ItemReviewRepository itemReviewRepository;
  FlagReviewUseCase({
    required this.itemReviewRepository,
  });
  @override
  Future<Either<Failure, String>> call(params) async {
    return await itemReviewRepository.flagReview(
      review: params.review,
    );
  }
}

class FlagReviewUseCaseParams extends Equatable {
  final FlagReview review;

  const FlagReviewUseCaseParams({
    required this.review,
  });

  @override
  List<Object> get props => [review];
}
