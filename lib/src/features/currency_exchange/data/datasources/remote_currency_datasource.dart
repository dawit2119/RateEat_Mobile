import 'package:dartz/dartz.dart';
import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import '../../currency_exchange.dart';

abstract class RemoteCurrencyDataSource {
  Future<CurrencyConversionModel> convertCurrency({
    required String from,
    required String to,
    required double amount,
  });
}

class RemoteCurrencyDataSourceImpl extends RemoteCurrencyDataSource {
  final Dio dio;

  RemoteCurrencyDataSourceImpl({required this.dio});

  @override
  Future<CurrencyConversionModel> convertCurrency({
    required String from,
    required String to,
    required double amount,
  }) async {
    try {
      final response = await dio.post(
        '$baseURL/currency/convert',
        data: {
          'from': from,
          'to': to,
          'amount': amount,
        },
        options: Options(headers: {
          'Content-Type': 'application/json',
        }),
      );

      if (response.statusCode == 200 && response.data['success'] == true) {
        return CurrencyConversionModel.fromJson(
          response.data['data'],
        );
      } else {
        throw ServerException(
          errorMessage: response.data['message'] ?? 'Conversion failed',
        );
      }
    } on DioException catch (e) {
      throw ServerException(
        errorMessage: e.response?.data['message'] ?? 'Conversion failed',
      );
    } catch (_) {
      throw ServerException(
        errorMessage: 'Something went wrong',
      );
    }
  }
}
