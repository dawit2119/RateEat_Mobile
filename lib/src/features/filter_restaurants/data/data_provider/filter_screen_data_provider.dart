import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/dp_injection/dependency_injection.dart';
import 'package:rateeat_mobile/src/core/error/exception.dart';

class FilterDataProvider {
  final dio = dpLocator.get<Dio>();

  Future<String> ratingQuery(String rating, String location) async {
    try {} catch (error) {
      throw ServerException(errorMessage: error.toString());
    }
    return "";
  }

  Future<String> priceQuery(String price, String location) async {
    try {} catch (error) {
      throw ServerException(errorMessage: error.toString());
    }
    return "";
  }

  Future<String> priceRangeQuery(String priceRange, String location) async {
    try {} catch (error) {
      throw ServerException(errorMessage: error.toString());
    }
    return "";
  }

  Future<List<dynamic>> filterRestaurant(String query) async {
    try {} catch (error) {
      throw ServerException(errorMessage: error.toString());
    }
    return [];
  }
}
