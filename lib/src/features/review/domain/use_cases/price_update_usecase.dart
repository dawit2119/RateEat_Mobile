import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/price_update_repository.dart';

class PriceReviewUsecase extends UseCase<String, PriceReviewUseCaseParams> {
  final PriceReviewRepository priceReviewRepository;
  PriceReviewUsecase({required this.priceReviewRepository});
  @override
  Future<Either<Failure, String>> call(PriceReviewUseCaseParams params) async {
    return await priceReviewRepository.priceReviewRequest(
      priceReviewRequestModel: params.priceReviewRequestModel,
    );
  }
}

class PriceReviewUseCaseParams extends Equatable {
  final PriceReviewRequestModel priceReviewRequestModel;
  const PriceReviewUseCaseParams({required this.priceReviewRequestModel});

  @override
  List<Object> get props => [priceReviewRequestModel];
}
