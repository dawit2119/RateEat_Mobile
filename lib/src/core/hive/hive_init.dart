import 'dart:developer';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path/path.dart' as p;
import 'package:path_provider/path_provider.dart';
import 'package:rateeat_mobile/src/core/hive/details_analytics_data.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/core/hive/session_track.dart';
import 'package:rateeat_mobile/src/core/hive/user_engagement_analytics.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';

import 'package:rateeat_mobile/src/features/live_search/data/models/history.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/entity.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/incentive.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/saved_reviews_item_response.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/saved_reviews_response.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/data/models/popular_restaurant_review_response_model.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/domain/entities/popular_restaurant_reviews_response.dart';

import '../../features/discover_restaurant_result/data/models/discover_restaurant_result_model/restaurant_phone_number.dart';
import '../../features/features.dart';
import '../../features/homepage/domain/entities/categories.dart';
import '../../features/homepage/domain/entities/item.dart';
import '../../features/restaurant_detail/data/models/popular_restaurant_reviewer_profile_response_model.dart';
import '../../features/restaurant_menu/data/models/restaurant_menu_item.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/menu.dart'
    as homepage;

import '../../features/restaurant_menu/domain/entities/menu_item.dart';

class HiveService {
  static Future<void> init() async {
    try {
      await Hive.initFlutter();
      //* analytics Adapter

      Hive.registerAdapter(DetailsAnalyticsDataAdapter());

      Hive.registerAdapter(UserEngagementAnalyticsAdapter());

      Hive.registerAdapter(UserSessionAdapter());

      //* User Local Model
      Hive.registerAdapter(LocalUserModelAdapter());

      //* Food Category Local Model
      Hive.registerAdapter(ItemCategoryAdapter());

      //* Highest rated items Local Model
      Hive.registerAdapter(ItemAdapter());
      Hive.registerAdapter(IngredientAdapter());
      Hive.registerAdapter(ItemMediaAdapter());

      //* Nearby restaurants Local Model
      Hive.registerAdapter(RestaurantAdapter());
      Hive.registerAdapter(RestaurantTagAdapter());
      Hive.registerAdapter(RestaurantMediaAdapter());
      Hive.registerAdapter(RestaurantLocationAdapter());
      Hive.registerAdapter(RestaurantPhoneNumberAdapter());
      Hive.registerAdapter(RestaurantModelAdapter());
      Hive.registerAdapter(ItemModelAdapter());
      Hive.registerAdapter(homepage.MenuAdapter());
      Hive.registerAdapter(homepage.RestaurantAdapter());
      Hive.registerAdapter(RestaurantMenuItemModelAdapter());
      Hive.registerAdapter(PopularRestaurantReviewsResponseAdapter());
      Hive.registerAdapter(PopularRestaurantReviewResponseModelAdapter());
      Hive.registerAdapter(
          PopularRestaurantReviewerProfileResponseModelAdapter());

      Hive.registerAdapter(CategoriesAdapter());

      //* item detail local model
      await _openBox<Item>('itemDetailBox');
      //item detail review related
      Hive.registerAdapter(PopularItemReviewResponseAdapter());
      Hive.registerAdapter(PopularItemReviewerProfileResponseAdapter());
      Hive.registerAdapter(PopularItemReviewsResponseAdapter());
      await _openBox<PopularItemReviewsResponse>('popularItemReviewsBox');

      //* recommended items local model
      await _openBox<String>('recommendedItemsBox');

      //* profile related local models
      //user model related
      Hive.registerAdapter(UserAdapter());
      Hive.registerAdapter(IncentiveAdapter());
      Hive.registerAdapter(UserStatAdapter());
      Hive.registerAdapter(UserLevelAdapter());
      await _openBox<User>('userProfileBox');

      // user review related
      Hive.registerAdapter(UserReviewAdapter());
      Hive.registerAdapter(ReviewSubjectAdapter());
      Hive.registerAdapter(ReviewMediaAdapter());
      await _openBox<UserReview>('userReviewsBox');

      //user favorite related
      Hive.registerAdapter(UserFavoriteAdapter());
      Hive.registerAdapter(FavoriteItemAdapter());
      Hive.registerAdapter(FavoriteRestaurantAdapter());
      await _openBox<UserFavorite>('userFavoritesBox');

      // draft review related
      Hive.registerAdapter(SavedReviewsResponseAdapter());
      Hive.registerAdapter(SavedReviewItemResponseAdapter());
      Hive.registerAdapter(DraftFileContentAdapter());
      Hive.registerAdapter(ItemCategoriesModelAdapter());
      Hive.registerAdapter(ItemMenuModelAdapter());
      Hive.registerAdapter(ItemRestaurantModelAdapter());
      await _openBox<SavedReviewsResponse>('savedReviewsBox');

      //recommendation
      Hive.registerAdapter(UserRecommendationAdapter());
      Hive.registerAdapter(RecommendationItemAdapter());
      Hive.registerAdapter(RecommendationRestaurantAdapter());
      await _openBox<UserRecommendation>('userRecommendationsBox');

      //* Search History Local Model
      Hive.registerAdapter(HistoryAdapter());
      Hive.registerAdapter(RestaurantMenuItemAdapter());
      //* First Launch
      await _openBox<bool>('appLaunchState');
      await _openBox<String>('fcmTokenBox');
      // Open auth-critical boxes before analytics caches that may need migration.
      await _openBox<LocalUserModel>('userBox');
      await _openBox<DetailsAnalyticsData>('detail');
      await _openBox<UserEngagementAnalytics>('local_analytics');
      await _openBox<UserSession>('user_sessions');

      //* Language reference
      await _openBox<String>('language');

      //* Currency preference
      await _openBox<String>('currency');

      await _openBox<PopularRestaurantReviewsResponse>('popularReviews');

      await _openBox<List<dynamic>>('popularItems');
      await _openBox<Item>('highestRatedItemsBox');
      await _openBox<RestaurantModel>('restaurantDetails');

      await _openBox<ItemModel>('restaurantItems');

      await _openBox<Restaurant>('nearbyRestaurantsBox');

      await _openBox<History>('restaurantsSearchHistory');
      await _openBox<History>('itemsSearchHistory');

      await _openBox<ItemCategory>('itemCategoryListBox');

      //* preferred theme mode
      await _openBox<String>('mode');
      //* push Notifications token

      //*location information for background processing tasks
      await _openBox<double?>('locationBox');
      checkUnopenedBoxes();
    } catch (e) {
      debugPrint('Error initializing Hive: $e');
      // await clear();
    }
  }

