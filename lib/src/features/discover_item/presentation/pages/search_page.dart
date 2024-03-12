import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/data/models/search_result.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/near_by_rest_event.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/nearby/nearby_rest_state.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/pages/filter_modal_sheet.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/pages/item_result_page.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/search_restaurant_state.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/search_restaurant.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/selected_restaurant.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/selected_restaurant_event.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/shimmer/restaurant_search_result_shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/widgets/custom_persistent_bottom_navbar.dart';
import '../../../search_result/presentation/widgets/restaurant.dart';
import '../bloc/filter/filter_items_bloc.dart';
import '../bloc/filter/filter_items_event.dart';
import '../bloc/search/search_restaurant_event.dart' as search_event;

class SearchRestaurantPage extends StatefulWidget {
  const SearchRestaurantPage({super.key});

  @override
  SearchRestaurantPageState createState() => SearchRestaurantPageState();
}

class SearchRestaurantPageState extends State<SearchRestaurantPage> {
  TextEditingController searchRestaurantController = TextEditingController();

  bool isSearch = false;
  int limit = 7;
  @override
  void initState() {
    super.initState();

    var locationState = context.read<UserLocationBloc>().state;
    if (locationState is UserLocationLoaded) {
      context.read<HomePageNearbyRestaurantBloc>().add(
            GetNearByRestaurants(
              lat: locationState.location.latitude,
              lng: locationState.location.longitude,
              tags: const [],
              page: 1,
              limit: 10,
            ),
          );
    }
  }

  @override
  void dispose() {
    searchRestaurantController.dispose();

    super.dispose();
  }

