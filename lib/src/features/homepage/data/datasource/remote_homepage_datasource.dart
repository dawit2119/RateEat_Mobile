import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/data/models/popular_items_response_model.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/popular_items_response.dart';
import 'dart:developer';

abstract class RemoteHomeSource {
  Future<PopularItemsResponse> getTopRatedItems({
    required int limit,
    required int page,
    required List<String> tags,
    double? lat,
    double? lng,
    bool? isFasting,
  });
  Future<List<PromotionModel>> getPromotions();
  Future<List<RecommendedRestaurantModel>> getRestaurantRecommendations({
    required int limit,
    required int page,
    required List<String> tags,
    double? latitude,
    double? longitude,
  });
}

class RemoteHomeSourceImpl implements RemoteHomeSource {
  final Dio dio;

  RemoteHomeSourceImpl({
    required this.dio,
  });

  @override
  Future<PopularItemsResponse> getTopRatedItems({
    required int limit,
    required int page,
    required List<String> tags,
    double? lat,
    double? lng,
    bool? isFasting,
  }) async {
    try {
      String location =
          (lat != null && lng != null) ? '&latitude=$lat&longitude=$lng' : '';
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (user != null) {
        headers.addEntries([
          MapEntry('Authorization', 'Bearer ${user.token}'),
        ]);
      }
      var url =
          '$baseURL/items/home/highest_rated?radius=2000$location&limit=$limit&page=$page${isFasting != null ? "&fasting=$isFasting" : ""}';

      if (tags.isNotEmpty) {
        url += '&tags=${tags.join(',')}';
      }

      log('remote home datatsoruce url $url');
      final response = await dio.get(url, options: Options(headers: headers));
      if (response.statusCode == 200) {
        final rawItems = response.data['data'];
        log('remote home datatsoruce json $rawItems');
        if (rawItems is! List) {
          throw Exception('Invalid top rated items response');
        }
        final data = rawItems
            .map<ItemModel>(
                (item) => ItemModel.fromJson(item as Map<String, dynamic>))
            .toList();
        log('remote home datatsoruce data $data');
        final totalItems = data.length;
        return PopularItemsResponseModel(items: data, totalItems: totalItems);
      } else {
        throw Exception('Failed to load top rated items');
      }
    } catch (e) {
      log('remote home datatsoruce error $e');
      throw NetworkException();
    }
  }

  @override
  Future<List<PromotionModel>> getPromotions() async {
    try {
      final response = await dio.get('$baseURL/promotions');
      if (response.statusCode == 200) {
        final json = response.data['data'];
        return json
            .map<PromotionModel>((promo) => PromotionModel.fromJson(promo))
            .toList();
      } else {
        throw Exception('Failed to load top rated promotions');
      }
    } catch (e) {
      throw ServerException();
    }
  }

  @override
  Future<List<RecommendedRestaurantModel>> getRestaurantRecommendations({
    required int limit,
    required int page,
    required List<String> tags,
    double? latitude,
    double? longitude,
  }) async {
    try {
      final response = await dio.get(
        '$baseURL/restaurants?sortedBy=rating&limit=$limit&page=$page&tags=${tags.join(',')}',
      );
      if (response.statusCode == 200) {
        final json = response.data['data'];
        return json
            .map<RecommendedRestaurantModel>(
                (item) => RecommendedRestaurantModel.fromJson(item))
            .toList();
      } else {
        throw Exception('Failed to load top rated items');
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
