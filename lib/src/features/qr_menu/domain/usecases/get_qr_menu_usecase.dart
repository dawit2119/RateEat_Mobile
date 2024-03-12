import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class GetQRMenuUsecase extends UseCase<QRMenu, GetQRMenuUseCaseParams> {
  final QRMenuRepository qrMenuRepository;

  GetQRMenuUsecase({required this.qrMenuRepository});
  @override
  Future<Either<Failure, QRMenu>> call(params) async {
    return await qrMenuRepository.getQRMenu(
      restaurantId: params.restaurantid,
      page: params.page,
      isFasting: params.isFasting,
      limit: params.limit,
      category: params.category,
      query: params.query,
      sortBy: params.sortBy,
      minPrice: params.minPrice,
      maxPrice: params.maxPrice,
      minRating: params.minRating,
      sortType: params.sortType,
    );
  }
}

class GetQRMenuUseCaseParams {
  final String restaurantid;
  final int page;
  final QRCategory? category;
  final bool? isFasting;
  final int limit;
  final String? query;
  final String? sortBy;
  final int? minPrice;
  final int? maxPrice;
  final int? minRating;
  final String sortType;

  GetQRMenuUseCaseParams({
    required this.page,
    required this.category,
    required this.isFasting,
    required this.restaurantid,
    required this.limit,
    required this.query,
    required this.sortBy,
    required this.minPrice,
    required this.maxPrice,
    required this.minRating,
    required this.sortType,
  });
}
