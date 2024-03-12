import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/screens/candidate_restaurant_page.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/pages/leaderboard.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/pages/nearby_item_search_page.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/pages/nearby_restaurant_search_page.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/pages/capture_media_page.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/gallery_display.dart';
import 'package:rateeat_mobile/src/features/order/presentation/widgets/payment_webview.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/pages/restaurant_menu.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/add_item_review_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/add_restaurant_review_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/edit_item_review_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/edit_restaurant_review_page.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/pages/live_search_page.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/pages/screens/restaurant_detail.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/item_reviews_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/restaurant_reviews_page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/currency_page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/feedback_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/send_draft_to_review_page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/languages.page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/privacy_page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/settings_page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/terms_and_conditions_page.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/pages/user_preferences_page.dart';
import 'package:rateeat_mobile/src/features/splash/presentation/pages/splash_screen.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/following_page.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/other_user_profile.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/pages.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/pages/search_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';

import '../../features/discover_item/presentation/pages/item_result_page.dart';
import '../../features/discover_restaurant_result/presentation/pages/discover_result_page.dart';
import '../../features/features.dart';
import '../../features/homepage/presentation/pages/change_user_location.dart';
import '../../features/order/presentation/pages/cart_page.dart';
import '../../features/order/presentation/pages/order_status_page.dart';
import '../../features/order/presentation/pages/select_orders_page.dart';
import '../../features/order/presentation/widgets/order_item_detail.dart';
import '../../features/shared_media_review/presentation/pages/give_food_review.dart';
import '../../features/shared_media_review/presentation/pages/give_restaurant_review.dart';
import '../../features/shared_media_review/presentation/pages/search_food_page.dart';
import '../../features/shared_media_review/presentation/pages/search_restaurant_page.dart';
import '../../features/user_profile/presentation/pages/edit_profile.dart';
import '../../features/notification/presentation/pages/pages.dart';

import '../widgets/custom_persistent_bottom_navbar.dart';
import '../widgets/test_page.dart';

class AppRoutes {
  //* Test route
  static const String test = "test";
  //* Splash route
  static const String splash = "splash";
  //* Onboarding route
  static const String onboarding = "onboarding";
  //* Authentication routes
  static const String login = 'login';
  static const String otpPage = 'otpPage';
  static const String signUp = 'signUp';
  //* Profile routes
  static const String profile = 'myProfile';
  static const String editProfile = "editProfile";
  static const String verifyEmail = "verifyEmail";
  static const String verifyPhone = "verifyPhone";
  static const String followingPage = 'followingpage';

  //* See others profile page
  static const String othersProfilePage = 'othersProfilePage';
  // * Home Page route
  static const String home = 'home';
  //* Discover routes
  static const String discover = 'discover';
  //* discover restaurant routes
  static const String locationOnMap = 'LocationOnMap';
  static const String searchLocation = 'selectLocation';
  static const String selectFoodCategory = "selectFoodTags";
  static const String discoverRestaurantResult = "discoverRestaurantResult";
  //* Discover items routes
  static const String searchRestaurantPage = 'searchRestaurantPage';
  //? Change User Location
  static const String changeUserLocation = "changeUserLocation";
  //* Search routes
  static const String searchPage = "searchResult";
  static const String liveSearchPage = 'liveSearch';

  // * Search Result Page
  static const String restaurantResultPage = 'restaurantResult';
  static const String itemResultPage = 'itemResults';

  //* General Currency
  static const String currencyPage = '/currency';
  //* Item Detail Page
  static const String itemDetail = 'itemDetail';
  static const String orderItemDetail = 'orderItemDetail';
  static const String relatedItems = 'relatedItems';

  //* Ordering
  static const String cartPage = 'cartPage';
  static const String orderStatusPage = 'orderStatusPage';
  static const String confirmPaymentWebView = 'confirmPaymentWebView';

  //* Restaurant Detail Page
  static const String restaurantDetail = 'restaurantDetail';
  static const String restaurantMenu = "restaurantMenu";
  //* Detail Pages Review
  //* Item Reviews
  static const String itemReviews = "itemReviews";
  static const String addItemReview = "addItemReview";
  static const String editItemReview = "editItemReview";
  //* Restaurants Reviews
  static const String restaurantReviews = "restaurantReviews";
  static const String addRestaurantReview = "addRestaurantReview";
  static const String editRestaurantReview = "editRestaurantReview";

