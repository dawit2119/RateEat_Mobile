import 'dart:async';
import 'dart:io';
import 'package:dio/dio.dart';
import 'package:hive/hive.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/language/language_bloc.dart';
import 'package:rateeat_mobile/src/core/service/local_analytics.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/background_processing/data/send_location_provider.dart';
import 'package:uuid/uuid.dart';
import 'dart:math';

import '../../discover/discover.dart';

Future<void> locationChangeNotifier(
    {required LocationModel currentLocation}) async {
  try {
    final box = Hive.box<double?>('locationBox');
    double? lastLat = box.get('lastLat');
    double? lastLng = box.get('lastLng');

    if (lastLng != null) {
      double distanceInMeters = calculateDistance(
            lastLat!,
            lastLng,
            currentLocation.latitude,
            currentLocation.longitude,
          ) *
          1000;
      if (distanceInMeters >= 3000) {
        final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
        if (user != null) {
          await SendLocationDataSource().sendLocation(
            lat: currentLocation.latitude,
            long: currentLocation.longitude,
          );
        }
      }
    }
    // Update the last known location in Hive
    await box.put('lastLat', currentLocation.latitude);
    await box.put('lastLng', currentLocation.longitude);
  } catch (e) {
    return Future.error("Failed to start background processing");
  }
}

double calculateDistance(double lat1, double lon1, double lat2, double lon2) {
  var earthRadiusKm = 6371;
  var dLat = _degreesToRadians(lat2 - lat1);
  var dLon = _degreesToRadians(lon2 - lon1);
  lat1 = _degreesToRadians(lat1);
  lat2 = _degreesToRadians(lat2);
  var a = sin(dLat / 2) * sin(dLat / 2) +
      sin(dLon / 2) * sin(dLon / 2) * cos(lat1) * cos(lat2);
  var c = 2 * atan2(sqrt(a), sqrt(1 - a));
  return earthRadiusKm * c;
}

double _degreesToRadians(double degrees) {
  return degrees * pi / 180;
}

//* Send Analytics Data
// A function to send data
Future<bool> sendAnalyticsData() async {
  final Dio dio = dpLocator<Dio>();
  final sessionId = const Uuid().v1();

  try {
    //* The Authorized  User
    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
    //*User Engagement Data
    final userEngagement =
        dpLocator<LocalAnalyticsObserver>().getUserEngagementAnalytics();
    final itemAnalyticsData =
        dpLocator<LocalAnalyticsObserver>().getItemAnalytics();

    final restaurantAnalyticsData =
        dpLocator<LocalAnalyticsObserver>().getRestaurantAnalytics();
    final sessionTrack = dpLocator<LocalAnalyticsObserver>().getSessionTrack();
    final languagePref = LanguageBloc().state.selectedLanguage.text;
    final itemShareAnalyticsData =
        dpLocator<LocalAnalyticsObserver>().getItemShareAnalytics();
    final restaurantShareAnalyticsData =
        dpLocator<LocalAnalyticsObserver>().getRestaurantShareAnalytics();

    var headers = {
      'Content-Type': 'application/json',
      'Accept': 'application/json',
    };
    if (user != null) {
      headers.addEntries([
        MapEntry('Authorization', 'Bearer ${user.token}'),
      ]);
    }
    final body = {
      "user": {
        'user_id': user!.id,
      },
      "user_session": {
        "device_type": Platform.isAndroid ? "Android" : "iOS",
        "session_id": sessionId,
        'session_start_date': sessionTrack!.sessionStartDate.toUtc().toString(),
        'time_spent': sessionTrack.totalSessionTime,
        'language': languagePref,
      },
      "user_feature": {
        "homepage": userEngagement!.homepage,
        "discover_restaurant": userEngagement.discoverRestaurant,
        "discover_item": userEngagement.discoverItem,
        "quick_review": userEngagement.quickReview,
        "leaderboard": userEngagement.leaderBoard,
        "item_reviews": userEngagement.itemReview,
        "restaurant_reviews": userEngagement.restaurantReviews,
        "item_share": userEngagement.itemShare,
        "restaurant_share": userEngagement.restaurantShare,
        "item_search": userEngagement.itemSearchPage,
        "restaurant_search": userEngagement.restaurantSearchPage,
      },
      "user_item": itemAnalyticsData!.eventData.toList(),
      "user_restaurant": restaurantAnalyticsData!.eventData.toList(),
      "item_share": itemShareAnalyticsData!.eventData.toList(),
      "restaurant_share": restaurantShareAnalyticsData!.eventData.toList(),
    };

    final response = await dio.post(
      // 'https://22db-102-218-51-161.ngrok-free.app/api/v1/userEngagement/analytics/record',
      '$baseURL/userEngagement/analytics/record',
      data: body,
      options: Options(headers: headers),
    );
    if (response.statusCode == 200) {
      return true;
    } else if (response.statusCode == 201) {
      return true;
    } else {
      return false;
    }
  } catch (e) {
    return false;
  }
}
