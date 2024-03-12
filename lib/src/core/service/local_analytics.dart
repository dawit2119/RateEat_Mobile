import 'package:flutter/material.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/details_analytics_data.dart';
import 'package:rateeat_mobile/src/core/hive/session_track.dart';
import 'package:rateeat_mobile/src/core/hive/user_engagement_analytics.dart';

class LocalAnalyticsObserver extends NavigatorObserver {
  final _analyticsBox = Hive.box<DetailsAnalyticsData>("detail");
  final _userEngagementBox =
      Hive.box<UserEngagementAnalytics>("local_analytics");
  final _sessionTrackBox = Hive.box<UserSession>("user_sessions");
  @override
  void didPush(Route<dynamic> route, Route<dynamic>? previousRoute) {
    _sendScreenView(route: route);
  }

  //* Clear All Analytics
  Future<void> clearSessionAnalyticsData() {
    final u = _userEngagementBox.delete("local_analytics");
    _analyticsBox.clear();
    // _sessionTrackBox.delete("session");
    _sessionTrackBox.clear();
    return u;
  }

  //* Session Tracker
  UserSession? getSessionTrack() {
    final data = _sessionTrackBox.get("session");
    return data ??
        UserSession(
          startTime: DateTime.now(),
          sessionStartDate: DateTime.now(),
        );
  }

  //* Screen View Analytics (USer Engagement)
  UserEngagementAnalytics? getUserEngagementAnalytics() {
    final data = _userEngagementBox.get("local_analytics");
    return data ?? UserEngagementAnalytics();
  }

  Future<void> updateUserEngagementAnalytics(
      {required UserEngagementAnalytics update}) {
    try {
      final screens = _userEngagementBox.get("local_analytics");
      if (screens != null) {
        return _userEngagementBox.put(
            "local_analytics",
            screens.copyWith(
              homepage: update.homepage,
              discoverRestaurant: update.discoverRestaurant,
              discoverItem: update.discoverItem,
              quickReview: update.quickReview,
              searchPage: update.searchPage,
              leaderBoard: update.leaderBoard,
              itemReview: update.itemReview,
              restaurantReviews: update.restaurantReviews,
              itemShare: update.itemShare,
              restaurantShare: update.restaurantShare,
              itemSearchPage: update.itemSearchPage,
              restaurantSearchPage: update.restaurantSearchPage,
            ));
      } else {
        return _userEngagementBox.put("local_analytics", update);
      }
    } catch (e) {
      throw CacheFailure();
    }
  }

  //* Item Detail Analytics
  DetailsAnalyticsData? getItemAnalytics() {
    final data = _analyticsBox.get("items");
    return data ?? DetailsAnalyticsData(eventName: "items", eventData: {});
  }

  Future<void> updateItemAnalytics({required Map<String, dynamic> params}) {
    try {
      final itemsVisited = _analyticsBox.get("items");
      if (itemsVisited != null) {
        final lst = itemsVisited.eventData;
        lst.add(params['item_id']);
        return _analyticsBox.put(
            "items", itemsVisited.copyWith(eventData: lst));
      } else {
        final newLog = DetailsAnalyticsData(
            eventName: "items", eventData: {params['item_id']});
        return _analyticsBox.put("items", newLog);
      }
    } catch (e) {
      throw CacheException();
    }
  }

  //* Restaurant Detail Analytics
  DetailsAnalyticsData? getRestaurantAnalytics() {
    final data = _analyticsBox.get("restaurants");
    return data ??
        DetailsAnalyticsData(eventName: "restaurants", eventData: {});
  }

  Future<void> updateRestaurantAnalytics(
      {required Map<String, dynamic> params}) {
    try {
      final restaurantsVisited = _analyticsBox.get("restaurants");
      if (restaurantsVisited != null) {
        final lst = restaurantsVisited.eventData;
        lst.add(params['restaurant_id']);
        return _analyticsBox.put(
            "restaurants", restaurantsVisited.copyWith(eventData: lst));
      } else {
        final newLog = DetailsAnalyticsData(
            eventName: "restaurants", eventData: {params['restaurant_id']});
        return _analyticsBox.put("restaurants", newLog);
      }
    } catch (e) {
      throw CacheException();
    }
  }

  //* Restaurant Search Analytics
  DetailsAnalyticsData? getRestaurantSearchAnalytics() {
    final data = _analyticsBox.get("restaurantSearches");
    return data ??
        DetailsAnalyticsData(eventName: "restaurantSearches", eventData: {});
  }

