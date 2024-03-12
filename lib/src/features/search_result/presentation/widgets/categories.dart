import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_event.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/search_result.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../discover/discover.dart';

import '../../../live_search/presentation/pages/live_search_page.dart';
import '../bloc/restaurants_filter_search_result/restaurants_filter_results_event.dart';

class ItemCategories extends StatefulWidget {
  final TabController tabController;
  const ItemCategories({
    super.key,
    required this.tabController,
  });

  @override
  State<ItemCategories> createState() => _ItemCategoriesState();
}

class _ItemCategoriesState extends State<ItemCategories> {
  var activeTabIndex = 0;
  Timer? _debounce;

  @override
  void initState() {
    super.initState();
    widget.tabController.addListener(_onTabChanged);
  }

  void _onTabChanged() {
    if (_debounce?.isActive ?? false) _debounce!.cancel();
    _debounce = Timer(const Duration(milliseconds: 300), () {
      _setActiveTabIndex();
    });
  }

  void _setActiveTabIndex() {
    if (mounted) {
      setState(() {
        activeTabIndex = widget.tabController.index;
        // Trigger your Bloc event or state update here
      });
    }
  }

  @override
  void dispose() {
    widget.tabController.removeListener(_onTabChanged);
    _debounce?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    final locationState = BlocProvider.of<UserLocationBloc>(context).state;

    return Stack(children: [
      BlocBuilder<CategoriesToggleBloc, int>(builder: (context, state) {
        if (context.read<CategoriesToggleBloc>().state == 1) {
          return Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                AppLocalizations.of(context)!.fastingText,
                style: const TextStyle(fontSize: 16),
              ),
              BlocBuilder<FastingToggleBloc, bool>(
                builder: (context, state) {
                  return Padding(
                    padding: const EdgeInsets.only(right: 15),
                    child: Switch(
                        value: state,
                        activeColor: AppColors.primaryColor,
                        activeTrackColor: Colors.deepOrange[50],
                        inactiveThumbColor: Colors.white,
                        inactiveTrackColor: Colors.grey[300],
                        trackOutlineColor:
                            const WidgetStatePropertyAll(Colors.white),
                        onChanged: (bool value) {
                          context.read<SearchPageCubit>().changePage(1);
                          final selection = context
                              .read<ItemsFilterSearchResultsBloc>()
                              .state
                              .selection;
                          final searchQuery = context
                              .read<ItemsFilterSearchResultsBloc>()
                              .state
                              .searchQuery;
                          final rating = context
                              .read<ItemsFilterSearchResultsBloc>()
                              .state
                              .rating;
                          final maximumPrice = context
                              .read<ItemsFilterSearchResultsBloc>()
                              .state
                              .maximumPrice;

                          context.read<FastingToggleBloc>().toggleSwitch();

                          if (locationState is UserLocationLoaded) {
                            context.read<ItemsFilterSearchResultsBloc>().add(
                                  GetFilteredItemsEvent(
                                    isFasting: !state,
                                    searchQuery: searchQuery,
                                    selection: selection,
                                    location: locationState.location,
                                    rating: rating,
                                    maximumPrice: maximumPrice,
                                    latitude: locationState.location.latitude,
                                    longitude: locationState.location.longitude,
                                  ),
                                );
                          }
                        }),
                  );
                },
              )
            ],
          );
        } else {
          return const SizedBox();
        }
      }),
      Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            crossAxisAlignment: CrossAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(20, 10, 0, 0),
                child: Text(
                  AppLocalizations.of(context)!.categoriesText,
                  style: semiBold18,
                ),
              ),
            ],
          ),
          Padding(
            padding: EdgeInsets.only(left: 3.w, top: 1.9.h),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                BlocBuilder<CategoriesToggleBloc, int>(
                  builder: (context, categoryState) {
                    widget.tabController.index = categoryState;
                    return SizedBox(
                      width: screenWidth - 40,
                      child: Container(
                        decoration: BoxDecoration(
                          color: AppColors.grayLight,
                          borderRadius: BorderRadius.circular(
                            12.sp,
                          ),
                        ),
                        child: TabBar(
                          onTap: (index) {
                            context.read<LiveSearchCubit>().changeQuery("");
                            context
                                .read<CategoriesToggleBloc>()
                                .toggleSwitch(index);
                            final restaurantSelection = context
                                .read<RestaurantsFilterSearchResultsBloc>()
                                .state
                                .selection;
                            final itemSelection = context
                                .read<ItemsFilterSearchResultsBloc>()
                                .state
                                .selection;
                            final rating = context
                                .read<RestaurantsFilterSearchResultsBloc>()
                                .state
                                .rating;
                            final maximumPrice = context
                                .read<RestaurantsFilterSearchResultsBloc>()
                                .state
                                .maximumPrice;
                            final isFasting =
                                context.read<FastingToggleBloc>().state;

                            context.read<SearchPageCubit>().changePage(1);

                            if (locationState is UserLocationLoaded) {
                              if (index == 0) {
                                context
                                    .read<RestaurantsFilterSearchResultsBloc>()
                                    .add(
                                      GetFilteredRestaurantEvent(
                                        category: index,
                                        isFasting: isFasting,
                                        searchQuery: "",
                                        selection: restaurantSelection,
                                        location: locationState.location,
                                        rating: rating,
                                        maximumPrice: maximumPrice,
                                        latitude:
                                            locationState.location.latitude,
                                        longitude:
                                            locationState.location.longitude,
                                      ),
                                    );
                              } else {
                                context
                                    .read<ItemsFilterSearchResultsBloc>()
                                    .add(
                                      GetFilteredItemsEvent(
                                        isFasting: isFasting,
                                        searchQuery: "",
                                        selection: itemSelection,
                                        location: locationState.location,
                                        rating: rating,
                                        maximumPrice: maximumPrice,
                                        latitude:
                                            locationState.location.latitude,
                                        longitude:
                                            locationState.location.longitude,
                                      ),
                                    );
                              }
                            }
                          },
                          controller: widget.tabController,
                          labelColor: AppColors.textWhite,
                          unselectedLabelColor: AppColors.grey600,
                          indicatorPadding: EdgeInsets.symmetric(
                              vertical: 10.sp, horizontal: 12.sp),
                          dividerColor: Colors.transparent,
                          indicatorSize: TabBarIndicatorSize.tab,
                          indicator: BoxDecoration(
                            color: AppColors.primaryColor,
                            boxShadow: elevation_2,
                            borderRadius: BorderRadius.circular(10),
                          ),
                          physics: const BouncingScrollPhysics(
                              parent: FixedExtentScrollPhysics()),
                          tabs: [
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.sp),
                              child: Text(
                                AppLocalizations.of(context)!.restText,
                                style: medium16,
                              ),
                            ),
                            Padding(
                              padding: EdgeInsets.symmetric(vertical: 16.sp),
                              child: Text(
                                AppLocalizations.of(context)!.itemText,
                                style: medium16,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
        ],
      ),
    ]);
  }
}

class FastingToggleBloc extends Cubit<bool> {
  FastingToggleBloc() : super(false);
  toggleSwitch() => emit(!state);
}
