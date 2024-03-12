import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_detail/domain/entities/popular_item_reviews_response.dart';

import '../../../homepage/domain/entities/item.dart';

class LocalItemDetailDataSource {
  final int maxItemDetail = 20;
  final String itemDetailBoxName = 'itemDetailBox';
  final String popularItemReviewsBoxName = 'popularItemReviewsBox';
  final String recommendedItemsBoxName = 'recommendedItemsBox';

  late final Box<Item> itemDetailBox;
  late final Box<PopularItemReviewsResponse> popularItemReviewsBox;
  late final Box<String> recommendedItemsBox;

  LocalItemDetailDataSource({
    Box<Item>? itemDetailBox,
    popularItemReviewsBox,
    recommendedItemsBox,
  }) {
    this.itemDetailBox = itemDetailBox ?? Hive.box<Item>(itemDetailBoxName);
    this.popularItemReviewsBox = popularItemReviewsBox ??
        Hive.box<PopularItemReviewsResponse>(popularItemReviewsBoxName);
    this.recommendedItemsBox =
        recommendedItemsBox ?? Hive.box<String>(recommendedItemsBoxName);
  }

  /// item data related methods
  Future<Item> getItemDetail(String itemId) async {
    final item = itemDetailBox.get(itemId);
    if (item == null) {
      throw Exception('Item not found');
    }
    return ItemModel.fromEntity(item);
  }

  Future<void> saveItemDetail(Item item) async {
    final box = itemDetailBox;

    while (box.length >= maxItemDetail && !box.keys.contains(item.itemId)) {
      final oldestKey = box.keys.first;
      await box.delete(oldestKey);
    }

    return box.put(item.itemId, item);
  }

  Future<void> deleteItemDetail(String itemId) async {
    return itemDetailBox.delete(itemId);
  }

  // popular item reviews related methods
  Future<PopularItemReviewsResponse?> getPopularItemReviews(
      String itemId) async {
    final reviews = popularItemReviewsBox.get(itemId);
    return reviews;
  }

  Future<void> savePopularItemReviews(
      String itemId, PopularItemReviewsResponse reviews) async {
    try {
      final box = popularItemReviewsBox;
      while (box.length >= maxItemDetail && !box.keys.contains(itemId)) {
        final oldestKey = box.keys.first;
        await box.delete(oldestKey);
      }
      box.put(itemId, reviews);
    } catch (e) {
      debugPrint('Failed to save popular item reviews');
    }
  }

  Future<void> deletePopularItemReviews(String itemId) async {
    return popularItemReviewsBox.delete(itemId);
  }

  Future<List<Item>?> getRecommendedItems(String itemId) async {
    try {
      final box = recommendedItemsBox;
      final String? jsonString = box.get(itemId);
      if (jsonString == null) return null;

      // Parse JSON string to List<dynamic>
      final List<dynamic> jsonList = decodeNestedJson(jsonString);
      // Convert each map to Item
      return jsonList.map((json) => ItemModel.fromCacheJson(json)).toList();
    } catch (e) {
      debugPrint('Failed to get recommended items');
      return null;
    }
  }

  Future<void> saveRecommendedItems(String itemId, List<Item> items) async {
    try {
      final box = recommendedItemsBox;
      while (box.length >= maxItemDetail && !box.keys.contains(itemId)) {
        final oldestKey = box.keys.first;
        await box.delete(oldestKey);
      }
      // Convert items to JSON string
      final String jsonString =
          json.encode(items.map((item) => item.toStringJson()).toList());
      box.put(itemId, jsonString);
    } catch (e) {
      debugPrint('Failed to save recommended items');
    }
  }

  Future<void> deleteRecommendedItems(String itemId) async {
    return recommendedItemsBox.delete(itemId);
  }
}

dynamic decodeNestedJson(dynamic jsonData) {
  if (jsonData is String) {
    try {
      return decodeNestedJson(json.decode(jsonData));
    } catch (e) {
      return jsonData;
    }
  } else if (jsonData is Map) {
    return Map<String, dynamic>.fromEntries(
      jsonData.entries.map(
        (e) => MapEntry(e.key.toString(), decodeNestedJson(e.value)),
      ),
    );
  } else if (jsonData is List) {
    return jsonData.map((e) => decodeNestedJson(e)).toList();
  }
  return jsonData;
}
