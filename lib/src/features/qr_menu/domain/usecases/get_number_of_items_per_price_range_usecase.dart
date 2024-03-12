import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class GetNumberOfItemsPerPriceRangeUsecase
    extends UseCase<List<PriceRange>, GetNumberOfItemsPerPriceRangeParams> {
  final QRMenuRepository qrMenuRepository;
  GetNumberOfItemsPerPriceRangeUsecase({required this.qrMenuRepository});

  @override
  Future<Either<Failure, List<PriceRange>>> call(params) async {
    return await qrMenuRepository.getNumberOfItemsPerPriceRange(
      restaurantId: params.restaurantId,
      isFasting: params.isFasting,
      category: params.category,
      minRating: params.minRating,
      query: params.query,
    );
  }
}

class GetNumberOfItemsPerPriceRangeParams {
  final String restaurantId;
  final bool? isFasting;
  final QRCategory? category;
  final int? minRating;
  final String query;

  GetNumberOfItemsPerPriceRangeParams({
    required this.restaurantId,
    required this.isFasting,
    required this.category,
    required this.minRating,
    required this.query,
  });
}