  Future<void> updateRestaurantSearchAnalytics(
      {required Map<String, dynamic> params}) {
    try {
      final searchedRestaurant = _analyticsBox.get("restaurantSearches");
      if (searchedRestaurant != null) {
        final lst = searchedRestaurant.eventData;
        lst.add(params['searched_word']);
        return _analyticsBox.put(
            "restaurantSearches", searchedRestaurant.copyWith(eventData: lst));
      } else {
        final newLog = DetailsAnalyticsData(
            eventName: "restaurantSearches",
            eventData: {params['searched_word']});
        return _analyticsBox.put("restaurantSearches", newLog);
      }
    } catch (e) {
      throw CacheException();
    }
  }

  //* Item Search Analytics
  DetailsAnalyticsData? getItemSearchAnalytics() {
    final data = _analyticsBox.get("itemSearches");
    return data ??
        DetailsAnalyticsData(eventName: "itemSearches", eventData: {});
  }

  Future<void> updateItemSearchAnalytics(
      {required Map<String, dynamic> params}) {
    try {
      final searchedItem = _analyticsBox.get("itemSearches");
      if (searchedItem != null) {
        final lst = searchedItem.eventData;
        lst.add(params['searched_word']);
        return _analyticsBox.put(
            "itemSearches", searchedItem.copyWith(eventData: lst));
      } else {
        final newLog = DetailsAnalyticsData(
            eventName: "itemSearches", eventData: {params['searched_word']});
        return _analyticsBox.put("itemSearches", newLog);
      }
    } catch (e) {
      throw CacheException();
    }
  }

  //* Restaurant Share Analytics
  DetailsAnalyticsData? getRestaurantShareAnalytics() {
    final data = _analyticsBox.get("restaurantShares");
    return data ??
        DetailsAnalyticsData(eventName: "restaurantShares", eventData: {});
  }

  Future<void> updateRestaurantShareAnalytics(
      {required Map<String, dynamic> params}) {
    try {
      final sharedRestaurant = _analyticsBox.get("restaurantShares");
      if (sharedRestaurant != null) {
        final lst = sharedRestaurant.eventData;
        lst.add(params['shared_restaurant']);
        return _analyticsBox.put(
            "restaurantShares", sharedRestaurant.copyWith(eventData: lst));
      } else {
        final newLog = DetailsAnalyticsData(
            eventName: "restaurantShares",
            eventData: {params['shared_restaurant']});
        return _analyticsBox.put("restaurantShares", newLog);
      }
    } catch (e) {
      throw CacheException();
    }
  }

  //* Item Share Analytics
  DetailsAnalyticsData? getItemShareAnalytics() {
    final data = _analyticsBox.get("itemShares");
    return data ?? DetailsAnalyticsData(eventName: "itemShares", eventData: {});
  }

  Future<void> updateItemShareAnalytics(
      {required Map<String, dynamic> params}) {
    try {
      final sharedItem = _analyticsBox.get("itemShares");
      if (sharedItem != null) {
        final lst = sharedItem.eventData;
        lst.add(params['shared_item']);
        return _analyticsBox.put(
            "itemShares", sharedItem.copyWith(eventData: lst));
      } else {
        final newLog = DetailsAnalyticsData(
            eventName: "itemShares", eventData: {params['shared_item']});
        return _analyticsBox.put("itemShares", newLog);
      }
    } catch (e) {
      throw CacheException();
    }
  }

  //* Screen Logger
  Future<void> _sendScreenView({required Route<dynamic> route}) async {
    final String? screenName = route.settings.name;
    UserEngagementAnalytics userEngagement = UserEngagementAnalytics();
    if (screenName != null) {
      if (screenName == AppRoutes.discoverRestaurantResult) {
        userEngagement.discoverRestaurant = 1;
      } else if (screenName == AppRoutes.searchRestaurantPage) {
        userEngagement.discoverItem = 1;
      } else if (screenName == AppRoutes.quickAddItemSelect) {
        userEngagement.quickReview = 1;
      } else if (screenName == AppRoutes.leaderBoardPage) {
        userEngagement.leaderBoard = 1;
      } else if (screenName == AppRoutes.itemReviews) {
        userEngagement.itemReview = 1;
      } else if (screenName == AppRoutes.restaurantReviews) {
        userEngagement.restaurantReviews = 1;
      }
      await updateUserEngagementAnalytics(update: userEngagement);
    }
  }
}
