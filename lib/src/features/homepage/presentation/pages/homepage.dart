import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_event.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/nearby_rest_state.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_bloc.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/home_restaurant_card.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/item_tile.dart';
import 'package:rateeat_mobile/src/features/item_category/presentation/widgets/tag_shimmer.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/bloc/un_read_notification_counter/un_read_notification_counter_bloc.dart';
import 'package:rateeat_mobile/src/features/order_history/presentation/bloc/orders_count/order_count_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../../core/utils/external_app_intent.dart';
import '../../../../core/widgets/custom_persistent_bottom_navbar.dart';
import '../../../../core/widgets/offline_data_widget.dart';
import '../../../discover_item/data/data_sources/local_nearby_restaurant_data_provider.dart';
import '../widgets/shimmer/popular_items_shimmer.dart';
import '../widgets/shimmer/recommended_items_shimmer.dart';
import '../bloc/highest_rated/popular_event.dart';
import '../bloc/highest_rated/popular_state.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  final _scrollController = ScrollController();
  final _offlineDataOverlayController = OverlayPortalController();

  int popularRetryCount = 0;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
    _scrollController.addListener(_onRecommendedScroll);
    SchedulerBinding.instance
        .addPostFrameCallback((_) => listenShareMediaFiles(context));

    //* Check If User Location is Already Loaded
    var userLocation = context.read<UserLocationBloc>().state;
    var recommendedState = context.read<RecommendedBloc>().state;
    var nearByState = context.read<HomePageNearbyRestaurantBloc>().state;

    if (userLocation is! UserLocationLoaded &&
        recommendedState is! RecommendedRestaurantFetched) {
      context.read<UserLocationBloc>().add(
            const GetUserLocation(),
          );
      //* Load Popular and Recommendation
      context.read<PopularBloc>().add(
            GetTopRatedEvent(
              page: 1,
              tags: context.read<TagBloc>().state.selectedTags,
            ),
          );
      context.read<RecommendedBloc>().add(
            GetRecommendedEvent(
              page: 1,
              tags: context.read<TagBloc>().state.selectedTags,
            ),
          );
      context.read<SearchFoodCategoryBloc>().add(GetCategorySuggestion());
    } else if (userLocation is UserLocationLoaded) {
      final location = userLocation.location;
      context.read<HomePageNearbyRestaurantBloc>().add(
            GetNearByRestaurants(
              lat: location.latitude,
              lng: location.longitude,
              tags: context.read<TagBloc>().state.selectedTags,
              page: 1,
            ),
          );
      context.read<PopularBloc>().add(
            GetTopRatedEvent(
                page: 1,
                lat: location.latitude,
                lng: location.longitude,
                tags: context.read<TagBloc>().state.selectedTags),
          );
      context.read<SearchFoodCategoryBloc>().add(GetCategorySuggestion());
    }
  }

  mapRestaurants(restaurants) {
    return restaurants.map(
      (restaurant) => Padding(
        padding: EdgeInsets.symmetric(vertical: 1.2.h),
        child: HomeRestaurantCard(
          restaurant: restaurant,
        ),
      ),
    );
  }

  mapRecommendedRestaurants(restaurants) {
    return restaurants.map(
      (restaurant) => Padding(
        padding: EdgeInsets.symmetric(vertical: 1.2.h),
        child: RecommendedRestaurantWidget(
          restaurant: restaurant,
        ),
      ),
    );
  }

  final items = List.generate(7, (index) => const TagShimmer());

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        context.read<DiscoverSelectedScreenCubit>().toDiscoverOptionsPage();
        context.goNamed(
          AppRoutes.home,
        );
        context.read<BottomNavigationCubit>().changeIndex(1);
      },
      child: RefreshIndicator(
        onRefresh: refresh,
        color: Colors.red,
        child: Scaffold(
          appBar: const HomePageAppBar(),
          body: OverlayPortal(
            controller: _offlineDataOverlayController,
            overlayChildBuilder: (context) => Align(
              alignment: Alignment
                  .bottomCenter, // Position it at the bottom of the screen
              child: Padding(
                padding: const EdgeInsets.only(
                    bottom: 100.0), // Adjust position above the bottom
                child: OfflineDataWidget(
                  onPressed: () {
                    _offlineDataOverlayController.hide();
                  },
                ),
              ),
            ),
            child: SingleChildScrollView(
              physics: const AlwaysScrollableScrollPhysics(),
              controller: _scrollController,
              child: BlocConsumer<UserLocationBloc, UserLocationState>(
                listener: (context, userLocationState) async {
                  var recommendedState = context.read<RecommendedBloc>().state;
                  var nearByState =
                      context.read<HomePageNearbyRestaurantBloc>().state;

                  if (userLocationState is UserLocationLoaded) {
                    var location = (context.read<UserLocationBloc>().state
                            as UserLocationLoaded)
                        .location;
                    await dpLocator<LocalNearbyRestaurantDataProvider>()
                        .clearNearbyRestaurants();

                    //* Load Popular and Recommendation
                    context.read<PopularBloc>().add(
                          GetTopRatedEvent(
                              page: 1,
                              lat: location.latitude,
                              lng: location.longitude,
                              tags: context.read<TagBloc>().state.selectedTags),
                        );
                    context.read<HomePageNearbyRestaurantBloc>().add(
                          GetNearByRestaurants(
                            lat: location.latitude,
                            lng: location.longitude,
                            tags: context.read<TagBloc>().state.selectedTags,
                            page: 1,
                          ),
                        );
                  } else if (userLocationState is UserLocationError &&
                      recommendedState is! RecommendedRestaurantFetched) {
                    //* Load Popular and Recommendation
                    context.read<PopularBloc>().add(
                          GetTopRatedEvent(
                            page: 1,
                            tags: context.read<TagBloc>().state.selectedTags,
                          ),
                        );
                    context.read<RecommendedBloc>().add(
                          GetRecommendedEvent(
                            page: 1,
                            tags: context.read<TagBloc>().state.selectedTags,
                          ),
                        );
                  }
                },
                builder: (context, locationState) {
                  return BlocConsumer<NetworkBloc, NetworkState>(
                    listener: (context, networkState) {
                      if (networkState is NetworkFailed) {
                        showCustomToast(
                          context: context,
                          toastMessage:
                              AppLocalizations.of(context)!.networkIssueText,
                          toastType: ToastType.error,
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is NetworkFailed || state is NetworkInitial) {
                        return Column(
                          mainAxisSize: MainAxisSize.max,
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.1,
                            ),
                            ErrorAndInfoDisplayWidget(
                              assetImage: 'assets/icons/no_content.svg',
                              title:
                                  AppLocalizations.of(context)!.noInternetText,
                              description:
                                  AppLocalizations.of(context)!.connText,
                              onPressed: null,
                            ),
                            //* Loading indicator for Network
                            if (state is NetworkInitial)
                              Expanded(
                                child: Align(
                                  alignment: Alignment.bottomCenter,
                                  child: Text(
                                    AppLocalizations.of(context)!
                                        .connectingText,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      fontWeight: FontWeight.w500,
                                      color: Colors.black.withRed(100),
                                      letterSpacing: -.2,
                                    ),
                                  ),
                                ),
                              ),

                            // If Network Failure
                            if (state is NetworkFailed)
                              Align(
                                alignment: Alignment.bottomCenter,
                                child: CustomMainButton(
                                  title: AppLocalizations.of(context)!
                                      .checkConnectionText,
                                  onTap: () {
                                    context
                                        .read<NetworkBloc>()
                                        .add(NetworkObserve());
                                  },
                                  horizontalPadding: 2.w,
                                ),
                              ),
                            SizedBox(
                              height: SizeConfig.screenHeight * 0.08,
                            ),
                          ],
                        );
                      }
                      return Padding(
                        padding: EdgeInsets.symmetric(horizontal: 5.w),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            SizedBox(
                              height: 1.h,
                            ),
                            //* User Location
                            const HomeLocationDescription(),
                            SizedBox(
                              height: 2.h,
                            ),

                            BlocBuilder<SearchFoodCategoryBloc,
                                SearchFoodCategoryState>(
                              builder: (context, state) {
                                if (state is SearchLoading) {
                                  return SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Wrap(
                                      direction: Axis.horizontal,
                                      spacing: 2.0,
                                      runSpacing: 2.0,
                                      children: items.map((item) {
                                        return item;
                                      }).toList(),
                                    ),
                                  );
                                } else if (state is SearchError) {
                                  return Center(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.center,
                                      children: <Widget>[
                                        SizedBox(height: 2.h),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .noCategoriesText,
                                          style: GoogleFonts.poppins(
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextButton(
                                          onPressed: () {
                                            context
                                                .read<SearchFoodCategoryBloc>()
                                                .add(
                                                  GetCategorySuggestion(),
                                                );
                                          },
                                          child: Text(
                                            AppLocalizations.of(context)!
                                                .retryText,
                                            style: GoogleFonts.poppins(
                                              color: Colors.red,
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                } else if (state is SearchSuccess) {
                                  var itemCategories = state.itemCategories;
                                  if (itemCategories.isNotEmpty) {
                                    return SingleChildScrollView(
                                      scrollDirection: Axis.horizontal,
                                      child: Padding(
                                        padding: const EdgeInsets.all(0.0),
                                        child: Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.start,
                                            children: List.generate(
                                              itemCategories.length,
                                              (index) => Padding(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                        horizontal: 4),
                                                child: ItemTile(
                                                  categoryName:
                                                      itemCategories[index]
                                                              .name ??
                                                          "",
                                                  categoryIconUrl:
                                                      itemCategories[index]
                                                          .iconUrl,
                                                  onTap: () {
                                                    onTagFilter();
                                                  },
                                                ),
                                              ),
                                            )),
                                      ),
                                    );
                                  } else {
                                    return ErrorAndInfoDisplayWidget(
                                      assetImage: 'assets/icons/no_content.svg',
                                      title: AppLocalizations.of(context)!
                                          .noResultText,
                                      description: AppLocalizations.of(context)!
                                          .searchNoText,
                                      onPressed: () {
                                        context
                                            .read<SearchFoodCategoryBloc>()
                                            .add(
                                              GetCategorySuggestion(),
                                            );
                                      },
                                    );
                                  }
                                }
                                // * Default state
                                return Container();
                              },
                            ),
                            SizedBox(height: 2.h),
                            Row(
                              children: [
                                Text(
                                  AppLocalizations.of(context)!.ratedDish,
                                  style: titleTextStyle.copyWith(
                                    fontSize: 17.sp,
                                  ),
                                ),
                                const Spacer(),
                                Row(
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!.fastingText,
                                      style: titleTextStyle.copyWith(
                                        fontSize: 17.sp,
                                      ),
                                    ),
                                    BlocBuilder<HomeFastingToggleBloc, bool>(
                                      builder: (context, state) {
                                        return Padding(
                                          padding:
                                              const EdgeInsets.only(right: 15),
                                          child: Switch(
                                              key: Key('fasting_toggle_button'),
                                              value: state,
                                              activeColor:
                                                  AppColors.primaryColor,
                                              activeTrackColor:
                                                  Colors.deepOrange[50],
                                              inactiveThumbColor: Colors.white,
                                              inactiveTrackColor:
                                                  Colors.grey[300],
                                              trackOutlineColor:
                                                  const WidgetStatePropertyAll(
                                                      Colors.white),
                                              onChanged: (bool value) {
                                                // context
                                                //     .read<SearchPageCubit>()
                                                //     .changePage(1);

                                                context
                                                    .read<
                                                        HomeFastingToggleBloc>()
                                                    .toggleSwitch();

                                                if (locationState
                                                    is UserLocationLoaded) {
                                                  var location = (context
                                                              .read<
                                                                  UserLocationBloc>()
                                                              .state
                                                          as UserLocationLoaded)
                                                      .location;
                                                  setState(() {
                                                    context
                                                        .read<PopularBloc>()
                                                        .add(
                                                          GetTopRatedEvent(
                                                              isFasting: context
                                                                  .read<
                                                                      HomeFastingToggleBloc>()
                                                                  .state,
                                                              page: 1,
                                                              lat: location
                                                                  .latitude,
                                                              lng: location
                                                                  .longitude,
                                                              tags: context
                                                                  .read<
                                                                      TagBloc>()
                                                                  .state
                                                                  .selectedTags),
                                                        );
                                                  });
                                                }
                                              }),
                                        );
                                      },
                                    ),
                                  ],
                                )
                              ],
                            ),
                            //* Popular Title

                            //* Popular Items
                            BlocBuilder<PopularBloc, PopularState>(
                              builder: (context, state) {
                                if (state is TopRatedState &&
                                    state.status == ItemStatus.loaded) {
                                  log('item status loaded ${state.popular}');
                                }
                                if (state is TopRatedState &&
                                    state.status == ItemStatus.loading) {
                                  return const PopularItemsShimmerHorizontal();
                                } else if (state is TopRatedState &&
                                    state.status == ItemStatus.error) {
                                  if (popularRetryCount <= 2) {
                                    popularRetryCount += 1;

                                    if (context.read<UserLocationBloc>().state
                                        is UserLocationLoaded) {
                                      var userLocation = (context
                                              .read<UserLocationBloc>()
                                              .state as UserLocationLoaded)
                                          .location;
                                      context.read<PopularBloc>().add(
                                            GetTopRatedEvent(
                                              page: 1,
                                              lat: userLocation.latitude,
                                              lng: userLocation.longitude,
                                              tags: context
                                                  .read<TagBloc>()
                                                  .state
                                                  .selectedTags,
                                              isFasting: context
                                                  .read<HomeFastingToggleBloc>()
                                                  .state,
                                            ),
                                          );
                                    } else {
                                      context.read<PopularBloc>().add(
                                            GetTopRatedEvent(
                                              page: 1,
                                              tags: context
                                                  .read<TagBloc>()
                                                  .state
                                                  .selectedTags,
                                              isFasting: context
                                                  .read<HomeFastingToggleBloc>()
                                                  .state,
                                            ),
                                          );
                                    }

                                    return const PopularItemsShimmerHorizontal();
                                  } else {
                                    return Center(
                                      child: Column(
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: <Widget>[
                                          SizedBox(height: 2.h),
                                          Text(
                                            AppLocalizations.of(context)!
                                                .noTopRatedText,
                                            style: GoogleFonts.poppins(
                                              color: Colors.black,
                                            ),
                                          ),
                                          TextButton(
                                            onPressed: () {
                                              if (context
                                                      .read<UserLocationBloc>()
                                                      .state
                                                  is UserLocationLoaded) {
                                                var userLocation = (context
                                                            .read<
                                                                UserLocationBloc>()
                                                            .state
                                                        as UserLocationLoaded)
                                                    .location;
                                                context.read<PopularBloc>().add(
                                                      GetTopRatedEvent(
                                                        page: 1,
                                                        lat: userLocation
                                                            .latitude,
                                                        lng: userLocation
                                                            .longitude,
                                                        tags: context
                                                            .read<TagBloc>()
                                                            .state
                                                            .selectedTags,
                                                        isFasting: context
                                                            .read<
                                                                HomeFastingToggleBloc>()
                                                            .state,
                                                      ),
                                                    );
                                              } else {
                                                context.read<PopularBloc>().add(
                                                      GetTopRatedEvent(
                                                        page: 1,
                                                        tags: context
                                                            .read<TagBloc>()
                                                            .state
                                                            .selectedTags,
                                                        isFasting: context
                                                            .read<
                                                                HomeFastingToggleBloc>()
                                                            .state,
                                                      ),
                                                    );
                                              }
                                            },
                                            child: Text(
                                              AppLocalizations.of(context)!
                                                  .retryText,
                                              style: GoogleFonts.poppins(
                                                color: Colors.red,
                                              ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    );
                                  }
                                }

                                if ((state as TopRatedState).popular!.isEmpty) {
                                  return Center(
                                    child: Column(
                                      children: [
                                        SizedBox(height: 2.h),
                                        Text(
                                          AppLocalizations.of(context)!
                                              .noTopRatedText,
                                          style: const TextStyle(
                                              color: Colors.red),
                                        ),
                                        SizedBox(height: 2.h)
                                      ],
                                    ),
                                  );
                                }

                                return PopularItems(popular: (state).popular);
                              },
                            ),
                            SizedBox(height: 2.h),

                            //* Nearby Or Recommended Title
                            Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Text(
                                  (context.read<UserLocationBloc>().state
                                          is UserLocationLoaded)
                                      ? AppLocalizations.of(context)!.nearByText
                                      : AppLocalizations.of(context)!
                                          .recommendedText,
                                  style: titleTextStyle.copyWith(
                                    fontSize: 17.sp,
                                  ),
                                ),
                                BlocBuilder<HomePageNearbyRestaurantBloc,
                                    HomePageNearbyRestaurantState>(
                                  builder: (context, state) {
                                    if (state is NearbyRestaurantFetched) {
                                      return Text(
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryColor),
                                          "${state.totalItems?.toString() ?? ""} ${state.totalItems != null ? "restaurants" : ""}");
                                    } else if (state
                                        is NearbyRestaurantFetchedFromLocal) {
                                      return Text(
                                          "${state.restaurants.length} restaurants",
                                          style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w600,
                                              color: AppColors.primaryColor));
                                    } else {
                                      return Container();
                                    }
                                  },
                                ),
                              ],
                            ),
                            SizedBox(height: .8.h),
                            (context.read<UserLocationBloc>().state
                                    is UserLocationLoaded)
                                ? BlocConsumer<HomePageNearbyRestaurantBloc,
                                    HomePageNearbyRestaurantState>(
                                    listener: (context, state) {
                                      if (state
                                          is NearbyRestaurantFetchedFromLocal) {
                                        _offlineDataOverlayController.show();
                                      } else {
                                        _offlineDataOverlayController.hide();
                                      }
                                    },
                                    builder: (context, state) {
                                      if (state is NearbyLoading) {
                                        return const RecommendedItemsShimmer();
                                      } else if (state
                                          is NearbyRestaurantNextLoading) {
                                        return Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ...mapRestaurants(
                                                        state.restaurants)
                                                    .toList(),
                                              ],
                                            ),
                                            const RecommendedItemsShimmer(
                                              shimmerCount: 1,
                                            ),
                                          ],
                                        );
                                      } else if (state
                                          is RestaurantStateWithRestaurants) {
                                        final restaurants = state.restaurants;
                                        if (restaurants.isEmpty) {
                                          return ErrorAndInfoDisplayWidget(
                                            assetImage:
                                                'assets/icons/no_content.svg',
                                            title: AppLocalizations.of(context)!
                                                .noResultText,
                                            description:
                                                AppLocalizations.of(context)!
                                                    .tryAgainOnlyText,
                                            onPressed: () {
                                              if (locationState
                                                  is UserLocationLoaded) {
                                                context
                                                    .read<
                                                        HomePageNearbyRestaurantBloc>()
                                                    .add(
                                                      GetNearByRestaurants(
                                                        lat: locationState
                                                            .location.latitude,
                                                        lng: locationState
                                                            .location.longitude,
                                                        tags: context
                                                            .read<TagBloc>()
                                                            .state
                                                            .selectedTags,
                                                        page: 1,
                                                      ),
                                                    );
                                              }
                                            },
                                          );
                                        }
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ...mapRestaurants(restaurants)
                                                .toList(),
                                            if (state.hasReachedMax)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Center(
                                                  child: Text(
                                                    "${AppLocalizations.of(context)!.noMoreRestaurantsText} :(",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      } else if (state
                                          is NearbyRestaurantFailure) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              ErrorAndInfoDisplayWidget(
                                                assetImage:
                                                    "assets/icons/no_internet.svg",
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .noResultText,
                                                description:
                                                    AppLocalizations.of(
                                                            context)!
                                                        .tryAgainOnlyText,
                                                onPressed: () {
                                                  if (locationState
                                                      is UserLocationLoaded) {
                                                    context
                                                        .read<
                                                            HomePageNearbyRestaurantBloc>()
                                                        .add(
                                                          GetNearByRestaurants(
                                                            lat: locationState
                                                                .location
                                                                .latitude,
                                                            lng: locationState
                                                                .location
                                                                .longitude,
                                                            tags: context
                                                                .read<TagBloc>()
                                                                .state
                                                                .selectedTags,
                                                            page: 1,
                                                          ),
                                                        );
                                                  }
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      }
                                      return Container();
                                    },
                                  )
                                : BlocBuilder<RecommendedBloc,
                                    RecommendedState>(
                                    builder: (context, state) {
                                      if (state
                                          is RecommendedRestaurantLoading) {
                                        return const RecommendedItemsShimmer();
                                      } else if (state
                                          is RecommendedRestaurantNextLoading) {
                                        return Column(
                                          children: [
                                            Column(
                                              crossAxisAlignment:
                                                  CrossAxisAlignment.start,
                                              children: [
                                                ...mapRecommendedRestaurants(
                                                  state.restaurants,
                                                ).toList(),
                                              ],
                                            ),
                                            const RecommendedItemsShimmer(
                                              shimmerCount: 1,
                                            ),
                                          ],
                                        );
                                      } else if (state
                                          is RecommendedRestaurantFailure) {
                                        return Center(
                                          child: Column(
                                            mainAxisAlignment:
                                                MainAxisAlignment.center,
                                            children: <Widget>[
                                              ErrorAndInfoDisplayWidget(
                                                assetImage:
                                                    "assets/icons/no_internet.svg",
                                                title: AppLocalizations.of(
                                                        context)!
                                                    .noResultText,
                                                description:
                                                    AppLocalizations.of(
                                                            context)!
                                                        .tryAgainOnlyText,
                                                onPressed: () {
                                                  context
                                                      .read<RecommendedBloc>()
                                                      .add(
                                                        GetRecommendedEvent(
                                                          page: 1,
                                                          tags: context
                                                              .read<TagBloc>()
                                                              .state
                                                              .selectedTags,
                                                        ),
                                                      );
                                                },
                                              ),
                                            ],
                                          ),
                                        );
                                      } else if (state
                                          is RecommendedRestaurantFetched) {
                                        final restaurants = state.restaurants;

                                        if (restaurants.isEmpty) {
                                          return ErrorAndInfoDisplayWidget(
                                            assetImage:
                                                'assets/icons/no_content.svg',
                                            title: AppLocalizations.of(context)!
                                                .noRecommendationsText,
                                            description:
                                                AppLocalizations.of(context)!
                                                    .tryAgainOnlyText,
                                            onPressed: () {
                                              if (locationState
                                                  is UserLocationLoaded) {
                                                context
                                                    .read<RecommendedBloc>()
                                                    .add(
                                                      GetRecommendedEvent(
                                                        tags: context
                                                            .read<TagBloc>()
                                                            .state
                                                            .selectedTags,
                                                        page: state.page,
                                                      ),
                                                    );
                                              }
                                            },
                                          );
                                        }
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            ...mapRecommendedRestaurants(
                                                    restaurants)
                                                .toList(),
                                            if (state.hasReachedMax)
                                              Padding(
                                                padding:
                                                    const EdgeInsets.all(16.0),
                                                child: Center(
                                                  child: Text(
                                                    "${AppLocalizations.of(context)!.noMoreRestaurantsText} :(",
                                                    style: GoogleFonts.poppins(
                                                      color: Colors.grey,
                                                      fontSize: 13,
                                                    ),
                                                  ),
                                                ),
                                              ),
                                          ],
                                        );
                                      }

                                      return Container();
                                    },
                                  ),
                          ],
                        ),
                      );
                    },
                  );
                },
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future onTagFilter() {
    // context.read<PopularBloc>().reset();
    if (context.read<UserLocationBloc>().state is UserLocationLoaded) {
      var userLocation =
          (context.read<UserLocationBloc>().state as UserLocationLoaded)
              .location;

      context.read<PopularBloc>().add(
            GetTopRatedEvent(
              page: 1,
              lat: userLocation.latitude,
              lng: userLocation.longitude,
              tags: context.read<TagBloc>().state.selectedTags,
            ),
          );
      context.read<HomePageNearbyRestaurantBloc>().add(
            GetNearByRestaurants(
              lat: userLocation.latitude,
              lng: userLocation.longitude,
              tags: context.read<TagBloc>().state.selectedTags,
              page: 1,
            ),
          );
    } else {
      context.read<PopularBloc>().add(
            GetTopRatedEvent(
              page: 1,
              tags: context.read<TagBloc>().state.selectedTags,
            ),
          );
      context.read<RecommendedBloc>().add(
            GetRecommendedEvent(
              page: 1,
              tags: context.read<TagBloc>().state.selectedTags,
            ),
          );
    }

    return Future.delayed(
      const Duration(
        seconds: 1,
      ),
    );
  }

  Future refresh() {
    // context.read<PopularBloc>().reset();
    context.read<SearchFoodCategoryBloc>().add(GetCategorySuggestion());

    if (context.read<UserLocationBloc>().state is UserLocationLoaded) {
      var userLocation =
          (context.read<UserLocationBloc>().state as UserLocationLoaded)
              .location;
      context.read<PopularBloc>().add(
            GetTopRatedEvent(
              page: 1,
              lat: userLocation.latitude,
              lng: userLocation.longitude,
              tags: context.read<TagBloc>().state.selectedTags,
              isFasting: context.read<HomeFastingToggleBloc>().state,
            ),
          );
      context.read<HomePageNearbyRestaurantBloc>().add(
            GetNearByRestaurants(
              lat: userLocation.latitude,
              lng: userLocation.longitude,
              tags: context.read<TagBloc>().state.selectedTags,
              page: 1,
            ),
          );
    } else {
      context.read<PopularBloc>().add(
            GetTopRatedEvent(
              page: 1,
              tags: context.read<TagBloc>().state.selectedTags,
              isFasting: context.read<HomeFastingToggleBloc>().state,
            ),
          );
      context.read<RecommendedBloc>().add(
            GetRecommendedEvent(
              page: 1,
              tags: context.read<TagBloc>().state.selectedTags,
            ),
          );
    }

    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
    if (user != null) {
      context.read<UnreadNotificationsCounterBloc>().add(
            GetUnreadNotificationsCount(
              userId: user.id!,
            ),
          );
      context.read<OrdersCountBloc>().add(
            FetchOrdersCount(
              userId: user.id!,
              status: "Pending",
            ),
          );
    }
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onRecommendedScroll)
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<HomePageNearbyRestaurantBloc>().state;
    if (state is NearbyRestaurantFetched && state.hasReachedMax && _isBottom) {
      return;
    }
    if (state is NearbyRestaurantFetched && _isBottom && !state.hasReachedMax) {
      var userLocation =
          (context.read<UserLocationBloc>().state as UserLocationLoaded)
              .location;
      context.read<HomePageNearbyRestaurantBloc>().add(
            GetNearByRestaurants(
              page: state.page,
              tags: context.read<TagBloc>().state.selectedTags,
              lat: userLocation.latitude,
              lng: userLocation.longitude,
            ),
          );
    }
  }

  void _onRecommendedScroll() {
    final state = context.read<RecommendedBloc>().state;

    if (state is RecommendedRestaurantFetched &&
        state.hasReachedMax &&
        _isBottom) {
      return;
    }
    if (state is RecommendedRestaurantFetched &&
        _isBottom &&
        !state.hasReachedMax) {
      context.read<RecommendedBloc>().add(
            GetRecommendedEvent(
              page: state.page,
              tags: context.read<TagBloc>().state.selectedTags,
            ),
          );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll == maxScroll;
  }
}

class HomeFastingToggleBloc extends Cubit<bool> {
  HomeFastingToggleBloc() : super(false);
  toggleSwitch() => emit(!state);
}
