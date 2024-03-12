import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class QRMenuRemoteDatasource {
  final Dio dio;

  QRMenuRemoteDatasource({required this.dio});

  Future<QRMenu> getQRMenu({
    required String restaurantId,
    required int page,
    QRCategory? category,
    bool? isFasting = false,
    required int limit,
    String? query = "",
    required String? sortBy,
    required int? minPrice,
    required int? maxPrice,
    required int? minRating,
    required String sortType,
  }) async {
    try {
      String url =
          "$baseURL/restaurants/$restaurantId/qr-menu?page=$page&limit=$limit";
      if (isFasting != null) {
        url += "&fasting=$isFasting";
      }
      if (category != null) {
        url += "&categoryId=${category.id}";
      }
      if (query != "" && query != null) {
        url += "&searchTerm=$query";
      }
      if (sortBy != null) {
        url += "&sortedBy=$sortBy$sortType";
      } else {
        url += "&sortedBy=popularity$sortType";
      }
      if (minPrice != null) {
        url += "&minPrice=$minPrice";
      }
      if (maxPrice != null) {
        url += "&maxPrice=$maxPrice";
      }
      if (minRating != null) {
        url += "&minRating=$minRating";
      }

      final response = await dio.get(url).timeout(
            const Duration(seconds: 30),
          );
      if (response.statusCode == 200) {
        if (category == null) {
          return QRMenuModel.fromMap(response.data);
        } else {
          return QRMenuModel.fromSingleCategoryMap(response.data, category);
        }
      }
      throw Exception(response.data["message"] ?? "server exception");
    } on DioException catch (e) {
      if (e.type == DioExceptionType.connectionTimeout) {
        throw ServerException(errorMessage: "connection timed out");
      } else if (e.type == DioExceptionType.badResponse) {
        throw ServerException(
            errorMessage: e.response?.data["message"] ?? "server exception");
      } else if (e.type == DioExceptionType.connectionError) {
        throw ServerException(errorMessage: "Connection error");
      } else {
        throw ServerException(errorMessage: "server exception");
      }
    } catch (e) {
      throw (ServerException(errorMessage: e.toString()));
    }
  }

  Future<List<PriceRange>> getNumberOfItemsPerPriceRange({
    required String restaurantId,
    required bool? isFasting,
    required QRCategory? category,
    required int? minRating,
    required String query,
  }) async {
    try {
      String url = "$baseURL/restaurants/$restaurantId/qr-menu/price-range?";
      if (isFasting != null) {
        url += "&fasting=$isFasting";
      }
      if (category != null) {
        url += "&categoryId=${category.id}";
      }
      if (minRating != null) {
        url += "&minRating=$minRating";
      }
      if (query != "") {
        url += "&searchTerm=$query";
      }
      final response = await dio.get(url);

      if (response.statusCode != 200) {
        throw DioException(
            requestOptions: RequestOptions(path: url),
            type: DioExceptionType.badResponse,
            response: response);
      }
      final Map<String, dynamic> data =
          response.data?['data']?["predefinedPriceRanges"] ?? {};
      final List<PriceRange> priceRanges = [];
      for (var priceRangeJson in data.values) {
        priceRanges.add(PriceRangeModel.fromMap(priceRangeJson));
      }

      return priceRanges;
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          throw ServerException(errorMessage: "Connection error");
        } else if (e.type == DioExceptionType.badResponse) {
          throw ServerException(
              errorMessage: e.response?.data["message"] ?? "Server exception");
        } else if (e.type == DioExceptionType.connectionTimeout) {
          throw ServerException(errorMessage: "Connection timed out");
        } else {
          throw ServerException(errorMessage: "Server exception");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<QROrder> placeQROrder({
    required Map<QRItem, int> items,
    required String restaurantId,
    required String orderNote,
    required Location location,
    required String orderType,
  }) async {
    String url = "$baseURL/restaurants/$restaurantId/qr-menu/create-order";
    if (dpLocator<AuthenticationLocalSource>().getUserCredential()?.token ==
        null) {
      throw ServerException(errorMessage: "User not authenticated");
    }
    try {
      final response = await dio.post(url,
          options: Options(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
            headers: {
              "Authorization":
                  "Bearer ${dpLocator<AuthenticationLocalSource>().getUserCredential()!.token}"
            },
          ),
          data: {
            "items": [
              for (var entry in items.entries)
                {
                  "itemId": entry.key.id,
                  "quantity": entry.value,
                }
            ],
            "orderMessage": orderNote,
            "userLocation": {
              // "latitude": location.latitude,
              // "longitude": location.longitude,

              "latitude": 9.031172,
              "longitude": 38.762837,
            },
            "orderType": orderType,
          });
      if (response.statusCode != 201) {
        throw DioException(
            requestOptions: RequestOptions(path: url),
            type: DioExceptionType.badResponse,
            response: response);
      }
      return QROrderModel.fromMap(response.data["data"]);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          throw ServerException(errorMessage: "Connection error");
        } else if (e.type == DioExceptionType.badResponse) {
          throw ServerException(
              errorMessage: (e.response?.data is Map
                      ? e.response?.data["message"]
                      : null) ??
                  "Server exception");
        } else if (e.type == DioExceptionType.connectionTimeout) {
          throw ServerException(errorMessage: "Connection timed out");
        } else {
          throw ServerException(errorMessage: "Server exception");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<QROrder> getQROrderDetails({
    required String orderId,
  }) async {
    String url = "$baseURL/orders/$orderId";
    if (dpLocator<AuthenticationLocalSource>().getUserCredential()?.token ==
        null) {
      throw ServerException(errorMessage: "User not authenticated");
    }
    try {
      final response = await dio.get(url,
          options: Options(
            headers: {
              "Authorization":
                  "Bearer ${dpLocator<AuthenticationLocalSource>().getUserCredential()!.token}"
            },
          ));
      if (response.statusCode != 200) {
        throw DioException(
            requestOptions: RequestOptions(path: url),
            type: DioExceptionType.badResponse,
            response: response);
      }
      return QROrderModel.fromMap(response.data["data"]);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          throw ServerException(errorMessage: "Connection error");
        } else if (e.type == DioExceptionType.badResponse) {
          throw ServerException(
              errorMessage: e.response?.data["message"] ?? "Server exception");
        } else if (e.type == DioExceptionType.connectionTimeout) {
          throw ServerException(errorMessage: "Connection timed out");
        } else {
          throw ServerException(errorMessage: "Server exception");
        }
      } else {
        rethrow;
      }
    }
  }

  Future<QROrder> updateQROrder({
    required String orderId,
    required Map<QRItem, int> items,
    required String restaurantId,
  }) async {
    String url = "$baseURL/restaurants/$restaurantId/qr-menu/$orderId";
    if (dpLocator<AuthenticationLocalSource>().getUserCredential()?.token ==
        null) {
      throw ServerException(errorMessage: "User not authenticated");
    }
    try {
      final response = await dio.put(url,
          options: Options(
            contentType: Headers.jsonContentType,
            responseType: ResponseType.json,
            headers: {
              "Authorization":
                  "Bearer ${dpLocator<AuthenticationLocalSource>().getUserCredential()!.token}"
            },
          ),
          data: {
            "items": [
              for (var entry in items.entries)
                {
                  "itemId": entry.key.id,
                  "quantity": entry.value,
                }
            ],
          });
      if (response.statusCode != 200) {
        throw DioException(
            requestOptions: RequestOptions(path: url),
            type: DioExceptionType.badResponse,
            response: response);
      }
      return QROrderModel.fromMap(response.data["data"]);
    } catch (e) {
      if (e is DioException) {
        if (e.type == DioExceptionType.connectionError) {
          throw ServerException(errorMessage: "Connection error");
        } else if (e.type == DioExceptionType.badResponse) {
          throw ServerException(
              errorMessage: e.response?.data["message"] ?? "Server exception");
        } else if (e.type == DioExceptionType.connectionTimeout) {
          throw ServerException(errorMessage: "Connection timed out");
        } else {
          throw ServerException(errorMessage: "Server exception");
        }
      } else {
        rethrow;
      }
    }
  }
}
