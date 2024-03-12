import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import '../../../discover/discover.dart';

import 'package:rateeat_mobile/src/features/map_section/domain/domain.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_event.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/categories.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/dropdown.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/restaurant.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/search_page_filter.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/search_result.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/utils/external_app_intent.dart';
import '../../../../core/widgets/custom_persistent_bottom_navbar.dart';
import '../../../homepage/data/data.dart';
import '../../../map_section/data/models/restaurant_location_model.dart';
import '../bloc/items_filter_search_result/items_filter_results_state.dart';
import '../bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import '../bloc/restaurants_filter_search_result/restaurants_filter_results_event.dart';
import '../bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';
import '../widgets/filter_bottom_sheet.dart';
import '../widgets/item_result.dart';
import '../widgets/items_resutls_card_widget.dart';
import '../widgets/shimmer/item_search_results_shimmer.dart';
import '../widgets/shimmer/restaurant_search_result_shimmer.dart';

class SearchResultPage extends StatefulWidget {
  const SearchResultPage({super.key});

  @override
  State<SearchResultPage> createState() => _SearchResultPageState();
}

class _SearchResultPageState extends State<SearchResultPage>
    with SingleTickerProviderStateMixin {
  late TabController tabController;
  int limit = 7;
  final _itemScrollController = ScrollController();
  final _restaurantScrollController = ScrollController();
  @override
  void initState() {
    SchedulerBinding.instance
        .addPostFrameCallback((_) => listenShareMediaFiles(context));
    tabController = TabController(length: 2, vsync: this);
    _itemScrollController.addListener(_onItemScroll);
    _restaurantScrollController.addListener(_onRestaurantScroll);
    var locationState = context.read<UserLocationBloc>().state;
    var currentRestaurantsFetchState =
        context.read<RestaurantsFilterSearchResultsBloc>().state;
    var currentItemsFetchState =
        context.read<ItemsFilterSearchResultsBloc>().state;
    if (locationState is UserLocationLoaded &&
        currentRestaurantsFetchState is! FilterRestaurantsSuccess) {
      context.read<RestaurantsFilterSearchResultsBloc>().add(
            GetFilteredRestaurantEvent(
              category: context.read<CategoriesToggleBloc>().state,
              searchQuery: '',
              location: Location(
                latitude: locationState.location.latitude,
                longitude: locationState.location.longitude,
              ),
              selection: RestaurantsFilterState.highestRated,
              isFasting: false,
              rating: 1,
              maximumPrice: 5000,
            ),
          );
    }
    if (locationState is UserLocationLoaded &&
        currentItemsFetchState is! FilterItemsSuccess) {
      context.read<ItemsFilterSearchResultsBloc>().add(
            GetFilteredItemsEvent(
              searchQuery: '',
              location: Location(
                latitude: locationState.location.latitude,
                longitude: locationState.location.longitude,
              ),
              selection: ItemsFilterState.highestRated,
              isFasting: false,
              rating: 1,
              maximumPrice: 5000,
            ),
          );
    }
    context.read<SearchPageCubit>().changePage(1);
    super.initState();
  }

  @override
  void dispose() {
    _itemScrollController
      ..removeListener(_onItemScroll)
      ..dispose();
    _restaurantScrollController
      ..removeListener(_onRestaurantScroll)
      ..dispose();
    super.dispose();
  }

  void _onRestaurantScroll() {
    final state = context.read<RestaurantsFilterSearchResultsBloc>().state;
    final locationState = context.read<UserLocationBloc>().state;
    if ((state is FilterRestaurantsSuccess) &&
        state.hasReachedMax &&
        _isRestaurantBottom) {
      return;
    }
    if (_isRestaurantBottom &&
        (state is FilterRestaurantsSuccess) &&
        !state.hasReachedMax) {
      var prevPage = context.read<SearchPageCubit>().state;

      context.read<SearchPageCubit>().changePage(prevPage + 1);
      if (locationState is UserLocationLoaded) {
        context.read<RestaurantsFilterSearchResultsBloc>().add(
              GetFilteredRestaurantEvent(
                page: prevPage + 1,
                limit: limit,
                category: state.category,
                isFasting: state.isFasting,
                searchQuery: state.searchQuery,
                selection: state.selection,
                location: Location(
                  latitude: locationState.location.latitude,
                  longitude: locationState.location.longitude,
                ),
                rating: state.rating,
                maximumPrice: state.maximumPrice,
              ),
            );
      }
    }
  }

  bool get _isRestaurantBottom {
    if (!_restaurantScrollController.hasClients) return false;
    return _restaurantScrollController.position.maxScrollExtent ==
        _restaurantScrollController.position.pixels;
  }

  void _onItemScroll() {
    final state = context.read<ItemsFilterSearchResultsBloc>().state;
    final locationState = context.read<UserLocationBloc>().state;
    if ((state is FilterItemsSuccess) && state.hasReachedMax && _isItemBottom) {
      return;
    }
    if (_isItemBottom &&
        (state is FilterItemsSuccess) &&
        !state.hasReachedMax) {
      var prevPage = context.read<SearchPageCubit>().state;
      context.read<SearchPageCubit>().changePage(prevPage + 1);
      if (locationState is UserLocationLoaded) {
        context.read<ItemsFilterSearchResultsBloc>().add(
              GetFilteredItemsEvent(
                page: prevPage + 1,
                limit: limit,
                isFasting: state.isFasting,
                searchQuery: state.searchQuery,
                selection: state.selection,
                location: locationState.location,
                rating: state.rating,
                maximumPrice: state.maximumPrice,
              ),
            );
      }
    }
  }

  bool get _isItemBottom {
    if (!_itemScrollController.hasClients) return false;
    return _itemScrollController.position.maxScrollExtent ==
        _itemScrollController.position.pixels;
  }

  @override
  Widget build(context) {
    double screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.read<DiscoverSelectedScreenCubit>().toDiscoverOptionsPage();
          context.read<BottomNavigationCubit>().changeIndex(1);
          context.goNamed(
            AppRoutes.home,
          );
        }
      },
      child: BlocConsumer<UserLocationBloc, UserLocationState>(
        listener: (context, userLocationState) {
          if (userLocationState is UserLocationError) {}
          if (userLocationState is UserLocationLoaded) {
            context.read<RestaurantsFilterSearchResultsBloc>().add(
                  GetFilteredRestaurantEvent(
                    category: context.read<CategoriesToggleBloc>().state,
                    searchQuery: '',
                    location: Location(
                      latitude: userLocationState.location.latitude,
                      longitude: userLocationState.location.longitude,
                    ),
                    selection: RestaurantsFilterState.highestRated,
                    isFasting: false,
                    rating: 1,
                    maximumPrice: 5000,
                  ),
                );
          }
        },
        builder: (context, locationState) {
          if (locationState is UserLocationLoading) {
            return Center(
              child: LoadingAnimationWidget.dotsTriangle(
                key: const Key("loadingAnimation"),
                color: AppColors.primaryColor,
                size: screenHeight * 0.04,
              ),
            );
          }
          if (locationState is UserLocationError) {
            return SizedBox(
              height: 80.h,
              child: ErrorAndInfoDisplayWidget(
                assetImage: "assets/images/no_location_service.svg",
                title: "Unable to get user location",
                description: "Allow location service to use RateEat",
                onPressed: () {
                  context.read<UserLocationBloc>().add(const GetUserLocation());
                },
              ),
            );
          }
          if (locationState is UserLocationLoaded) {
            return BlocProvider(
              create: (context) => MultiChipsCubit(),
              child: Scaffold(
                appBar: PreferredSize(
                  preferredSize: Size.fromHeight(screenHeight * 0.08),
                  child: AppBar(
                    automaticallyImplyLeading: false,
                    scrolledUnderElevation: 0,
                    flexibleSpace: SearchAndDiscoverPagesFilter(
                      onFilterPressed: () {
                        showModalBottomSheet(
                          elevation: 1,
                          context: context,
                          isScrollControlled: true,
                          backgroundColor: Colors.white,
                          shape: const RoundedRectangleBorder(
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(20),
                            ),
                          ),
                          clipBehavior: Clip.hardEdge,
                          builder: (context) {
                            return const FilterBottomSheet();
                          },
                        );
                      },
                    ),
                    centerTitle: true,
                  ),
                ),
                body: Column(
                  children: [
                    ItemCategories(
                      tabController: tabController,
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Padding(
                          padding: const EdgeInsets.only(left: 20, bottom: 10),
                          child: Text(
                            AppLocalizations.of(context)!.resultText,
                            style: medium18,
                          ),
                        ),
                        const DropdownFilter(),
                      ],
                    ),
                    Expanded(
                      child: BlocBuilder<CategoriesToggleBloc, int>(
                          builder: (context, state) {
                        if (state == 0) {
                          return BlocBuilder<RestaurantsFilterSearchResultsBloc,
                              RestaurantsFilterSearchResultsState>(
                            builder: (context, state) {
                              if (state is FilterRestaurantsFailure) {
                                return Center(
                                  child: Column(
                                    mainAxisAlignment: MainAxisAlignment.center,
                                    children: <Widget>[
                                      ErrorAndInfoDisplayWidget(
                                        assetImage:
                                            "assets/icons/no_internet.svg",
                                        title: "Loading results failed.",
                                        description:
                                            "Unable to load results. Please try again.",
                                        onPressed: () {
                                          context
                                              .read<
                                                  RestaurantsFilterSearchResultsBloc>()
                                              .add(
                                                GetFilteredRestaurantEvent(
                                                  category: state.category,
                                                  isFasting: state.isFasting,
                                                  searchQuery:
                                                      state.searchQuery,
                                                  selection: state.selection,
                                                  location:
                                                      locationState.location,
                                                  rating: state.rating,
                                                  maximumPrice:
                                                      state.maximumPrice,
                                                ),
                                              );
                                        },
                                      ),
                                    ],
                                  ),
                                );
                              }
                              if (state is FilterRestaurantsNextLoading) {
                                final restaurants =
                                    state.searchFilteredRestaurants;
                                return SingleChildScrollView(
                                  physics: const BouncingScrollPhysics(),
                                  controller: _restaurantScrollController,
                                  child: Column(
                                    children: [
                                      ...mapRestaurants(restaurants).toList(),
                                      Column(
                                        children: [
                                          SizedBox(height: screenHeight * 0.01),
                                          const RestaurantResultsShimmer(
                                            shimmerCount: 1,
                                          ),
                                          SizedBox(height: screenHeight * 0.01),
                                        ],
                                      )
                                    ],
                                  ),
                                );
                              } else if (state is FilterRestaurantsSuccess) {
                                if (state.status == false) {
                                  var prevPage =
                                      context.read<SearchPageCubit>().state;
                                  context
                                      .read<SearchPageCubit>()
                                      .changePage(prevPage - 1);
                                }
                                if (state.searchFilteredRestaurants.isEmpty) {
                                  return const EmptyResultWidget();
                                }
                                final restaurants =
                                    state.searchFilteredRestaurants;
                                return SingleChildScrollView(
                                  controller: _restaurantScrollController,
                                  key: const Key('restaurant_scroll'),
                                  child: Column(
                                    children: [
                                      ...mapRestaurants(restaurants).toList(),
                                      if (state.hasReachedMax)
                                        // A text widget that say's That's All
                                        Padding(
                                          padding: const EdgeInsets.all(16.0),
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
                                  ),
                                );
                              }
                              if (state is FilterRestaurantsLoading) {
                                return const RestaurantResultsShimmer();
                              }
                              return Container();
                            },
                          );
                        }
                        return BlocBuilder<ItemsFilterSearchResultsBloc,
                                ItemsFilterSearchResultsState>(
                            builder: (context, state) {
                          if (state is FilterItemsNextLoading) {
                            final items = state.searchFilteredItems;

                            return SingleChildScrollView(
                              physics: const BouncingScrollPhysics(),
                              controller: _itemScrollController,
                              child: Column(
                                children: [
                                  ...mapItems(items),
                                  Column(
                                    children: [
                                      SizedBox(height: screenHeight * 0.01),
                                      const ItemSearchResultsShimmer(
                                        shimmerCount: 1,
                                      ),
                                      SizedBox(height: screenHeight * 0.01),
                                    ],
                                  ),
                                ],
                              ),
                            );
                          } else if (state is FilterItemsSuccess) {
                            if (state.status == false) {
                              var prevPage =
                                  context.read<SearchPageCubit>().state;
                              context
                                  .read<SearchPageCubit>()
                                  .changePage(prevPage - 1);
                            }
                            if (state.searchFilteredItems.isEmpty) {
                              return const EmptyResultWidget();
                            }
                            final items = state.searchFilteredItems;
                            return SingleChildScrollView(
                              controller: _itemScrollController,
                              child: Column(
                                children: [
                                  ...mapItems(items).toList(),
                                  if (state.hasReachedMax)
                                    Padding(
                                      padding: const EdgeInsets.all(16.0),
                                      child: Center(
                                        child: Text(
                                          "${AppLocalizations.of(context)!.noMoreItemsText} :(",
                                          style: GoogleFonts.poppins(
                                            color: Colors.grey,
                                            fontSize: 13,
                                          ),
                                        ),
                                      ),
                                    ),
                                ],
                              ),
                            );
                          } else if (state is FilterItemsLoading) {
                            return const ItemSearchResultsShimmer();
                          } else if (state is FilterItemsFailure ||
                              state is FilterItemsFailure) {
                            return ErrorAndInfoDisplayWidget(
                              assetImage: "assets/icons/no_internet.svg",
                              title: "Unable to load items.",
                              description:
                                  "Loading items failed. Please try again.",
                              onPressed: () {
                                context
                                    .read<ItemsFilterSearchResultsBloc>()
                                    .add(
                                      GetFilteredItemsEvent(
                                        isFasting: state.isFasting,
                                        searchQuery: state.searchQuery,
                                        selection: state.selection,
                                        location: locationState.location,
                                        rating: state.rating,
                                        maximumPrice: state.maximumPrice,
                                      ),
                                    );
                              },
                            );
                          }
                          return Container();
                        });
                      }),
                    ),
                  ],
                ),
              ),
            );
          }
          return Container();
        },
      ),
    );
  }

  mapRestaurants(List<Restaurant> restaurants) {
    return restaurants.map(
      (restaurant) => RestaurantCard(
        restaurant: restaurant,
        restaurantLocation: Location.fromRestaurantLocationModel(
          restaurant.restaurantLocations![0] as RestaurantLocationModel,
        ),
      ),
    );
  }

  List<Widget> mapItems(List<ItemModel> items) {
    return [
      for (var item in items)
        Padding(
          padding: EdgeInsets.symmetric(
            vertical: 1.2.h,
            horizontal: 2.w,
          ),
          child: ItemSearchResultCard(item: item),
        ),
    ];
  }
}

class CategoriesToggleBloc extends Cubit<int> {
  CategoriesToggleBloc() : super(0);

  toggleSwitch(int index) {
    emit(index);
  }
}

class MultiChipsCubit extends Cubit<int> {
  MultiChipsCubit() : super(6);
  void changeState(value) => emit(value);
}