  //* Settings Route
  static const String settingsPage = "settings";
  //* Change Languages Route
  static const String languagePage = "languages";
  //* Change user preference
  static const String userPreferencesPage = "userPreferences";
  //* Connected Accounts
  static const String connectedAccounts = "connectedAccounts";
  //* Terms and Conditions Route
  static const String termsPage = "terms";
  //* Privacy Route
  static const String privacyPage = "privacy";
  //* Notification Route
  static const String notificationPage = "notificationPage";
  //* quickAddItemSelect Gallery Route
  static const String quickAddGallery = "quickAddGallery";
  //* Quick add review Capture page.
  static const String quickAddReviewFileSelect = "quickAddReviewFileSelect";
  //* quickAddReviewRestaurantSelect route.
  static const String quickAddReviewRestaurantSelect =
      "quickAddReviewRestaurantSelect";
  //* quickAddItemSelect Route
  static const String quickAddItemSelect = "quickAddItemSelect";
  //* send Saved Review
  static const String sendSavedReview = "sendSavedReview";
  //
  static const String giveFeedbackPage = 'feedBackPage';

  static const String leaderBoardPage = 'leaderBoardPage';
  static const String candidateRestaurantPage = 'candidateRestaurantPage';
  //Orders page
  static const String selectOrdersPage = 'selectOrdersPage';
  //* Order History
  static const String orderHistory = 'orderHistory';
  static const String orderHistoryDetail = 'orderHistoryDetail';

  //* Review from shared media
  static const String searchRestaurant = 'searchRestaurant';
  static const String searchFood = 'searchFood';
  static const String restaurantReviewFromSharedMedia =
      'restaurantReviewFromSharedMedia';
  static const String foodReviewFromSharedMedia = 'foodReviewFromSharedMedia';

  //* QR Menu
  static const String qrMenuPage = 'qrMenuPage';
  static const String qrOrderPage = 'qrOrderPage';
  static const String qrOrderSummery = 'qrOrderSummery';
  static const String editQROrderPage = 'editQROrderPage';
  static const String editQROrderSummery = 'editQROrderSummery';
  static const String qrOrderStatusPage = 'qrOrderStatus';
}

//* Custom transition page
CustomTransitionPage buildPageWithDefaultTransition<T>({
  required BuildContext context,
  required GoRouterState state,
  required Widget child,
}) {
  return CustomTransitionPage<T>(
    key: state.pageKey,
    child: child,
    transitionsBuilder: (context, animation, secondaryAnimation, child) =>
        FadeTransition(opacity: animation, child: child),
  );
}

//* Default page builder
Page<dynamic> Function(BuildContext, GoRouterState) defaultPageBuilder<T>(
        Widget child) =>
    (BuildContext context, GoRouterState state) {
      return buildPageWithDefaultTransition<T>(
        context: context,
        state: state,
        child: child,
      );
    };