  static void checkUnopenedBoxes() {
    final boxNames = [
      'detail',
      'local_analytics',
      'user_sessions',
      'userBox',
      'itemCategoryListBox',
      'highestRatedItemsBox',
      'popularReviews',
      'popularItems',
      'restaurantDetails',
      'restaurantItems',
      'nearbyRestaurantsBox',
      'restaurantsSearchHistory',
      'itemsSearchHistory',
      'appLaunchState',
      'language',
      'mode',
      'fcmTokenBox',
      'locationBox',
      'currency',
    ];

    for (var boxName in boxNames) {
      if (!Hive.isBoxOpen(boxName)) {
        log('Box $boxName was not opened during initialization');
      }
    }
  }

  static Future<void> _deleteBoxFromDiskSafe(String name) async {
    try {
      if (Hive.isBoxOpen(name)) {
        await Hive.box(name).close();
      }
    } catch (_) {}

    try {
      await Hive.deleteBoxFromDisk(name);
      return;
    } catch (e) {
      debugPrint('Hive.deleteBoxFromDisk("$name") failed: $e');
    }

    try {
      final appDir = await getApplicationDocumentsDirectory();
      for (final suffix in ['.hive', '.lock', '.hive.crc']) {
        final file = File(p.join(appDir.path, '$name$suffix'));
        if (await file.exists()) {
          await file.delete();
        }
      }
    } catch (e) {
      debugPrint('Manual Hive cleanup for "$name" failed: $e');
    }
  }

  static Future<void> _openBox<T>(String name) async {
    if (Hive.isBoxOpen(name)) return;

    try {
      await Hive.openBox<T>(name);
    } catch (e) {
      debugPrint('Hive box "$name" incompatible, clearing cache: $e');
      await _deleteBoxFromDiskSafe(name);
      await Hive.openBox<T>(name);
    }
  }

  Future<void> clear() async {
    // Clear all the Hive boxes that were opened during initialization
    await Hive.deleteBoxFromDisk('detail');
    await Hive.deleteBoxFromDisk('user_sessions');
    await Hive.deleteBoxFromDisk('local_analytics');
    await Hive.deleteBoxFromDisk('userBox');
    await Hive.deleteBoxFromDisk('restaurantsSearchHistory');
    await Hive.deleteBoxFromDisk('itemsSearchHistory');
    await Hive.deleteBoxFromDisk('appLaunchState');
    await Hive.deleteBoxFromDisk('language');
    await Hive.deleteBoxFromDisk('mode');
    await Hive.deleteBoxFromDisk('fcmTokenBox');
    await Hive.deleteBoxFromDisk('locationBox');
    await Hive.deleteBoxFromDisk('itemCategoryListBox');
    await Hive.deleteBoxFromDisk('restaurantDetails');
    await Hive.deleteBoxFromDisk('restaurantItems');
    await Hive.deleteBoxFromDisk('popularItems');
    await Hive.deleteBoxFromDisk('popularReviews');
    await Hive.deleteBoxFromDisk('highestRatedItemsBox');
    await Hive.deleteBoxFromDisk('nearbyRestaurantsBox');
    await Hive.deleteBoxFromDisk('currency');
  }

  String getFcmToken() {
    final fcmTokenBox = Hive.box<String>('fcmTokenBox');
    if (fcmTokenBox.isEmpty) {
      return "";
    }
    final fcmToken = fcmTokenBox.get('fcmToken');
    return fcmToken ?? "";
  }
}
