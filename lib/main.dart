import 'dart:io';

import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_native_splash/flutter_native_splash.dart';
import 'package:go_router/go_router.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/category/category_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/item_review_card_flag/item_review_flag_bloc.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/user_preference/user_preference.dart';
import 'package:rateeat_mobile/src/features/shared_media_review/presentation/bloc/food_review/food_review_bloc.dart';
import 'package:rateeat_mobile/src/features/shared_media_review/presentation/bloc/search_food/search_food_bloc.dart';
import 'package:rateeat_mobile/src/features/shared_media_review/presentation/bloc/share_media/share_media_bloc.dart';
import 'package:rateeat_mobile/src/core/hive/hive_init.dart';
import 'package:rateeat_mobile/src/core/hive/session_track.dart';
import 'package:rateeat_mobile/src/core/language/language_bloc.dart';
import 'package:rateeat_mobile/src/core/service/firebase_init.dart';
import 'package:rateeat_mobile/src/features/add_to_favorite/presentation/bloc/favorite_bloc.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/bloc/candidate_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_bloc.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_bloc.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/leadear_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/monthly_leader_board/monthly_leader_board_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/weekly_leader_board/weekly_leader_board_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/pages/leaderboard.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/bloc/map_markers/map_markers_bloc.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';
import 'package:rateeat_mobile/src/features/order/presentation/bloc/total_price/total_price_bloc.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';
import 'package:rateeat_mobile/src/features/order/presentation/widgets/widgets.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_item_review/delete_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_restaurant_review/delete_restaurant_review_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/local_history/local_search_history_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/popular_searches/popular_search_bloc.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/bloc/location_based_restaurants/location_based_restaurants_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_items/popular_restaurant_items_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_item_reviews/get_item_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_restaurant_reviews/get_restaurant_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/item_price_update/item_price_update_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/restaurant_price_update/restaurant_price_update_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/item_reviews_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/restaurant_reviews_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/bloc/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/categories.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/search_result.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/give_feedback/give_feedback_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/follow/follow_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_profile/others_favorites_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_profile/others_user_review_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/saved_reviews/saved_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/username_availability/username_availability_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/verify_edit_profile/verify_edit_profile_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'src/core/core.dart';
import 'src/core/currency/general_currency_bloc.dart';
import 'src/core/push_notification/push_notifications_api.dart';
import 'src/core/widgets/custom_persistent_bottom_navbar.dart';
import 'src/features/currency_exchange/currency_exchange.dart';
import 'src/features/discover_item/presentation/bloc/filter/filter_items_bloc.dart';
import 'src/features/discover_item/presentation/bloc/search/search_restaurant.dart';
import 'src/features/discover_item/presentation/bloc/search/selected_restaurant.dart';
import 'src/features/discover_item/presentation/pages/filter_modal_sheet.dart';
import 'src/features/discover_item/presentation/pages/item_result_page.dart';
import 'src/features/discover_restaurant_result/presentation/bloc/restaurant_bloc/discover_result_bloc.dart';
import 'src/features/features.dart';
import 'src/features/live_search/presentation/bloc/live_search/search_bloc.dart';
import 'src/features/live_search/presentation/pages/live_search_page.dart';
import 'src/features/location_search/presentation/bloc/location_description/location_description_bloc.dart';
import 'src/features/map_section/presentation/widgets/google_map_content.dart';
import 'src/features/notification/presentation/bloc/fetch_notifications/notification_bloc.dart';
import 'src/features/notification/presentation/bloc/notification_mark_as_read/notifications_mark_as_read_bloc.dart';
import 'src/features/notification/presentation/bloc/un_read_notification_counter/un_read_notification_counter_bloc.dart';
import 'src/features/notification/presentation/pages/pages.dart';
import 'src/features/one_click_review/presentation/bloc/nearby_items/nearby_item_bloc.dart';
import 'src/features/one_click_review/presentation/bloc/nearby_restaurant/nearby_restaurant_bloc.dart';
import 'src/features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';
import 'src/features/one_click_review/presentation/widgets/nearby_item_result.dart';
import 'src/features/one_click_review/presentation/widgets/nearby_restaurant_result.dart';
import 'src/features/order/presentation/bloc/create_order/create_order_bloc.dart';
import 'src/features/restaurant_menu/presentation/bloc/candidate_item/candidate_item_bloc.dart';
import 'src/features/restaurant_menu/presentation/bloc/restaurant_category/restaurant_category_bloc.dart';
import 'src/features/restaurant_menu/presentation/widgets/candidate_item.dart';
import 'src/features/restaurant_menu/presentation/widgets/category_items.dart';
import 'src/features/review/presentation/bloc/add_item_review/add_item_review_bloc.dart';
import 'src/features/review/presentation/bloc/delete_draft_review/delete_draft_review_bloc.dart';
import 'src/features/review/presentation/bloc/flag_review/flag_review_bloc.dart';
import 'src/features/shared_media_review/presentation/bloc/restaurant_review/restaurant_review_bloc.dart';
import 'src/features/shared_media_review/presentation/bloc/search_restaurant/search_restaurant_bloc.dart';
import 'src/features/user_profile/presentation/pages/custom_tab_bar.dart';