final routes = <GoRoute>[
  //* Test page(for testing purposes)
  GoRoute(
    name: AppRoutes.test,
    path: "/test",
    builder: (context, state) => const TestScreen(),
  ),
  //* Splash routes
  GoRoute(
      name: AppRoutes.splash,
      path: "/splash",
      builder: (BuildContext context, GoRouterState state) {
        Map<String, dynamic>? notificationStatus =
            state.extra as Map<String, dynamic>?;

        return SplashScreen(
          notificationStatus: notificationStatus ?? {},
        );
      }),
//* Onboarding route
  GoRoute(
    name: AppRoutes.onboarding,
    path: "/onboarding",
    builder: (context, state) => const OnboardingScreen(),
  ),

//* Authentication routes
  GoRoute(
    name: AppRoutes.login,
    path: "/login",
    builder: (BuildContext context, GoRouterState state) {
      Map<String, dynamic>? previousRouteInfo =
          state.extra as Map<String, dynamic>?;
      return LoginPage(
        previousRouteInfo: previousRouteInfo ?? {},
      );
    },
  ),
  //* Currency Page
  GoRoute(
    path: AppRoutes.currencyPage,
    name: AppRoutes.currencyPage,
    builder: (context, state) => const CurrencyPage(),
  ),
  GoRoute(
      name: AppRoutes.otpPage,
      path: "/otpPage",
      builder: (BuildContext context, GoRouterState state) {
        Map<String, dynamic> routeInfo = state.extra as Map<String, dynamic>;
        return OtpPage(
          previousRouteInfo: routeInfo,
        );
      }),
  GoRoute(
      name: AppRoutes.signUp,
      path: "/signUp",
      builder: (BuildContext context, GoRouterState state) {
        Map<String, dynamic>? previousRouteInfo =
            state.extra as Map<String, dynamic>?;
        return ProfileCreatePage(
          previousRouteInfo: previousRouteInfo ?? {},
        );
      }),

//* Home Page route
  GoRoute(
    name: AppRoutes.home,
    path: "/",
    builder: (BuildContext context, GoRouterState state) {
      // Map<String, dynamic>? routeParameters = state.extra as Map<String, dynamic>?;
      //    return BottomNavigation(
      //   initialPage: routeParameters != null && routeParameters['id'] != null
      //       ? routeParameters['id'] as int?
      //       : null,
      //   fromOtherPages: routeParameters != null && routeParameters['fromOtherPages'] != null
      //       ? routeParameters['fromOtherPages']
      //       : null,
      // );
      return const CustomPersistentBottomNavBar();
    },
    routes: [
      //* Discover routes
      GoRoute(
        name: AppRoutes.discover,
        path: "discover",
        builder: (BuildContext context, GoRouterState state) =>
            const DiscoverScreen(),
        routes: [
          GoRoute(
            name: AppRoutes.locationOnMap,
            path: "locationOnMap",
            builder: (BuildContext context, GoRouterState state) =>
                const LocationOnMap(),
            routes: [
              GoRoute(
                name: AppRoutes.discoverRestaurantResult,
                path: "discoverRestaurantResult",
                builder: (context, state) => const DiscoverResultPage(),
              ),
            ],
          ),
          GoRoute(
            name: AppRoutes.searchRestaurantPage,
            path: "searchRestaurantPage",
            builder: (BuildContext context, GoRouterState state) =>
                const SearchRestaurantPage(),
          ),
        ],
      ),
      //* Search routes
      GoRoute(
        name: AppRoutes.searchPage,
        path: "searchResult",
        builder: (BuildContext context, GoRouterState state) =>
            const SearchResultPage(),
      ),

      //* Profile routes
      GoRoute(
        name: AppRoutes.profile,
        path: "profile",
        builder: (BuildContext context, GoRouterState state) =>
            const UserProfile(),
        routes: [
          //* Edit Profile detail
          GoRoute(
            name: AppRoutes.editProfile,
            path: "edit",
            builder: (context, state) {
              final UserModel userModel = state.extra as UserModel;
              return EditProfilePage(
                userModel: userModel,
              );
            },
          ),
          //* See Others profile page
          GoRoute(
            name: AppRoutes.othersProfilePage,
            path: ":userId",
            builder: (BuildContext context, GoRouterState state) {
              final String userId = state.pathParameters['userId'] as String;
              return OthersProfilePage(userId: userId);
            },
          ),
          GoRoute(
            name: AppRoutes.followingPage,
            path: "following/:userId",
            builder: (BuildContext context, GoRouterState state) {
              final String userId = state.pathParameters['userId'] as String;
              final String name = state.extra as String;
              return FollowingPage(userId: userId, name: name);
            },
          ),
        ],
      ),
    ],
  ),

  //* Discover routes
  GoRoute(
    name: AppRoutes.searchLocation,
    path: '/selectLocation',
    pageBuilder: (context, state) {
      return CustomTransitionPage(
        key: state.pageKey,
        child: LocationSearchPage(),
        transitionsBuilder: (context, animation, secondaryAnimation, child) {
          return FadeTransition(
            opacity: CurveTween(curve: Curves.easeInOutCirc).animate(animation),
            child: child,
          );
        },
      );
    },
  ),
  GoRoute(
    name: AppRoutes.selectFoodCategory,
    path: '/selectFoodTags',
    builder: (BuildContext context, GoRouterState state) =>
        const SelectFoodCategoryScreen(),
  ),

//? Change User Location
  GoRoute(
    name: AppRoutes.changeUserLocation,
    path: '/changeCurrentLocation',
    builder: (context, state) => const ChangeUserLocationScreen(),
  ),

//* Search routes
  GoRoute(
      name: AppRoutes.liveSearchPage,
      path: "/search",
      builder: (BuildContext context, GoRouterState state) {
        return const LiveSearchPage();
      }),
  GoRoute(
    name: AppRoutes.restaurantResultPage,
    path: "/restaurantResult",
    builder: (BuildContext context, GoRouterState state) =>
        const SearchResultPage(),
  ),
  GoRoute(
    name: AppRoutes.itemResultPage,
    path: "/itemResult",
    builder: (BuildContext context, GoRouterState state) =>
        const ItemResultPage(),
  ),
  //Order Item Detail page
  GoRoute(
    name: AppRoutes.orderItemDetail,
    path: "/orderItemDetail",
    builder: (BuildContext context, GoRouterState state) {
      final extraParams = state.extra as Map<String, dynamic>;

      return OrderItemDetail(
        item: extraParams['item'],
        restaurant: extraParams['restaurant'],
        currencyCode: extraParams['currencyCode'],
      );
    },
  ),
  //Carts Page
  GoRoute(
    name: AppRoutes.cartPage,
    path: "/cartPage",
    builder: (BuildContext context, GoRouterState state) {
      final Restaurant restaurant = state.extra as Restaurant;
      return CartPage(
        restaurant: restaurant,
      );
    },
  ),
  //Order Status Page
  GoRoute(
    name: AppRoutes.orderStatusPage,
    path: "/orderStatusPage",
    builder: (BuildContext context, GoRouterState state) {
      Map<String, dynamic> extraParams = state.extra as Map<String, dynamic>;
      String? orderId = extraParams["order_id"];
      Restaurant restaurant = extraParams["restaurant"];
      return OrderStatusPage(
        orderId: orderId ?? "",
        restaurant: restaurant,
      );
    },
  ),

  //Payment WebView
  GoRoute(
    name: AppRoutes.confirmPaymentWebView,
    path: "/confirmPaymentWebView",
    builder: (BuildContext context, GoRouterState state) {
      final String redirectUrl = state.extra as String;
      return PaymentWebView(
        redirectUrl: redirectUrl,
      );
    },
  ),
  GoRoute(
    path: '/user/food-item/:itemId',
    redirect: (context, state) {
      final itemId = state.pathParameters['itemId']!;
      final query = state.uri.query; // preserve query parameters
      final newPath = '/items/$itemId${query.isNotEmpty ? '?$query' : ''}';
      return newPath;
    },
  ),

  //* Item Detail Page
  GoRoute(
    name: "items",
    path: "/items",
    builder: (BuildContext context, GoRouterState state) => Container(),
    routes: [
      //* Get Item Detail
      GoRoute(
        name: AppRoutes.itemDetail,
        path: ":itemId",
        builder: (BuildContext context, GoRouterState state) {
          final String itemId = state.pathParameters['itemId'] as String;
          final Map<String, dynamic> routeParams =
              state.extra != null ? state.extra as Map<String, dynamic> : {};
          final ItemModel? item =
              routeParams.isNotEmpty ? routeParams['item'] as ItemModel : null;
          String? loginRedirection = routeParams['loginRedirection'];

          return ItemDetail(
            hasQuery: state.uri.hasQuery,
            itemId: itemId,
            item: item,
            loginRedirection: loginRedirection,
          );
        },
        //* Get Items Reviews
        routes: [
          GoRoute(
            name: AppRoutes.relatedItems,
            path: "related",
            builder: (BuildContext context, GoRouterState state) {
              final String itemId = state.pathParameters['itemId'] as String;
              final Map<String, dynamic> routeParams = state.extra != null
                  ? state.extra as Map<String, dynamic>
                  : {};
              final ItemModel? item = routeParams.isNotEmpty
                  ? routeParams['item'] as ItemModel
                  : null;
              String? loginRedirection = routeParams['loginRedirection'];

              return ItemDetail(
                itemId: itemId,
                item: item,
                loginRedirection: loginRedirection,
              );
            },
          ),
          GoRoute(
            name: AppRoutes.itemReviews,
            path: "reviews",
            builder: (BuildContext context, GoRouterState state) {
              // final String itemId = state.pathParameters['itemId'] as String;
              final Map<String, dynamic> routeParams =
                  state.extra as Map<String, dynamic>;
              var item = routeParams['item'];
              var loginRedirection = routeParams['loginRedirection'];
              return ItemReviewsPage(
                item: item,
                loginRedirection: loginRedirection,
              );
            },
            //* Add review for particular item
            routes: [
              GoRoute(
                name: AppRoutes.addItemReview,
                path: "add",
                builder: (BuildContext context, GoRouterState state) {
                  // final String itemId = state.pathParameters['itemId'] as String;
                  final Map<String, dynamic> routeParams = state.extra != null
                      ? state.extra as Map<String, dynamic>
                      : {};
                  var item = routeParams['item'];
                  var loginRedirection = routeParams['loginRedirection'];
                  return AddItemReviewPage(
                    item: item,
                    loginRedirection: loginRedirection,
                  );
                },
              ),
              //* Edit review for a particular item
              GoRoute(
                name: AppRoutes.editItemReview,
                path: ":reviewId/edit",
                builder: (BuildContext context, GoRouterState state) {
                  // final String itemId = state.pathParameters['itemId'] as String;
                  // final String reviewId = state.pathParameters['reviewId'] as String;
                  final Map<String, dynamic> routeParams =
                      state.extra as Map<String, dynamic>;
                  var item = routeParams['item'];
                  var reviewContent = routeParams['reviewContent'];
                  return EditItemReviewPage(
                    item: item,
                    reviewContent: reviewContent,
                  );
                },
              )
            ],
          ),
        ],
      ),
    ],
  ),
//* Restaurant Detail Page
  GoRoute(
    path: '/user/restaurant/:restaurantId',
    redirect: (context, state) {
      final restaurantId = state.pathParameters['restaurantId']!;
      final query = state.uri.query; // preserve query parameters
      final newPath =
          '/restaurants/$restaurantId${query.isNotEmpty ? '?$query' : ''}';
      return newPath;
    },
  ),
  GoRoute(
    name: "restaurants",
    path: "/restaurants",
    builder: (BuildContext context, GoRouterState state) => Container(),
    routes: [
      //* Get Restaurant Detail
      GoRoute(
        name: AppRoutes.restaurantDetail,
        path: ":restaurantId",
        builder: (BuildContext context, GoRouterState state) {
          final String restaurantId =
              state.pathParameters['restaurantId'] as String;
          final routeParams =
              state.extra != null ? state.extra as Map<String, dynamic> : {};
          String? loginRedirection = routeParams['loginRedirection'];
          return RestaurantDetail(
            hasQuery: state.uri.hasQuery,
            restaurantId: restaurantId,
            loginRedirection: loginRedirection,
          );
        },
        //* Get Restaurant Menu
        routes: [
          GoRoute(
            name: AppRoutes.restaurantMenu,
            path: 'restaurantMenu',
            builder: (BuildContext context, GoRouterState state) {
              final Restaurant restaurant = state.extra as Restaurant;
              return RestaurantMenu(restaurant: restaurant);
            },
          ),
          //* Get Restaurants Reviews
          GoRoute(
            name: AppRoutes.restaurantReviews,
            path: "reviews",
            builder: (BuildContext context, GoRouterState state) {
              // final String itemId = state.pathParameters['restaurantId'] as String;
              final Map<String, dynamic> routeParams =
                  state.extra as Map<String, dynamic>;
              var restaurant = routeParams['restaurant'];
              var loginRedirection = routeParams['loginRedirection'];

              return RestaurantReviewsPage(
                restaurant: restaurant,
                loginRedirection: loginRedirection,
              );
            },
            //* Add review for a particular restaurant
            routes: [
              GoRoute(
                name: AppRoutes.addRestaurantReview,
                path: "add",
                builder: (BuildContext context, GoRouterState state) {
                  // final String restaurantId =
                  //     state.pathParameters['restaurantId'] as String;
                  final Map<String, dynamic> routeParams = state.extra != null
                      ? state.extra as Map<String, dynamic>
                      : {};
                  var restaurant = routeParams['restaurant'];
                  var loginRedirection = routeParams['loginRedirection'];

                  return AddRestaurantReviewPage(
                    restaurant: restaurant,
                    loginRedirection: loginRedirection,
                  );
                },
              ),
              //* Edit review for a particular restaurant
              GoRoute(
                name: AppRoutes.editRestaurantReview,
                path: ":reviewId/edit",
                builder: (BuildContext context, GoRouterState state) {
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
                },
              )
            ],
          ),

          GoRoute(
            name: AppRoutes.selectOrdersPage,
            path: 'selectOrdersPage',
            builder: (BuildContext context, GoRouterState state) {
              final Restaurant restaurant = state.extra as Restaurant;
              return SelectOrdersPage(
                restaurant: restaurant,
              );
            },
          ),
        ],
      ),
    ],
  ),

  //* Settings Route
  GoRoute(
    name: AppRoutes.settingsPage,
    path: "/settings",
    builder: (BuildContext context, GoRouterState state) =>
        const SettingsPage(),
  ),
  GoRoute(
    name: AppRoutes.languagePage,
    path: "/languages",
    builder: (BuildContext context, GoRouterState state) =>
        const LanguagesPage(),
  ),
  GoRoute(
    name: AppRoutes.userPreferencesPage,
    path: "/userPreferences",
    builder: (BuildContext context, GoRouterState state) =>
        const UserPreferencesPage(),
  ),
  GoRoute(
    name: AppRoutes.termsPage,
    path: "/terms",
    builder: (BuildContext context, GoRouterState state) =>
        const TermsAndConditionsPage(),
  ),
  GoRoute(
    name: AppRoutes.privacyPage,
    path: "/privacy",
    builder: (BuildContext context, GoRouterState state) => const PrivacyPage(),
  ),

  //* Notification page
  GoRoute(
    name: AppRoutes.notificationPage,
    path: "/notifications",
    builder: (BuildContext context, GoRouterState state) {
      Map<String, dynamic>? extraParams = state.extra as Map<String, dynamic>?;
      LocalUserModel? user = extraParams != null ? extraParams['user'] : null;
      return NotificationPage(
        user: user,
      );
    },
  ),
  //* Connected Accounts
  GoRoute(
    name: AppRoutes.connectedAccounts,
    path: "/connectedAccounts",
    builder: (BuildContext context, GoRouterState state) {
      return const NotificationPage();
    },
  ),
  GoRoute(
    name: AppRoutes.giveFeedbackPage,
    path: "/feedbackPage",
    builder: (BuildContext context, GoRouterState state) {
      return const FeedbackPage();
    },
  ),
  GoRoute(
    name: AppRoutes.leaderBoardPage,
    path: "/leaderBoardPage",
    builder: (BuildContext context, GoRouterState state) {
      return const LeaderBoard();
    },
  ),

  //* Quick add review page Image Capture Page
  GoRoute(
    name: AppRoutes.quickAddReviewFileSelect,
    path: "/quickAddReviewFileSelect",
    builder: (BuildContext context, GoRouterState state) {
      return const CaptureMediaPage();
    },
  ),
  //* Quick add review Restaurant Select page
  GoRoute(
    name: AppRoutes.quickAddReviewRestaurantSelect,
    path: "/quickAddReviewRestaurantPage",
    builder: (BuildContext context, GoRouterState state) {
      return const NearByRestaurantSearchPage();
    },
  ),
  //* Quick add review Item Select page
  GoRoute(
    name: AppRoutes.quickAddItemSelect,
    path: "/quickAddItemSelect",
    builder: (BuildContext context, GoRouterState state) {
      return const NearByItemSearchPage();
    },
  ),
  //* Send draft Review
  GoRoute(
    name: AppRoutes.sendSavedReview,
    path: "/sendSavedReview",
    builder: (BuildContext context, GoRouterState state) {
      final Map<String, dynamic> routeParams =
          state.extra as Map<String, dynamic>;
      var reviewContent = routeParams['reviewContent'];
      return SendDraftToReviewPage(
        reviewContent: reviewContent,
      );
    },
  ),
  //? Gallery View page (Future Update for quick add review)
  GoRoute(
    name: AppRoutes.quickAddGallery,
    path: "/gallery",
    builder: (BuildContext context, GoRouterState state) {
      return const GalleryPage();
    },
  ),
  GoRoute(
    name: AppRoutes.candidateRestaurantPage,
    path: "/candidateRestaurantPage",
    builder: (BuildContext context, GoRouterState state) {
      return CandidateRestaurantPage();
    },
  ),
  GoRoute(
    name: AppRoutes.verifyEmail,
    path: "/verifyEmail",
    builder: (BuildContext context, GoRouterState state) {
      final Map<String, dynamic> routeParams =
          state.extra as Map<String, dynamic>;
      return VerifyEmailPage(
        user: routeParams['user'],
      );
    },
  ),
  GoRoute(
    name: AppRoutes.verifyPhone,
    path: "/verifyPhone",
    builder: (BuildContext context, GoRouterState state) {
      final Map<String, dynamic> routeParams =
          state.extra as Map<String, dynamic>;
      return VerifyPhonePage(
        user: routeParams['user'],
      );
    },
  ),

  // Order History Page
  GoRoute(
    name: AppRoutes.orderHistory,
    path: "/orderHistory",
    builder: (BuildContext context, GoRouterState state) {
      return const OrderHistoryPage();
    },
    routes: [
      //* Get Order Detail
      GoRoute(
        name: AppRoutes.orderHistoryDetail,
        path: ":orderId",
        builder: (BuildContext context, GoRouterState state) {
          final String orderId = state.pathParameters['orderId'] as String;
          final Map<String, dynamic> routeParams =
              state.extra as Map<String, dynamic>;

          return OrderHistoryDetailPage(
            orderId: orderId,
            restaurantId: routeParams['restaurantId'],
          );
        },
      ),
    ],
  ),

  //Search Restaurant
  GoRoute(
    name: AppRoutes.searchRestaurant,
    path: "/searchRestaurant",
    builder: (BuildContext context, GoRouterState state) {
      final Map<String, dynamic> routeParams =
          state.extra as Map<String, dynamic>;
      return SearchRestaurantPageGlobal(
        isRestaurantReview: routeParams['isRestaurantReview'],
      );
    },
  ),

  // Restaurant Review (From shared media)
  GoRoute(
    name: AppRoutes.restaurantReviewFromSharedMedia,
    path: "/restaurantReviewFromSharedMedia",
    builder: (BuildContext context, GoRouterState state) {
      final Map<String, dynamic> routeParams =
          state.extra as Map<String, dynamic>;
      return GiveRestaurantReview(
        restaurantId: routeParams['restaurantId'],
      );
    },
  ),

  // Search food
  GoRoute(
    name: AppRoutes.searchFood,
    path: "/searchFood",
    builder: (BuildContext context, GoRouterState state) {
      final Map<String, dynamic> routeParams =
          state.extra as Map<String, dynamic>;
      return SearchFoodPage(
        restaurantId: routeParams['restaurantId'],
      );
    },
  ),

  // Food Review (From shared media)
  GoRoute(
    name: AppRoutes.foodReviewFromSharedMedia,
    path: "/foodReviewFromSharedMedia",
    builder: (BuildContext context, GoRouterState state) {
      final Map<String, dynamic> routeParams =
          state.extra as Map<String, dynamic>;
      return GiveFoodReview(
        foodId: routeParams['foodId'],
      );
    },
  ),
  // // Qr Menu and ordering
  // GoRoute(
  //   name: AppRoutes.qrMenuPage,
  //   path: "/qrMenu/:restaurantId",
  //   builder: (BuildContext context, GoRouterState state) {
  //     return QRMenuPage(
  //       restaurantId: state.pathParameters['restaurantId'] as String,
  //     );
  //   },
  //   routes: [
  //     GoRoute(
  //       name: AppRoutes.qrOrderStatusPage,
  //       path: "/qrOrderStatus/:orderId",
  //       builder: (BuildContext context, GoRouterState state) {
  //         final String orderId = state.pathParameters['orderId'] as String;
  //         final Restaurant restaurant = ((state.extra
  //             as Map<String, dynamic>)['restaurant'] as Restaurant);
  //         return QROrderStatusPage(
  //           orderId: orderId,
  //           restaurant: restaurant,
  //         );
  //       },
  //     ),
  //     GoRoute(
  //       name: AppRoutes.qrOrderPage,
  //       path: "qrOrder",
  //       builder: (BuildContext context, GoRouterState state) {
  //         return QROrderPage(
  //           restaurantId: state.pathParameters['restaurantId'] as String,
  //         );
  //       },
  //       routes: [
  //         GoRoute(
  //           name: AppRoutes.qrOrderSummery,
  //           path: "qrOrderSummary",
  //           builder: (BuildContext context, GoRouterState state) {
  //             final Map<String, dynamic> routeParams =
  //                 state.extra as Map<String, dynamic>;
  //             return QROrderSummaryPage(
  //               restaurant: routeParams['restaurant'],
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //     GoRoute(
  //       name: AppRoutes.editQROrderPage,
  //       path: "qrOrder/edit/:orderId",
  //       builder: (BuildContext context, GoRouterState state) {
  //         return EditQROrderPage(
  //           orderId: state.pathParameters['orderId'] as String,
  //           restaurantId: state.pathParameters['restaurantId'] as String,
  //         );
  //       },
  //       routes: [
  //         GoRoute(
  //           name: AppRoutes.editQROrderSummery,
  //           path: "qrOrderSummery",
  //           builder: (BuildContext context, GoRouterState state) {
  //             final Map<String, dynamic> routeParams =
  //                 state.extra as Map<String, dynamic>;
  //             return EditQROrderSummaryPage(
  //               restaurant: routeParams['restaurant'],
  //             );
  //           },
  //         ),
  //       ],
  //     ),
  //   ],
  // ),

  GoRoute(
    name: 'qrMenuAlt',
    path: "/user/restaurant/:restaurantId/menu",
    builder: (BuildContext context, GoRouterState state) {
      return QRMenuPage(
        restaurantId: state.pathParameters['restaurantId'] as String,
      );
    },
    routes: [
      GoRoute(
        name: AppRoutes.qrOrderStatusPage,
        path: "/qrOrderStatus/:orderId",
        builder: (BuildContext context, GoRouterState state) {
          final String orderId = state.pathParameters['orderId'] as String;
          final Restaurant restaurant = ((state.extra
              as Map<String, dynamic>)['restaurant'] as Restaurant);
          return QROrderStatusPage(
            orderId: orderId,
            restaurant: restaurant,
          );
        },
      ),
      GoRoute(
        name: AppRoutes.qrOrderPage,
        path: "qrOrder",
        builder: (BuildContext context, GoRouterState state) {
          return QROrderPage(
            restaurantId: state.pathParameters['restaurantId'] as String,
          );
        },
        routes: [
          GoRoute(
            name: AppRoutes.qrOrderSummery,
            path: "qrOrderSummary",
            builder: (BuildContext context, GoRouterState state) {
              final Map<String, dynamic> routeParams =
                  state.extra as Map<String, dynamic>;
              return QROrderSummaryPage(
                restaurant: routeParams['restaurant'],
              );
            },
          ),
        ],
      ),
      GoRoute(
        name: AppRoutes.editQROrderPage,
        path: "qrOrder/edit/:orderId",
        builder: (BuildContext context, GoRouterState state) {
          return EditQROrderPage(
            orderId: state.pathParameters['orderId'] as String,
            restaurantId: state.pathParameters['restaurantId'] as String,
          );
        },
        routes: [
          GoRoute(
            name: AppRoutes.editQROrderSummery,
            path: "qrOrderSummery",
            builder: (BuildContext context, GoRouterState state) {
              final Map<String, dynamic> routeParams =
                  state.extra as Map<String, dynamic>;
              return EditQROrderSummaryPage(
                restaurant: routeParams['restaurant'],
              );
            },
          ),
        ],
      ),
    ],
  ),
];
