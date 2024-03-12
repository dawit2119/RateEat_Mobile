import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_event.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/item_result.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/restaurant.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/shimmer/restaurant_search_result_shimmer.dart';

import '../../../../core/core.dart';

class SearchResultCard extends StatefulWidget {
  const SearchResultCard({super.key});

  @override
  State<SearchResultCard> createState() => _SearchResultCardState();
}

class _SearchResultCardState extends State<SearchResultCard> {
  int limit = 7;
  final _itemScrollController = ScrollController();
  final _restaurantScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _itemScrollController.addListener(_onItemScroll);
    _restaurantScrollController.addListener(_onRestaurantScroll);
    var locationState = context.read<UserLocationBloc>().state;
    if (locationState is UserLocationLoaded) {
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
    context.read<SearchPageCubit>().changePage(1);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final locationState = BlocProvider.of<UserLocationBloc>(context).state;
    return BlocBuilder<RestaurantsFilterSearchResultsBloc,
        RestaurantsFilterSearchResultsState>(
      builder: (context, state) {
        if (state is FilterRestaurantsFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ErrorAndInfoDisplayWidget(
                  assetImage: "assets/icons/no_internet.svg",
                  title: AppLocalizations.of(context)!.noResultText,
                  description: AppLocalizations.of(context)!.searchNoText,
                  onPressed: () {
                    if (locationState is UserLocationLoaded) {
                      context.read<RestaurantsFilterSearchResultsBloc>().add(
                            GetFilteredRestaurantEvent(
                              category: state.category,
                              isFasting: state.isFasting,
                              searchQuery: state.searchQuery,
                              selection: state.selection,
                              location: locationState.location,
                              rating: state.rating,
                              maximumPrice: state.maximumPrice,
                            ),
                          );
                    }
                  },
                ),
              ],
            ),
          );
        }
        if (state is FilterRestaurantsNextLoading) {
          final restaurants = state.searchFilteredRestaurants;
          return Expanded(
            child: SingleChildScrollView(
              // physics: const BouncingScrollPhysics(),
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
            ),
          );
        } else if (state is FilterRestaurantsSuccess) {
          if (state.status == false) {
            var prevPage = context.read<SearchPageCubit>().state;
            context.read<SearchPageCubit>().changePage(prevPage - 1);
          }
          if (state.searchFilteredRestaurants.isEmpty) {
            return const EmptyResultWidget();
          }
          final restaurants = state.searchFilteredRestaurants;
          return Expanded(
            child: SingleChildScrollView(
              controller: _restaurantScrollController,
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
            ),
          );
        } else if (state is FilterRestaurantsLoading) {
          return const Expanded(child: RestaurantResultsShimmer());
        }
        // } else if (state is FilterItemsNextLoading) {
        //   final items = state.searchFilteredItems;
        //   return Expanded(
        //     child: SingleChildScrollView(
        //       // physics: const BouncingScrollPhysics(),
        //       controller: _itemScrollController,
        //       child: Column(
        //         children: [
        //           ...mapItems(items).toList(),
        //           Column(
        //             children: [
        //               SizedBox(height: screenHeight * 0.01),
        //               const ItemSearchResultsShimmer(
        //                 shimmerCount: 1,
        //               ),
        //               SizedBox(height: screenHeight * 0.01),
        //             ],
        //           )
        //         ],
        //       ),
        //     ),
        //   );
        // } else if (state is FilterItemsSuccess) {
        //   if (state.status == false) {
        //     var prevPage = context.read<SearchPageCubit>().state;
        //     context.read<SearchPageCubit>().changePage(prevPage - 1);
        //   }
        //   if (state.searchFilteredItems.isEmpty) {
        //     return const EmptyResultWidget();
        //   }
        //   final items = state.searchFilteredItems;
        //   return Expanded(
        //     child: SingleChildScrollView(
        //       controller: _itemScrollController,
        //       child: Column(
        //         children: [
        //           ...mapItems(items).toList(),
        //           if (state.hasReachedMax)
        //             // A text widget that say's That's All
        //             Padding(
        //               padding: const EdgeInsets.all(16.0),
        //               child: Center(
        //                 child: Text(
        //                   "${AppLocalizations.of(context)!.noMoreItemsText} :(",
        //                   style: GoogleFonts.poppins(
        //                     color: Colors.grey,
        //                     fontSize: 13,
        //                   ),
        //                 ),
        //               ),
        //             ),
        //         ],
        //       ),
        //     ),
        //   );
        // } else if (state is FilterItemsLoading) {
        //   return const Expanded(child: ItemSearchResultsShimmer());
        // } else if (state is FilterItemsFailure ||
        //     state is FilterRestaurantsFailure) {
        //   return ErrorDisplayWidget(
        //     assetImage: "assets/icons/no_internet.svg",
        //     errorMessage: "Unable to load items.",
        //     description: "Loading items failed. Please try again.",
        //     onPressed: () {
        //       if (locationState is UserLocationLoaded) {
        //         context.read<RestaurantsFilterSearchResultsBloc>().add(
        //               GetFilteredRestaurantEvent(
        //                 category: state.category,
        //                 isFasting: state.isFasting,
        //                 searchQuery: state.searchQuery,
        //                 selection: state.selection,
        //                 location: locationState.location,
        //                 rating: state.rating,
        //                 maximumPrice: state.maximumPrice,
        //               ),
        //             );
        //       }
        //     },
        //   );
        // }
        return Container();
      },
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

  mapItems(items) {
    if (items != null) {
      return items!.map(
        (item) => ItemResult(
          id: item.itemId,
          imageUrl: item.imageUrl!,
          rating: item.averageRating!,
          foodName: item.itemName,
          restaurantName: item.categories!.menu!.restaurant!.name!,
          price: item.price!,
          noOfReviews: item.numberOfReviews,
          ridingTime: item.ridingTime,
          walkingTime: item.walkingTime,
          distance: item.distance,
          currency: item.currencyCode,
        ),
      );
    }
    return [];
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
    final state = context.read<RestaurantsFilterSearchResultsBloc>().state;
    final locationState = context.read<UserLocationBloc>().state;
    if ((state is FilterRestaurantsSuccess) &&
        state.hasReachedMax &&
        _isItemBottom) {
      return;
    }
    if (_isItemBottom &&
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
}

class SearchPageCubit extends Cubit<int> {
  SearchPageCubit() : super(1);
  void changePage(page) => emit(page);
}

class EmptyResultWidget extends StatelessWidget {
  const EmptyResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Center(
          child: SvgPicture.asset(
            "assets/icons/no_content.svg",
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: Text(
            "${AppLocalizations.of(context)!.noResultText}...",
            style: GoogleFonts.poppins(
              color: AppColors.primaryColor,
              fontWeight: FontWeight.w600,
            ),
          ),
        ),
        Text(
          AppLocalizations.of(context)!.filtersChangeText,
          style: GoogleFonts.poppins(fontSize: 12),
        )
      ],
    );
  }
}