  bool getUser() {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      return user != null;
    } on CacheException {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    final locationState = BlocProvider.of<UserLocationBloc>(context).state;
    // final screenHeight = MediaQuery.of(context).size.height;
    // final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        onTap: () {
          context.pop();
        },
        title: AppLocalizations.of(context)!.searchRestaurantText,
      ),
      body: Column(
        children: [
          // verticalPadding(height: 4),
          SizedBox(
            height: 4.h,
          ),
          Padding(
            padding: EdgeInsets.symmetric(horizontal: 5.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                CustomTextInputField(
                  hintText: AppLocalizations.of(context)!.searchRestText,
                  canRequestFocus: true,
                  controller: searchRestaurantController,
                  onCancelled: () {
                    searchRestaurantController.clear();
                  },
                  onChanged: (query) {
                    if (query.trim().isNotEmpty) {
                      setState(() {
                        isSearch = true;
                        searchRestaurantController.text = query.trim();
                      });
                      context.read<SearchRestaurantsBloc>().add(
                          search_event.RestaurantSearchSubmitted(
                              query: query.trim()));
                    }
                  },
                ),
              ],
            ),
          ),
          isSearch
              ? Expanded(
                  child:
                      BlocBuilder<SearchRestaurantsBloc, SearchRestaurantState>(
                    builder: (context, state) {
                      if (state is SearchRestaurantLoading) {
                        return Center(
                          key: const Key("searchrestaurantloading"),
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.dotsTriangle(
                                color: AppColors.primaryColor,
                                size: 60,
                              ),
                              //verticalPadding(height: 2),
                              SizedBox(
                                height: 2.h,
                              ),
                              Text(AppLocalizations.of(context)!.loadingText),
                            ],
                          ),
                        );
                      } else if (state is SearchRestaurantSuccess) {
                        final results = state.restaurants;
                        if (results.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              ErrorAndInfoDisplayWidget(
                                assetImage: 'assets/icons/no_content.svg',
                                title:
                                    AppLocalizations.of(context)!.noResultText,
                                description:
                                    AppLocalizations.of(context)!.searchNoText,
                                onPressed: null,
                              ),
                              const SizedBox(
                                height: 10,
                              ),
                              TextButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStatePropertyAll(
                                      AppColors.primaryColor.withOpacity(.15)),
                                ),
                                onPressed: getUser()
                                    ? () {
                                        context.pushNamed(
                                            AppRoutes.candidateRestaurantPage);
                                      }
                                    : () {
                                        _showLoginDialog(context);
                                      },
                                child: Padding(
                                  padding: const EdgeInsets.symmetric(
                                      horizontal: 8.0, vertical: 2),
                                  child: Text(
                                    "Suggest restaurant",
                                    style: headingStyle2.copyWith(
                                      color: AppColors.primaryColor,
                                    ),
                                  ),
                                ),
                              ),
                              const Spacer(flex: 2),
                            ],
                          );
                        } else {
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              SizedBox(
                                height: 2.h,
                              ),
                              Padding(
                                padding: EdgeInsets.symmetric(horizontal: 6.w),
                                child: Text(AppLocalizations.of(context)!
                                    .searchResultText),
                              ),
                              SizedBox(
                                height: 2.h,
                              ),
                              Expanded(
                                child: ListView.builder(
                                  shrinkWrap: true,
                                  itemCount: results.length,
                                  itemBuilder:
                                      (BuildContext context, int index) {
                                    return InkWell(
                                      onTap: () {
                                        var locationState = context
                                            .read<UserLocationBloc>()
                                            .state;
                                        if (locationState
                                            is UserLocationLoaded) {
                                          //* Update the Filter Options

                                          context
                                              .read<
                                                  DiscoverMenuRatingSelectorCubit>()
                                              .changeRating(0.0);
                                          context
                                              .read<FilterItemsBloc>()
                                              .add(ResetFilterItemsEvent());
                                          //* Make page one
                                          context
                                              .read<DiscoveryItemPageCubit>()
                                              .changePage(1);
                                          //* Get the filtered items
                                          context.read<FilterItemsBloc>().add(
                                                GetFilteredItemsEvent(
                                                  restaurantId: state
                                                      .restaurants[index].id,
                                                  maxPrice: context
                                                      .read<
                                                          DiscoverMenuPriceSelectorCubit>()
                                                      .state,
                                                  fasting: context
                                                      .read<
                                                          DiscoverMenuFastingSelectorCubit>()
                                                      .state,
                                                  sortingQuery: "rating",
                                                  searchQuery: "",
                                                ),
                                              );

                                          //* Navigate to result page
                                          context
                                              .read<
                                                  DiscoverSelectedScreenCubit>()
                                              .toDiscoverItemsResult();

                                          // ? Giving initial index to home
                                          context.pushNamed(
                                            AppRoutes.home,
                                            extra: {
                                              'fromOtherPages': 'yes',
                                              'id': 1,
                                            },
                                          );
                                          context
                                              .read<SelectedRestaurantBloc>()
                                              .add(
                                                RestaurantSelected(
                                                  selectedRestaurant:
                                                      RestaurantResult(
                                                    id: state
                                                        .restaurants[index].id,
                                                    name: state
                                                        .restaurants[index]
                                                        .name,
                                                  ),
                                                ),
                                              );
                                        }
                                      },
                                      child: Padding(
                                        padding: EdgeInsets.symmetric(
                                            horizontal: 5.w),
                                        child: SearchResultTile(
                                          title: results[index].name,
                                        ),
                                      ),
                                    );
                                  },
                                ),
                              ),
                            ],
                          );
                        }
                      } else if (state is SearchRestaurantInitial) {
                        return Column(
                          children: [
                            ErrorAndInfoDisplayWidget(
                              assetImage: 'assets/icons/write_something.svg',
                              title:
                                  AppLocalizations.of(context)!.searchStartText,
                              description:
                                  AppLocalizations.of(context)!.searchDescText,
                              onPressed: null,
                            ),
                          ],
                        );
                      } else {
                        return Column(
                          children: [
                            ErrorAndInfoDisplayWidget(
                              assetImage: 'assets/icons/no_internet.svg',
                              title: AppLocalizations.of(context)!
                                  .unknownErrorText,
                              description:
                                  AppLocalizations.of(context)!.tryAgainText,
                              onPressed: null,
                            ),
                          ],
                        );
                      }
                    },
                  ),
                )
              : BlocBuilder<HomePageNearbyRestaurantBloc,
                  HomePageNearbyRestaurantState>(
                  builder: (context, state) {
                    if (state is NearbyLoading) {
                      return const Expanded(
                          key: Key("NearyByLoading"),
                          child: RestaurantResultsShimmer());
                    } else if (state is NearbyRestaurantFetched) {
                      final restaurants = state.restaurants;
                      if (restaurants.isEmpty) {
                        return ErrorAndInfoDisplayWidget(
                          assetImage: 'assets/icons/no_content.svg',
                          title: AppLocalizations.of(context)!.noResultText,
                          description: AppLocalizations.of(context)!.applyText,
                          onPressed: () {
                            var locationState =
                                context.read<UserLocationBloc>().state;
                            if (locationState is UserLocationLoaded) {
                              context.read<HomePageNearbyRestaurantBloc>().add(
                                    GetNearByRestaurants(
                                      lat: locationState.location.latitude,
                                      lng: locationState.location.longitude,
                                      tags: const [],
                                      page: 1,
                                      limit: 10,
                                    ),
                                  );
                            }
                          },
                        );
                      }
                      return Expanded(
                        child: SingleChildScrollView(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 28, vertical: 10),
                                child: Text(
                                  "near by",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                  ),
                                ),
                              ),
                              //   const SizedBox(height: 10,),
                              ...mapRestaurants(restaurants).toList(),
                            ],
                          ),
                        ),
                      );
                    } else if (state is NearbyRestaurantFailure) {
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            ErrorAndInfoDisplayWidget(
                              assetImage: "assets/icons/no_internet.svg",
                              title: AppLocalizations.of(context)!.noResultText,
                              description:
                                  AppLocalizations.of(context)!.searchNoText,
                              onPressed: () {
                                if (locationState is UserLocationLoaded) {
                                  context
                                      .read<HomePageNearbyRestaurantBloc>()
                                      .add(
                                        GetNearByRestaurants(
                                          lat: locationState.location.latitude,
                                          lng: locationState.location.longitude,
                                          tags: const [],
                                          page: 1,
                                          limit: 10,
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
        ],
      ),
    );
  }

  mapRestaurants(List<RestaurantModel> restaurants) {
    return restaurants.map(
      (restaurant) => RestaurantCard(
        onPressed: () {
          // var locationState = context.read<UserLocationBloc>().state;
          context.read<FilterItemsBloc>().add(
                GetFilteredItemsEvent(
                  restaurantId: restaurant.id!,
                  maxPrice:
                      context.read<DiscoverMenuPriceSelectorCubit>().state,
                  fasting:
                      context.read<DiscoverMenuFastingSelectorCubit>().state,
                  sortingQuery: "rating",
                  searchQuery: "",
                  categoryId: context
                      .read<DiscoverMenuSelectedCategoryCubit>()
                      .state['categoryId'],
                ),
              );

          //* Navigate to result page
          context.read<DiscoverSelectedScreenCubit>().toDiscoverItemsResult();

          context.pushNamed(
            AppRoutes.home,
            extra: {
              'fromOtherPages': 'yes',
              'id': 1,
            },
          );
          context.read<SelectedRestaurantBloc>().add(
                RestaurantSelected(
                  selectedRestaurant: RestaurantResult(
                    id: restaurant.id!,
                    name: restaurant.name!,
                  ),
                ),
              );
        },
        restaurant: restaurant,
        restaurantLocation: Location.fromRestaurantLocationModel(
            restaurant.restaurantLocations![0] as RestaurantLocationModel),
      ),
    );
  }
}

void _showLoginDialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text(
          AppLocalizations.of(context)!.loginRequiredText,
        ),
        content: Text(AppLocalizations.of(context)!.loginNeededText),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop(); // Close the dialog
            },
            child: Text(AppLocalizations.of(context)!.cancelText),
          ),
          TextButton(
            onPressed: () {
              var routeInfo = {'routeName': AppRoutes.candidateRestaurantPage};
              Navigator.of(ctx).pop(); // Close the dialog
              context.pushNamed(
                AppRoutes.login,
                extra: routeInfo,
              ); // Navigate to login screen
            },
            child: Text(AppLocalizations.of(context)!.loginText),
          ),
        ],
      );
    },
  );
}
