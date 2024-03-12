import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/qr_menu/domain/domain.dart';

abstract class QRMenuRepository {
  Future<Either<Failure, QRMenu>> getQRMenu({
    required String restaurantId,
    QRCategory? category,
    bool? isFasting,
    required int page,
    required int limit,
    required String? query,
    required String? sortBy,
    required int? minPrice,
    required int? maxPrice,
    required int? minRating,
    required String sortType,
  });

  Future<Either<Failure, List<PriceRange>>> getNumberOfItemsPerPriceRange({
    required String restaurantId,
    required bool? isFasting,
    required QRCategory? category,
    required int? minRating,
    required String query,
  });

  Future<Either<Failure, QROrder>> placeQROrder({
    required String restaurantId,
    required Map<QRItem, int> items,
    required String orderNote,
    required Location location,
    required String orderType,
  });

  Future<Either<Failure, QROrder>> getQROrder({
    required String orderId,
  });

  Future<Either<Failure, QROrder>> updateQROrder({
    required String orderId,
    required Map<QRItem, int> items,
    required String restaurantId,
  });
}
