import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/core/widgets/custom_persistent_bottom_navbar.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/screens/candidate_restaurant_page.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/pages/item_result_page.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/pages/search_page.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/pages/discover_result_page.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/pages/change_user_location.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/pages/leaderboard.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/pages/live_search_page.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/pages/notifications_page.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/pages/capture_media_page.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/pages/nearby_item_search_page.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/pages/nearby_restaurant_search_page.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/gallery_display.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/pages/screens/restaurant_detail.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/pages/restaurant_menu.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/add_item_review_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/add_restaurant_review_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/edit_item_review_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/edit_restaurant_review_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/item_reviews_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/restaurant_reviews_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/send_draft_to_review_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/feedback_page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/languages.page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/privacy_page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/settings_page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/terms_and_conditions_page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/user_preferences_page.dart';
import 'package:rateeat_mobile/src/features/splash/presentation/pages/splash_screen.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/edit_profile.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/following_page.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/other_user_profile.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/pages.dart';

import '../../features/shared_media_review/presentation/pages/give_restaurant_review.dart';

//* Splash routes
@TypedGoRoute<SplashRoute>(
  name: AppRoutes.splash,
  path: "/splash",
)
class SplashRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    Map<String, dynamic>? notificationStatus =
        state.extra as Map<String, dynamic>?;

    return SplashScreen(
      notificationStatus: notificationStatus ?? {},
    );
  }
}

//* Onboarding route
@TypedGoRoute<OnboardingRoute>(
  name: AppRoutes.onboarding,
  path: "/onboarding",
)
class OnboardingRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const OnboardingScreen();
}

//* Authentication routes
@TypedGoRoute<LoginRoute>(
  name: AppRoutes.login,
  path: "/login",
)
class LoginRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    Map<String, dynamic>? previousRouteInfo =
        state.extra as Map<String, dynamic>?;
    return LoginPage(
      previousRouteInfo: previousRouteInfo ?? {},
    );
  }
}

@TypedGoRoute<OtpRoute>(
  name: AppRoutes.otpPage,
  path: "/otpPage",
)
class OtpRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    Map<String, dynamic> routeInfo = state.extra as Map<String, dynamic>;
    return OtpPage(
      previousRouteInfo: routeInfo,
    );
  }
}

@TypedGoRoute<SignUpRoute>(
  name: AppRoutes.signUp,
  path: "/signUp",
)
class SignUpRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    Map<String, dynamic>? previousRouteInfo =
        state.extra as Map<String, dynamic>?;
    return ProfileCreatePage(
      previousRouteInfo: previousRouteInfo ?? {},
    );
  }
}

