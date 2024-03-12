import 'dart:io';

import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/features/authentication/data/data.dart';

import '../../../../core/core.dart';
import '../../../homepage/data/models/models.dart';
import '../../../homepage/domain/entities/item.dart';
import '../../domain/entities/menu.dart';
import '../models/menu.dart';
import '../models/restaurant_category.dart';

abstract class RestaurantMenuDataProvider {
  Future<List<ItemModel>> getRestaurantMenuItems({
    required String restaurantId,
    required int limit,
    required int page,
  });

  Future<Menu> getRestaurantMenuCategoryItems({
    required String restaurantId,
    required String categoryId,
    required int page,
    required int limit,
    required String query,
    required String sortBy,
  });

  Future<Item> addCandidateItem({
    required String itemName,
    required String price,
    required List<File>? itemImages,
    required String menuId,
    required String categoryName,
  });
  Future<List<RestaurantMenuCategoryModel>> getRestaurantMenuCategories({
    required String restaurantId,
  });
}

class RestaurantMenuDataProviderImpl implements RestaurantMenuDataProvider {
  final Dio dio;
  const RestaurantMenuDataProviderImpl({
    required this.dio,
  });
  @override
  Future<List<ItemModel>> getRestaurantMenuItems({
    required String restaurantId,
    required int limit,
    required int page,
  }) async {
    try {
      final url = await dio.get(
          "$baseURL/restaurants/$restaurantId/items?page=$page&limit=$limit");
      var items = url.data["data"];

      return items
          .map(
            (json) => ItemModel.fromJson(json),
          )
          .toList()
          .cast<ItemModel>();
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  @override
  Future<Menu> getRestaurantMenuCategoryItems({
    required String restaurantId,
    required String categoryId,
    required int page,
    required int limit,
    required String query,
    required String sortBy,
  }) async {
    try {
      var url =
          "$baseURL/restaurants/$restaurantId/menu?page=$page&limit=$limit&sortedBy=$sortBy";
      if (categoryId.isNotEmpty) {
        url += "&categoryId=$categoryId";
      }
      if (query != "") {
        url += "&searchTerm=$query";
      }
      final response = await dio.get(url).timeout(const Duration(seconds: 30));
      final data = response.data;
      final items = data['data']
          .map<ItemModel>(
            (item) => ItemModel.fromJson(
              item,
            ),
          )
          .toList();
      final menuId =
          items.isNotEmpty ? data['data'][0]['categories']['menu_id'] : "";
      final int? count = response.data["count"];
      final loadedItemsCount = ((page - 1) * limit + items.length).toInt();
      return MenuModel(
          id: menuId,
          items: items,
          totalItemsCount: count,
          loadedItemsCount: loadedItemsCount);
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  @override
  Future<Item> addCandidateItem({
    required String itemName,
    required String price,
    required List<File>? itemImages,
    required String menuId,
    required String categoryName,
  }) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      //* form data
      final formData = FormData.fromMap({
        "menu_id": menuId,
        "category_name": categoryName,
        "name": itemName,
        "price": price,
      });
      if (itemImages != null && itemImages.isNotEmpty) {
        final images = itemImages;

        for (File item in images) {
          formData.files.addAll([
            MapEntry(
              "item_images",
              await MultipartFile.fromFile(item.path,
                  filename: item.path.split("/").last),
            )
          ]);
        }
      }

      final response = await dio.post(
        "$baseURL/candidate-items",
        options: Options(
          headers: {
            'Content-Type': 'application/json',
            'Accept': 'application/json',
            'Authorization': 'Bearer ${user!.token}'
          },
        ),
        data: formData,
      );
      return ItemModel.fromJson(
        response.data["data"],
      );
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }

  @override
  Future<List<RestaurantMenuCategoryModel>> getRestaurantMenuCategories(
      {required String restaurantId}) async {
    try {
      final url =
          await dio.get("$baseURL/restaurants/$restaurantId/menu/categories");
      final response = url.data;
      return response['data']
          .map<RestaurantMenuCategoryModel>(
              (category) => RestaurantMenuCategoryModel.fromJson(category))
          .toList();
    } catch (e) {
      throw ServerException(errorMessage: e.toString());
    }
  }
}