void main() async {
  // Bloc.observer = AppBlocObserver();
  //* Flutter Initialization
  final WidgetsBinding widgetsBinding =
      WidgetsFlutterBinding.ensureInitialized();
  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.white,
    statusBarIconBrightness: Brightness.dark,
  ));

  //* Environment Variable
  await dotenv.load(fileName: ".env");
  //* Initialize GoogleSignIn before using it
  await GoogleSignIn.instance.initialize(
    clientId: Platform.isIOS ? dotenv.env['IOS_CLIENT_ID'] : null,
    // clientId: 'YOUR_WEB_CLIENT_ID', // Optional for web
    // serverClientId: 'YOUR_SERVER_CLIENT_ID', // Required for Android v7.1+
  );
  //* Firebase Initialization
  await initializeFirebase();
  //* Service Locator  Initialization (Dependency Injection)
  await serviceLocatorInit();
  //* local Database Initialization

  await HiveService.init();
  //* push notifications init    bool? isFasting,
  await PushNotificationsAPI().initNotifications();

  //* Native Splash Screen Initialization
  FlutterNativeSplash.preserve(widgetsBinding: widgetsBinding);
  FlutterNativeSplash.remove();

  // Init background service
  // await initializeBackgroundService();
  runApp(
    MultiBlocProvider(
      providers: [
        //* ----------------------------- Network and Location bloc --------------------------------
        BlocProvider(create: (context) => dpLocator<NetworkBloc>()),
        BlocProvider(create: (context) => dpLocator<UserLocationBloc>()),
        //* ----------------------------- Authentication Bloc --------------------------------
        BlocProvider<AuthenticationBloc>(
          create: (_) => dpLocator<AuthenticationBloc>(),
        ),
        BlocProvider<UserDataCubit>(
          create: (_) => dpLocator<UserDataCubit>(),
        ),
        //* -----------------------------  --------------------------------
        BlocProvider(
          create: (context) => dpLocator<MapZoomBloc>(),
        ),
        BlocProvider<SearchFoodCategoryBloc>(
          create: (_) => dpLocator<SearchFoodCategoryBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<SelectFoodCategoryBloc>(),
        ),

        BlocProvider(
          create: (context) => dpLocator<AllRestaurantsBloc>(),
        ),
        //Candidate Item
        BlocProvider(
          create: (context) => dpLocator<CandidateItemBloc>(),
        ),

        BlocProvider(
          create: (context) => dpLocator<AutoCompleteBloc>(),
        ),

        BlocProvider(
          create: (context) => dpLocator<DiscoveryStepsBloc>(),
        ),

        //* Old navigation bloc
        BlocProvider(
          create: (context) => dpLocator<BottomNavIndexBloc>(),
        ),
        //* New navigation bloc
        BlocProvider(
          create: (context) => dpLocator<BottomNavigationCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<CandidateItemCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<PromotionBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<PopularBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<RecommendedBloc>(),
        ),

        BlocProvider(
          create: (context) => dpLocator<RestaurantsFilterSearchResultsBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<ItemsFilterSearchResultsBloc>(),
        ),
        //* --------------------- Profile BLocs
        BlocProvider(
          create: (context) => dpLocator<GetUserProfileBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<EditProfileBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<VerifyEditProfileBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<UsernameAvailabilityBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<UserReviewBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<OthersFavoriteBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<OthersReviewBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<FollowBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<UserFavoriteBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<SavedReviewsBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<UserReviewsPageCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<SavedReviewsPageCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<AddRecommendationBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<OtherRecommendationBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<RecommendationBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<FollowingListBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<FollowerListBloc>(),
        ),
        BlocProvider(create: (context) => dpLocator<UserPreferenceBloc>()),
        //* --------------------------------------
        BlocProvider(create: (context) => dpLocator<CategoryBloc>()),

        BlocProvider(
          create: (context) => dpLocator<RestaurantMenuBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<SearchRestaurantsBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<FilterItemsBloc>(),
        ),
        BlocProvider(
          create: (BuildContext context) => dpLocator<CategoriesToggleBloc>(),
        ),
        BlocProvider(
          create: (BuildContext context) => FastingToggleBloc(),
        ),

        BlocProvider(
          create: (BuildContext context) => HomeFastingToggleBloc(),
        ),

        BlocProvider(
          create: (context) => dpLocator<FetchDiscoverRestaurantResultBloc>(),
        ),
        BlocProvider(
          create: (context) => RatingBloc(),
        ),

        BlocProvider(
          create: (context) => DisplayRestaurantCountAndWalkingDistance(),
        ),
        BlocProvider(
          create: (context) => PriceMultiChipsBlock(),
        ),
        BlocProvider(
          create: (context) => dpLocator<DiscoverSelectedScreenCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<SearchBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<LocationBasedRestaurantsBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<RestaurantPopularItemsBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<LocationBasedRestaurantsBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<SearchQueryCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<SearchPageCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<LocationDescriptionBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<FavoriteBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<SearchPageCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<DiscoveryItemPageCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<SelectedRestaurantBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<SelectedRestaurantBloc>(),
        ),

        BlocProvider(
          create: (context) => dpLocator<MultiChipsCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<LiveSearchCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<LocalSearchHistoryBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<PopularSearchesBloc>(),
        ),
        BlocProvider(
          create: (context) => LanguageBloc(),
        ),
        BlocProvider(
          create: (context) => dpLocator<NotificationsBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<NotificationsMarkAsReadBloc>(),
        ),

        BlocProvider(
          create: (context) => dpLocator<ItemDetailBloc>(),
        ),
        //* ----------------------------- Item Reviews Bloc --------------------------------

        BlocProvider(
          create: (context) => dpLocator<GetItemReviewsBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<DeleteItemReviewBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<ItemReviewsPageControllerCubit>(),
        ),
        //* ----------------------------- Restaurant Reviews Bloc --------------------------------

        BlocProvider(
          create: (context) => dpLocator<GetRestaurantReviewsBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<AddItemReviewBloc>(),
        ),

        BlocProvider(
          create: (context) => dpLocator<DeleteRestaurantReviewBloc>(),
        ),
        BlocProvider(
          create: (context) =>
              dpLocator<RestaurantReviewsPageControllerCubit>(),
        ),

        //* ----------------------------- Reviews Flag Bloc --------------------------------
        BlocProvider(
          create: (context) => dpLocator<FlagReviewBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<ItemReviewsCardBloc>(),
        ),
        //* ----------------------------- Discover Item Filtering Blocs --------------------------------
        BlocProvider(
          create: (context) => dpLocator<DiscoverMenuPriceSelectorCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<DiscoverMenuRatingSelectorCubit>(),
        ),

        BlocProvider(
            create: (context) => dpLocator<DiscoverMenuFastingSelectorCubit>()),

        BlocProvider(
            create: (context) => dpLocator<DiscoverMenuCategoryIdCubit>()),
        BlocProvider(
          create: (context) => dpLocator<DiscoverMenuSelectedCategoryCubit>(),
        ),
        BlocProvider(
            create: (context) => dpLocator<DiscoverMenuFastingSelectorCubit>()),
        //* ------------------------------------------ Feature Discover Restaurant Category Selector ----------------------------------

        BlocProvider(
          create: (context) => dpLocator<SelectFoodCategoryBloc>(),
        ),

        //Transport mode cubit
        BlocProvider(
          create: (context) => dpLocator<TransportModeCubit>(),
        ),

        BlocProvider(
          create: (context) =>
              dpLocator<MapMarkersBloc>()..add(LoadMarkersEvent(zoomLevel: 14)),
        ),
        BlocProvider(
            create: (context) => dpLocator<HomePageNearbyRestaurantBloc>()),
        //price update Bloc
        BlocProvider(create: (context) => dpLocator<PriceUpdateBloc>()),
        BlocProvider(create: (context) => dpLocator<PriceItemUpdateBloc>()),
        //Feedback Bloc
        BlocProvider(create: (context) => dpLocator<FeedbackBloc>()),

        //LeaderBoard Bloc
        BlocProvider(create: (context) => dpLocator<LeaderBoardBloc>()),
        BlocProvider(create: (context) => dpLocator<WeeklyLeaderBoardBloc>()),
        BlocProvider(create: (context) => dpLocator<MonthlyLeaderBoardBloc>()),
        BlocProvider(
            create: (context) => dpLocator<WeeklyLeaderBoardPageCubit>()),
        BlocProvider(
            create: (context) => dpLocator<MonthlyLeaderBoardPageCubit>()),
        BlocProvider(
            create: (context) => dpLocator<AllTimeLeaderBoardPageCubit>()),
        //rank Bloc
        BlocProvider(create: (context) => dpLocator<RankBloc>()),
        //* ------------------------------------------ Feature One-Click  ----------------------------------
        BlocProvider(create: (context) => dpLocator<SimpleReviewStepperBloc>()),
        BlocProvider(create: (context) => dpLocator<NearByRestaurantBloc>()),
        BlocProvider(create: (context) => dpLocator<NearbyItemBloc>()),
        BlocProvider(create: (context) => dpLocator<DeleteDraftReviewBloc>()),
        BlocProvider(
          create: (context) => dpLocator<NearByRestaurantPageCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<NearByItemPageCubit>(),
        ),
        //unread notifications counter
        BlocProvider(
          create: (context) => dpLocator<UnreadNotificationsCounterBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<NotificationsPageCubit>(),
        ),

        BlocProvider(create: (context) => dpLocator<CandidateBloc>()),
        BlocProvider(
          create: (context) => dpLocator<TagBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<RestaurantCategoryBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<CategoriesPageCubit>(),
        ),
        //* Feature - Order
        BlocProvider(
          create: (context) => dpLocator<CartCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<OrderCategoriesPageCubit>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<TotalPriceBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<OrderSocketStatusBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<OrderStatusBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<CreateOrderBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<PayOrderBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<CancelOrderBloc>(),
        ),
        //* Feature - Order-History
        BlocProvider(
          create: (context) => dpLocator<OrdersCountBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<OrderHistoryBloc>(),
        ),

        BlocProvider<OrderDetailBloc>(
          create: (context) => dpLocator<OrderDetailBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<OrderHistoryStatusBloc>(),
        ),

        BlocProvider<SharedMediaBloc>(
          create: (context) => dpLocator<SharedMediaBloc>(),
        ),
        BlocProvider<SearchRestaurantBloc>(
          create: (context) => dpLocator<SearchRestaurantBloc>(),
        ),
        BlocProvider<RestaurantDetailBloc>(
          create: (context) => dpLocator<RestaurantDetailBloc>(),
        ),
        BlocProvider<RestaurantReviewBloc>(
          create: (context) => dpLocator<RestaurantReviewBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<SearchFoodBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<FoodReviewBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<QRMenuBloc>(),
        ),
        BlocProvider(
          create: (context) => dpLocator<ItemsCountPerPriceBloc>(),
        ),
        //* Feature - Currency Exchange
        BlocProvider(
          create: (context) => dpLocator<CurrencyBloc>(),
        ),
        //* Feature  - General Currency Preference
        BlocProvider<GeneralCurrencyBloc>(
          create: (context) =>
              dpLocator<GeneralCurrencyBloc>()..add(LoadGeneralCurrency()),
        ),
      ],
      child: const MyApp(),
    ),
  );
}