//* Home Page route
@TypedGoRoute<HomeRoute>(
  name: AppRoutes.home,
  path: "/",
  routes: <TypedGoRoute<GoRouteData>>[
    //* Discover routes
    TypedGoRoute<DiscoverRoute>(
      name: AppRoutes.discover,
      path: "discover",
      routes: [
        TypedGoRoute<MapPageRoute>(
          name: AppRoutes.locationOnMap,
          path: "locationOnMap",
          routes: [
            TypedGoRoute<SelectCategoryRoute>(
              name: AppRoutes.selectFoodCategory,
              path: '/selectFoodTags',
              routes: [],
            ),
            TypedGoRoute<DiscoverResultRoute>(
              name: AppRoutes.discoverRestaurantResult,
              path: "discoverRestaurantResult",
              routes: [],
            ),
          ],
        ),
        TypedGoRoute<DiscoverItemRoute>(
          name: AppRoutes.searchRestaurantPage,
          path: "searchRestaurantPage",
          routes: [
            TypedGoRoute<ItemResultRoute>(
              name: AppRoutes.itemResultPage,
              path: "/itemResult",
              routes: [],
            ),
          ],
        ),
      ],
    ),
    TypedGoRoute<QuickReviewCaptureRoute>(
      name: AppRoutes.quickAddReviewFileSelect,
      path: "/quickAddReviewFileSelect",
      routes: [
        TypedGoRoute<QuickReviewGalleryRoute>(
          name: AppRoutes.quickAddGallery,
          path: "/gallery",
          routes: [
            TypedGoRoute<QuickReviewRestaurantRoute>(
              name: AppRoutes.quickAddReviewRestaurantSelect,
              path: "/quickAddReviewRestaurantPage",
              routes: [
                TypedGoRoute<QuickReviewRestaurantItemsRoute>(
                  name: AppRoutes.quickAddItemSelect,
                  path: "/quickAddItemSelect",
                  routes: [],
                ),
              ],
            ),
          ],
        ),
      ],
    ),
    TypedGoRoute<SearchRoute>(
      name: AppRoutes.searchPage,
      path: "searchResult",
      routes: [
        TypedGoRoute<LiveSearchRoute>(
          name: AppRoutes.liveSearchPage,
          path: "/search",
          routes: [],
        ),
      ],
    ),
    TypedGoRoute<ProfileRoute>(
      name: AppRoutes.profile,
      path: "profile",
      routes: [
        TypedGoRoute<OthersProfileRoute>(
          name: AppRoutes.othersProfilePage,
          path: ":userId",
          routes: [],
        ),
        TypedGoRoute<EditProfileRoute>(
          name: AppRoutes.editProfile,
          path: "edit",
          routes: [],
        ),
      ],
    ),
    //* Settings
    TypedGoRoute<SettingRoute>(
      name: AppRoutes.settingsPage,
      path: "/settings",
      routes: [
        TypedGoRoute<LanguageRoute>(
          name: AppRoutes.languagePage,
          path: "/languages",
          routes: [],
        ),
        TypedGoRoute<UserPreferencesRoute>(
          name: AppRoutes.userPreferencesPage,
          path: "/userPreferences",
          routes: [],
        ),
        TypedGoRoute<TermsAndConditionsRoute>(
          name: AppRoutes.termsPage,
          path: "/terms",
          routes: [],
        ),
        TypedGoRoute<PrivacyRoute>(
          name: AppRoutes.privacyPage,
          path: "/privacy",
          routes: [],
        ),
        TypedGoRoute<NotificationsRoute>(
          name: AppRoutes.notificationPage,
          path: "/notifications",
          routes: [],
        ),
        TypedGoRoute<ConnectedAccountsRoute>(
          name: AppRoutes.connectedAccounts,
          path: "/connectedAccounts",
          routes: [],
        ),
        TypedGoRoute<FeedBackRoute>(
          name: AppRoutes.giveFeedbackPage,
          path: "/feedbackPage",
          routes: [],
        ),
      ],
    ),
    TypedGoRoute<LeaderBoardRoute>(
      name: AppRoutes.leaderBoardPage,
      path: "/leaderBoardPage",
      routes: [],
    ),
    TypedGoRoute<SendSavedReviewRoute>(
      name: AppRoutes.sendSavedReview,
      path: "/sendSavedReview",
      routes: [],
    ),
  ],
)
//* Change Location
@TypedGoRoute<SearchLocationRoute>(
  name: AppRoutes.searchLocation,
  path: '/selectLocation',
  routes: [
    TypedGoRoute<ChangeLocationRoute>(
      name: AppRoutes.changeUserLocation,
      path: '/changeCurrentLocation',
      routes: [],
    )
  ],
)
//* Item Routes routes
@TypedGoRoute<ItemDetailRoute>(
  name: AppRoutes.itemDetail,
  path: "items/:itemId",
  routes: [
    TypedGoRoute<RelatedItemRoute>(
      name: AppRoutes.relatedItems,
      path: "related",
      routes: [],
    ),
    TypedGoRoute<ItemReviewsRoute>(
      name: AppRoutes.itemReviews,
      path: "reviews",
      routes: [
        TypedGoRoute<AddItemReviewsRoute>(
          name: AppRoutes.addItemReview,
          path: "add",
          routes: [],
        ),
        TypedGoRoute<EditItemReviewsRoute>(
          name: AppRoutes.editItemReview,
          path: ":reviewId/edit",
          routes: [],
        ),
      ],
    ),
  ],
)
@TypedGoRoute<RestaurantDetailRoute>(
  name: AppRoutes.restaurantDetail,
  path: "restaurant/:restaurantId",
  routes: [
    TypedGoRoute<RestaurantMenuRoute>(
      name: AppRoutes.restaurantMenu,
      path: 'restaurantMenu',
      routes: [],
    ),
    TypedGoRoute<RestaurantReviewsRoute>(
      name: AppRoutes.restaurantReviews,
      path: "reviews",
      routes: [
        TypedGoRoute<AddRestaurantReviewsRoute>(
          name: AppRoutes.addRestaurantReview,
          path: "add",
          routes: [],
        ),
        TypedGoRoute<EditRestaurantReviewsRoute>(
          name: AppRoutes.editRestaurantReview,
          path: ":reviewId/edit",
          routes: [],
        ),
      ],
    ),
  ],
)
@TypedGoRoute<CandidateRestaurantRoute>(
  name: AppRoutes.candidateRestaurantPage,
  path: "/candidateRestaurantPage",
)
@TypedGoRoute<VerifyEmailRoute>(
  name: AppRoutes.verifyEmail,
  path: "/verifyEmail",
)
@TypedGoRoute<VerifyPhoneRoute>(
  name: AppRoutes.verifyPhone,
  path: "/verifyPhone",
)
class HomeRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CustomPersistentBottomNavBar();
}

class DiscoverRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DiscoverScreen();
}

class MapPageRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LocationOnMap();
}

class SelectCategoryRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SelectFoodCategoryScreen();
}

class DiscoverResultRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const DiscoverResultPage();
}

class DiscoverItemRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SearchRestaurantPage();
}

class ItemResultRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ItemResultPage();
}

//* Search Routes
class SearchRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SearchResultPage();
}

class LiveSearchRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LiveSearchPage();
}

//* Profile Related Routes
class ProfileRoute extends GoRouteData {
  final String userId;
  ProfileRoute({required this.userId});

  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const UserProfile();
  }
}

class EditProfileRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final UserModel userModel = state.extra as UserModel;
    return EditProfilePage(
      userModel: userModel,
    );
  }
}

class FollowRoute extends GoRouteData {
  final String userId;
  final String name;
  FollowRoute({required this.userId, required this.name});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return FollowingPage(
      userId: userId,
      name: name,
    );
  }
}

class OthersProfileRoute extends GoRouteData {
  final String userId;
  OthersProfileRoute({required this.userId});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    // final String userId = state.pathParameters['userId'] as String;

    return OthersProfilePage(userId: userId);
  }
}

//* Location Change
class SearchLocationRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      LocationSearchPage();
}

class ChangeLocationRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const ChangeUserLocationScreen();
}

//* Item Routes
class ItemDetailRoute extends GoRouteData {
  final String itemId;
  final Map<String, dynamic> extras;
  final ItemModel? item;
  final String? loginRedirection;

  ItemDetailRoute({
    required this.itemId,
    required this.extras,
    this.item,
    this.loginRedirection,
  });
  @override
  Widget build(BuildContext context, GoRouterState state) {
    //  final String itemId = state.pathParameters['itemId'] as String;
    //       final Map<String, dynamic> routeParams =
    //           state.extra != null ? state.extra as Map<String, dynamic> : {};
    //       final ItemModel? item =
    //           routeParams.isNotEmpty ? routeParams['item'] as ItemModel : null;
    //       String? loginRedirection = routeParams['loginRedirection'];
    return ItemDetail(
      itemId: itemId,
      item: item,
      loginRedirection: loginRedirection,
    );
  }
}

class RelatedItemRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final String itemId = state.pathParameters['itemId'] as String;
    final Map<String, dynamic> routeParams =
        state.extra != null ? state.extra as Map<String, dynamic> : {};
    final ItemModel? item =
        routeParams.isNotEmpty ? routeParams['item'] as ItemModel : null;
    String? loginRedirection = routeParams['loginRedirection'];

    return ItemDetail(
      itemId: itemId,
      item: item,
      loginRedirection: loginRedirection,
    );
  }
}

class ItemReviewsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final Map<String, dynamic> routeParams =
        state.extra as Map<String, dynamic>;
    var item = routeParams['item'];
    var loginRedirection = routeParams['loginRedirection'];
    return ItemReviewsPage(
      item: item,
      loginRedirection: loginRedirection,
    );
  }
}

class AddItemReviewsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    // final String itemId = state.pathParameters['itemId'] as String;
    final Map<String, dynamic> routeParams =
        state.extra != null ? state.extra as Map<String, dynamic> : {};
    var item = routeParams['item'];
    var loginRedirection = routeParams['loginRedirection'];
    return AddItemReviewPage(
      item: item,
      loginRedirection: loginRedirection,
    );
  }
}

class EditItemReviewsRoute extends GoRouteData {
  final dynamic reviewContent;
  final ItemModel item;
  final String? reviewId;

  EditItemReviewsRoute(
      {required this.reviewContent, required this.item, this.reviewId});
  @override
  Widget build(BuildContext context, GoRouterState state) {
    // final String itemId = state.pathParameters['itemId'] as String;
    // final String reviewId = state.pathParameters['reviewId'] as String;
    // final Map<String, dynamic> routeParams =
    //     state.extra as Map<String, dynamic>;
    // var item = routeParams['item'];
    // var reviewContent = routeParams['reviewContent'];
    return EditItemReviewPage(
      item: item,
      reviewContent: reviewContent,
    );
  }
}

