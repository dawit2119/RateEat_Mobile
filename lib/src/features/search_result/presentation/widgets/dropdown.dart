import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_event.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_event.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/categories.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/search_result.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/constants/constants.dart';
import '../../../live_search/presentation/pages/live_search_page.dart';
import '../bloc/items_filter_search_result/items_filter_results_state.dart';

class DropdownFilter extends StatefulWidget {
  const DropdownFilter({super.key});
  @override
  State<DropdownFilter> createState() => _DropdownFilterState();
}

List<String> list = <String>[
  'Most Popular',
  'Distance',
  'Highest Rated',
  'Price(From Lowest)'
];

class _DropdownFilterState extends State<DropdownFilter> {
  @override
  Widget build(BuildContext context) {
    Map<String, String> localizedMap = {
      "Most Popular": AppLocalizations.of(context)!.mostPopularText,
      "Distance": AppLocalizations.of(context)!.distText,
      "Highest Rated": AppLocalizations.of(context)!.ratedText,
      "Price(From Lowest)": AppLocalizations.of(context)!.priceText
    };
    // var restaurantsFilterState =
    //     context.read<RestaurantsFilterSearchResultsBloc>().state;
    // var itemsFilterState = context.read<ItemsFilterSearchResultsBloc>().state;

    return BlocBuilder<CategoriesToggleBloc, int>(
        builder: (context, activeTab) {
      return BlocBuilder<RestaurantsFilterSearchResultsBloc,
          RestaurantsFilterSearchResultsState>(
        builder: (context, restaurantsSearchState) {
          return BlocBuilder<ItemsFilterSearchResultsBloc,
              ItemsFilterSearchResultsState>(
            builder: (context, itemsSearchState) {
              return Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: DropdownButton<String>(
                    value: activeTab == 0
                        ? mapRestaurantFilterStateToString(
                            restaurantsSearchState.selection)
                        : mapItemFilterStateToString(
                            itemsSearchState.selection,
                          ),
                    style: const TextStyle(color: Colors.black),
                    underline: Container(height: 0),
                    iconSize: 18.sp,
                    isExpanded: false,
                    isDense: true,
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    icon: const Icon(
                      Icons.sort,
                    ),
                    borderRadius: BorderRadius.circular(6),
                    elevation: 4,
                    dropdownColor: Colors.white,
                    focusColor: AppColors.grey200,
                    onChanged: (String? value) {
                      //* Get Selected Value
                      if (activeTab == 0) {
                        RestaurantsFilterState selection =
                            mapStringToRestaurantsFilterState(value!);

                        final isFasting =
                            context.read<FastingToggleBloc>().state;
                        var locationState =
                            context.read<UserLocationBloc>().state;
                        context.read<SearchPageCubit>().changePage(1);
                        if (locationState is UserLocationLoaded) {
                          context
                              .read<RestaurantsFilterSearchResultsBloc>()
                              .add(
                                GetFilteredRestaurantEvent(
                                  location: locationState.location,
                                  isFasting: isFasting,
                                  selection: selection,
                                  searchQuery:
                                      restaurantsSearchState.searchQuery,
                                  category: context
                                      .read<CategoriesToggleBloc>()
                                      .state,
                                  rating: restaurantsSearchState.rating,
                                  maximumPrice:
                                      restaurantsSearchState.maximumPrice,
                                ),
                              );
                        }
                      } else {
                        ItemsFilterState selection =
                            mapStringToItemsFilterState(value!);
                        final query = context.read<LiveSearchCubit>().state;
                        final isFasting =
                            context.read<FastingToggleBloc>().state;
                        var locationState =
                            context.read<UserLocationBloc>().state;
                        context.read<SearchPageCubit>().changePage(1);
                        context
                            .read<ItemsFilterSearchResultsBloc>()
                            .add(ResetItemsFilterSearchResultsEvent());
                        if (locationState is UserLocationLoaded) {
                          context.read<ItemsFilterSearchResultsBloc>().add(
                                GetFilteredItemsEvent(
                                  location: locationState.location,
                                  isFasting: isFasting,
                                  selection: selection,
                                  searchQuery: query,
                                  rating: itemsSearchState.rating,
                                  maximumPrice: itemsSearchState.maximumPrice,
                                ),
                              );
                        }
                      }
                    },
                    items: list.map<DropdownMenuItem<String>>((String value) {
                      return DropdownMenuItem<String>(
                        value: value,
                        child: Text(
                          localizedMap[value].toString(),
                          style: medium16,
                        ),
                      );
                    }).toList(),
                  ));
            },
          );
        },
      );
    });
  }

  String mapItemFilterStateToString(ItemsFilterState filterState) {
    switch (filterState) {
      case ItemsFilterState.mostPopular:
        return 'Most Popular';
      case ItemsFilterState.highestRated:
        return 'Highest Rated';
      case ItemsFilterState.closest:
        return 'Distance';
      case ItemsFilterState.priceSorted:
        return 'Price(From Lowest)';
      default:
        return 'Most Popular';
    }
  }

  String mapRestaurantFilterStateToString(RestaurantsFilterState filterState) {
    switch (filterState) {
      case RestaurantsFilterState.mostPopular:
        return 'Most Popular';
      case RestaurantsFilterState.highestRated:
        return 'Highest Rated';
      case RestaurantsFilterState.closest:
        return 'Distance';
      case RestaurantsFilterState.priceSorted:
        return 'Price(From Lowest)';
      default:
        return 'Most Popular';
    }
  }

  RestaurantsFilterState mapStringToRestaurantsFilterState(String value) {
    switch (value) {
      case 'Most Popular':
        return RestaurantsFilterState.mostPopular;
      case 'Highest Rated':
        return RestaurantsFilterState.highestRated;
      case 'Distance':
        return RestaurantsFilterState.closest;
      case 'Price(From Lowest)':
        return RestaurantsFilterState.priceSorted;
      default:
        return RestaurantsFilterState
            .mostPopular; // You can choose a default value or throw an error here.
    }
  }

  ItemsFilterState mapStringToItemsFilterState(String value) {
    switch (value) {
      case 'Most Popular':
        return ItemsFilterState.mostPopular;
      case 'Highest Rated':
        return ItemsFilterState.highestRated;
      case 'Distance':
        return ItemsFilterState.closest;
      case 'Price(From Lowest)':
        return ItemsFilterState.priceSorted;
      default:
        return ItemsFilterState
            .mostPopular; // You can choose a default value or throw an error here.
    }
  }
}
