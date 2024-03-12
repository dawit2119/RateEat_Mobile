import 'package:dartz/dartz.dart';
import 'package:equatable/equatable.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/domain/repositories/price_item_update_repository.dart';

class PriceItemUsecase extends UseCase<String, ItemPriceReviewUseCaseParams> {
  final ItemPriceReviewRepository itemPriceReviewRepository;
  PriceItemUsecase({required this.itemPriceReviewRepository});
  @override
  Future<Either<Failure, String>> call(
      ItemPriceReviewUseCaseParams params) async {
    return await itemPriceReviewRepository.priceReviewRequest(
      priceItemReviewRequestModel: params.priceItemReviewRequestModel,
    );
  }
}

class ItemPriceReviewUseCaseParams extends Equatable {
  final PriceItemReviewRequestModel priceItemReviewRequestModel;
  const ItemPriceReviewUseCaseParams(
      {required this.priceItemReviewRequestModel});

  @override
  List<Object> get props => [priceItemReviewRequestModel];
}