//* Restaurant Routes
class RestaurantDetailRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final String restaurantId = state.pathParameters['restaurantId'] as String;
    final routeParams =
        state.extra != null ? state.extra as Map<String, dynamic> : {};
    String? loginRedirection = routeParams['loginRedirection'];
    return RestaurantDetail(
      hasQuery: state.uri.hasQuery,
      restaurantId: restaurantId,
      loginRedirection: loginRedirection,
    );
  }
}

class RestaurantMenuRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final Restaurant restaurant = state.extra as Restaurant;
    return RestaurantMenu(restaurant: restaurant);
  }
}

class RestaurantReviewsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    // final String itemId = state.pathParameters['restaurantId'] as String;
    final Map<String, dynamic> routeParams =
        state.extra as Map<String, dynamic>;
    var restaurant = routeParams['restaurant'];
    var loginRedirection = routeParams['loginRedirection'];

    return RestaurantReviewsPage(
      restaurant: restaurant,
      loginRedirection: loginRedirection,
    );
  }
}

class AddRestaurantReviewsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    // final String restaurantId =
    //     state.pathParameters['restaurantId'] as String;
    final Map<String, dynamic> routeParams =
        state.extra != null ? state.extra as Map<String, dynamic> : {};
    var restaurant = routeParams['restaurant'];
    var loginRedirection = routeParams['loginRedirection'];

    return AddRestaurantReviewPage(
      restaurant: restaurant,
      loginRedirection: loginRedirection,
    );
  }
}

class EditRestaurantReviewsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    // final String restaurantId =
    //     state.pathParameters['restaurantId'] as String;
    // final String reviewId =
    //     state.pathParameters['reviewId'] as String;
    final Map<String, dynamic> routeParams =
        state.extra as Map<String, dynamic>;
    var restaurant = routeParams['restaurant'];
    var reviewContent = routeParams['reviewContent'];
    return EditRestaurantReviewPage(
      restaurant: restaurant,
      reviewContent: reviewContent,
    );
  }
}

//* Settings Routes
class SettingRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const SettingsPage();
}

class LanguageRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const LanguagesPage();
}

class UserPreferencesRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const UserPreferencesPage();
}

class TermsAndConditionsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const TermsAndConditionsPage();
}

class PrivacyRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const PrivacyPage();
}

class NotificationsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    Map<String, dynamic>? extraParams = state.extra as Map<String, dynamic>?;
    LocalUserModel? user = extraParams != null ? extraParams['user'] : null;
    return NotificationPage(
      user: user,
    );
  }
}

class ConnectedAccountsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NotificationPage();
}

class FeedBackRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const FeedbackPage();
}

class LeaderBoardRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    return const LeaderBoard();
  }
}

//* Quick Review
class QuickReviewCaptureRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const CaptureMediaPage();
}

class QuickReviewRestaurantRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NearByRestaurantSearchPage();
}

class QuickReviewRestaurantItemsRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const NearByItemSearchPage();
}

class SendSavedReviewRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final Map<String, dynamic> routeParams =
        state.extra as Map<String, dynamic>;
    var reviewContent = routeParams['reviewContent'];
    return SendDraftToReviewPage(
      reviewContent: reviewContent,
    );
  }
}

class QuickReviewGalleryRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      const GalleryPage();
}

//* Candidate Restaurant Route
class CandidateRestaurantRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) =>
      CandidateRestaurantPage();
}

class VerifyEmailRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final Map<String, dynamic> routeParams =
        state.extra as Map<String, dynamic>;
    return VerifyEmailPage(
      user: routeParams['user'],
    );
  }
}

class VerifyPhoneRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final Map<String, dynamic> routeParams =
        state.extra as Map<String, dynamic>;
    return VerifyPhonePage(
      user: routeParams['user'],
    );
  }
}

//* Search restaurant Route
class SearchRestaurantRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    // final Map<String, dynamic> routeParams =
    //     state.extra as Map<String, dynamic>;
    return const SearchRestaurantPage();
  }
}

//* Restaurant review from shared media
class RestaurantReviewRoute extends GoRouteData {
  @override
  Widget build(BuildContext context, GoRouterState state) {
    final Map<String, dynamic> routeParams =
        state.extra as Map<String, dynamic>;
    return GiveRestaurantReview(
      restaurantId: routeParams['restaurantId'],
    );
  }
}