class MyApp extends StatefulWidget {
  const MyApp({super.key});

  @override
  State<MyApp> createState() => _MyAppState();
}

class _MyAppState extends State<MyApp> with WidgetsBindingObserver {
  // StreamSubscription? _sub;
  @override
  void initState() {
    super.initState();
    _checkForDynamicLink();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      // Re-setup or ensure the listener is active
      resumeSession();
    } else if (state == AppLifecycleState.paused) {
      pauseSession();
    } else if (state == AppLifecycleState.inactive) {
    } else if (state == AppLifecycleState.detached) {}
  }

  void _checkForDynamicLink() async {
    // Listening for dynamic links while app is in the foreground
    // ? TODO: migrate from firebase to applinks or other options
    // ignore: deprecated_member_use
    FirebaseDynamicLinks.instance.onLink.listen(
      (PendingDynamicLinkData? dynamicLink) async {
        final Uri? deepLink = dynamicLink?.link;
        debugPrint("Foreground link received: $deepLink"); // Debug log

        if (deepLink != null) {
          final String? restaurantId = deepLink.queryParameters['restaurantId'];
          debugPrint("Parsed restaurantId: $restaurantId"); // Debug log

          if (restaurantId != null && mounted) {
            context.pushNamed(
              AppRoutes.qrMenuPage,
              pathParameters: {'restaurantId': restaurantId},
            );
          }
        }
      },
      onError: (e) async {
        debugPrint('Dynamic Link Failed: ${e.message}');
      },
    );

    // Handling dynamic links when app is launched
    final PendingDynamicLinkData? initialLink =
        // ? TODO: migrate from firebase to applinks or other options
        // ignore: deprecated_member_use
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      final Uri deepLink = initialLink.link;
      debugPrint("Initial link received: $deepLink"); // Debug log

      final String? restaurantId = deepLink.queryParameters['restaurantId'];
      debugPrint("Parsed restaurantId: $restaurantId"); // Debug log

      if (restaurantId != null && mounted) {
        context.pushNamed(
          AppRoutes.qrMenuPage,
          pathParameters: {'restaurantId': restaurantId},
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    SizeConfig().init(context);
    return ResponsiveSizer(
      builder: (context, orientation, screenType) {
        return AppRouter(
          localSource: dpLocator<AuthenticationLocalSource>(),
        );
      },
    );
  }
}
