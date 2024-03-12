import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class QRMenuRepositoryImpl extends QRMenuRepository {
  final QRMenuRemoteDatasource qrMenuRemoteDataSource;

  QRMenuRepositoryImpl({required this.qrMenuRemoteDataSource});

  @override
  Future<Either<Failure, QRMenu>> getQRMenu({
    required String restaurantId,
    QRCategory? category,
    bool? isFasting = false,
    required int page,
    required int limit,
    String? query,
    required String? sortBy,
    required int? minPrice,
    required int? maxPrice,
    required int? minRating,
    required String sortType,
  }) async {
    try {
      final response = await qrMenuRemoteDataSource.getQRMenu(
        restaurantId: restaurantId,
        page: page,
        isFasting: isFasting,
        limit: limit,
        category: category,
        query: query,
        sortBy: sortBy,
        maxPrice: maxPrice,
        minPrice: minPrice,
        minRating: minRating,
        sortType: sortType,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
          ServerFailure(errorMessage: e.errorMessage ?? "server exception"));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, List<PriceRange>>> getNumberOfItemsPerPriceRange({
    required String restaurantId,
    required bool? isFasting,
    required QRCategory? category,
    required int? minRating,
    required String query,
  }) async {
    try {
      final response =
          await qrMenuRemoteDataSource.getNumberOfItemsPerPriceRange(
        restaurantId: restaurantId,
        isFasting: isFasting,
        category: category,
        minRating: minRating,
        query: query,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
          ServerFailure(errorMessage: e.errorMessage ?? "server exception"));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, QROrder>> placeQROrder({
    required String restaurantId,
    required Map<QRItem, int> items,
    required String orderNote,
    required Location location,
    required String orderType,
  }) async {
    try {
      final response = await qrMenuRemoteDataSource.placeQROrder(
        restaurantId: restaurantId,
        items: items,
        orderNote: orderNote,
        location: location,
        orderType: orderType,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
          ServerFailure(errorMessage: e.errorMessage ?? "server exception"));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, QROrder>> getQROrder({
    required String orderId,
  }) async {
    try {
      final response = await qrMenuRemoteDataSource.getQROrderDetails(
        orderId: orderId,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
          ServerFailure(errorMessage: e.errorMessage ?? "server exception"));
    } catch (e) {
      return Left(ServerFailure(errorMessage: e.toString()));
    }
  }

  @override
  Future<Either<Failure, QROrder>> updateQROrder({
    required String orderId,
    required Map<QRItem, int> items,
    required String restaurantId,
  }) async {
    try {
      final response = await qrMenuRemoteDataSource.updateQROrder(
        orderId: orderId,
        items: items,
        restaurantId: restaurantId,
      );
      return Right(response);
    } on ServerException catch (e) {
      return Left(
          ServerFailure(errorMessage: e.errorMessage ?? "server exception"));
    } catch (e) {
      return Left(mapExceptionToFailure(exception: e));
    }
  }
}
