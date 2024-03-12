import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/data/datasources/datasources.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/data/models/models.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/domain/entities/currency_conversion.dart';
import 'package:rateeat_mobile/src/features/currency_exchange/domain/repositories/currency_repository.dart';

class CurrencyRepositoryImpl extends CurrencyRepository {
  final RemoteCurrencyDataSource remoteDataSource;
  final LocalCurrencyDataSource localDataSource;

  CurrencyRepositoryImpl({
    required this.remoteDataSource,
    required this.localDataSource,
  });

  @override
  Future<Either<Failure, CurrencyConversion>> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    try {
      final CurrencyConversionModel convertedAmount =
          await remoteDataSource.convertCurrency(
        from: from,
        to: to,
        amount: amount,
      );

      await localDataSource.cacheConversion(convertedAmount);

      return Right(convertedAmount.toEntity());
    } on ServerException catch (e) {
      return Left(ServerFailure(errorMessage: e.errorMessage.toString()));
    } catch (e) {
      return Left(ServerFailure(errorMessage: 'Conversion failed'));
    }
  }
}
