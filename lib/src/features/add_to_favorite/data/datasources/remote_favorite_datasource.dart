import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

abstract class RemoteFavoriteSource {
  Future<bool> addItemToFavorite({required String itemId});
  Future<bool> removeItemFromFavorite({required String itemId});
  Future<bool> addRestaurantToFavorite({required String restaurantId});
  Future<bool> removeRestaurantFromFavorite({required String restaurantId});
}

class RemoteFavoriteSourceImpl extends RemoteFavoriteSource {
  final Dio dio;
  final AuthenticationLocalSource localSource;
  RemoteFavoriteSourceImpl({required this.dio, required this.localSource});

  @override
  Future<bool> addItemToFavorite({required String itemId}) async {
    try {
      final user = localSource.getUserCredential();
      final body = {
        'itemId': itemId,
      };

      final response = await dio.post(
        '$baseURL/favorites',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token!}',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: "server Error");
      }
    }
  }

  @override
  Future<bool> removeItemFromFavorite({required String itemId}) async {
    try {
      final user = localSource.getUserCredential();
      final response = await dio.delete(
        '$baseURL/favorites/item/$itemId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token!}',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  @override
  Future<bool> addRestaurantToFavorite({required String restaurantId}) async {
    try {
      final user = localSource.getUserCredential();
      final body = {
        'restaurantId': restaurantId,
      };

      final response = await dio.post(
        '$baseURL/favorites',
        data: body,
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token!}',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException();
      }
    } catch (e) {
      if (e is DioException) {
        throw ServerException(errorMessage: e.response?.data['message']);
      } else {
        throw ServerException(errorMessage: "server Error");
      }
    }
  }

  @override
  Future<bool> removeRestaurantFromFavorite(
      {required String restaurantId}) async {
    try {
      final user = localSource.getUserCredential();
      final response = await dio.delete(
        '$baseURL/favorites/restaurant/$restaurantId',
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token!}',
          },
        ),
      );

      if (response.statusCode == 200) {
        return true;
      } else {
        throw ServerException();
      }
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }
}
