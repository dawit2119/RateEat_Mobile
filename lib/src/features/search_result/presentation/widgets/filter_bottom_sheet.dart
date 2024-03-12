import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_event.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_event.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/grouped_price_chips.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/search_result.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';

class FilterBottomSheet extends StatefulWidget {
  const FilterBottomSheet({super.key});

  @override
  State<FilterBottomSheet> createState() => _FilterBottomSheetState();
}

class _FilterBottomSheetState extends State<FilterBottomSheet> {
  List<int> prices = [50, 100, 400, 600, 1000, 2000, 5000];
  late double ratingFilter;

  @override
  void initState() {
    super.initState();
    final itemState = context.read<ItemsFilterSearchResultsBloc>().state;
    final restaurantState =
        context.read<RestaurantsFilterSearchResultsBloc>().state;

    ratingFilter = restaurantState.rating != 0.0
        ? restaurantState.rating
        : itemState.rating;
  }

  bool isDisplayed = false;
  @override
  Widget build(context) {
    return SingleChildScrollView(
        physics: const NeverScrollableScrollPhysics(),
        child: DecoratedBox(
          decoration: const BoxDecoration(color: Colors.white),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: [
              verticalPadding(height: 1),
              Container(
                height: 0.4.h,
                width: 10.w,
                decoration: BoxDecoration(
                  color: AppColors.grey200,
                  borderRadius: BorderRadius.circular(10),
                ),
              ),
              Padding(
                padding: const EdgeInsets.only(top: 20),
                child: Text(
                  AppLocalizations.of(context)!.maxPriceText,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.bold,
                    fontSize: 16.sp,
                  ),
                ),
              ),
              GroupedPriceChips(
                prices: prices,
                currencyCode: "",
              ), //TODO we need to know this
              const Divider(color: AppColors.grey200),
              verticalPadding(height: 2),
              Text(
                AppLocalizations.of(context)!.ratingText,
                style: GoogleFonts.poppins(
                  fontWeight: FontWeight.bold,
                  fontSize: 16.sp,
                ),
              ),
              //* Rating List
              BlocBuilder<RestaurantsFilterSearchResultsBloc,
                  RestaurantsFilterSearchResultsState>(
                builder: (context, state) {
                  return Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RatingBar.builder(
                        initialRating: ratingFilter,
                        minRating: 0,
                        glowColor: AppColors.grey100,
                        glowRadius: 0.1,
                        itemSize: 4.h,
                        direction: Axis.horizontal,
                        allowHalfRating: true,
                        itemCount: 5,
                        unratedColor: AppColors.grey200,
                        updateOnDrag: true,
                        itemBuilder: (context, _) => const Icon(
                          Icons.star_rounded,
                          color: AppColors.primaryColor,
                        ),
                        onRatingUpdate: (rating) {
                          setState(() {
                            ratingFilter = rating;
                          });
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(left: 15),
                        child: (ratingFilter == 5)
                            ? Text(
                                "$ratingFilter ${AppLocalizations.of(context)!.starsText}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.w600,
                                  color: AppColors.grey500,
                                ),
                              )
                            : Text(
                                "$ratingFilter ${AppLocalizations.of(context)!.starsAndUpText}",
                                style: GoogleFonts.poppins(
                                  fontWeight: FontWeight.bold,
                                  color: AppColors.grey500,
                                ),
                              ),
                      ),
                    ],
                  );
                },
              ),
              //* Filter Button
              Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                width: double.infinity,
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: AppColors.primaryButtonColor,
                  ),
                  onPressed: () {
                    var locationState =
                        BlocProvider.of<UserLocationBloc>(context).state;
                    var activeTab = context.read<CategoriesToggleBloc>().state;

                    if (locationState is UserLocationLoaded) {
                      context.read<SearchPageCubit>().changePage(1);
                      // context.read<FilterSearchResultsBloc>().reset();
                      final restaurantsSearchState = context
                          .read<RestaurantsFilterSearchResultsBloc>()
                          .state;
                      final itemsSearchState =
                          context.read<ItemsFilterSearchResultsBloc>().state;
                      if (activeTab == 0) {
                        context.read<RestaurantsFilterSearchResultsBloc>().add(
                              GetFilteredRestaurantEvent(
                                category: restaurantsSearchState.category,
                                isFasting: restaurantsSearchState.isFasting,
                                searchQuery: restaurantsSearchState.searchQuery,
                                selection: restaurantsSearchState.selection,
                                location: locationState.location,
                                rating: ratingFilter,
                                maximumPrice: prices[
                                    context.read<MultiChipsCubit>().state],
                              ),
                            );
                      } else {
                        context.read<ItemsFilterSearchResultsBloc>().add(
                              GetFilteredItemsEvent(
                                isFasting: itemsSearchState.isFasting,
                                searchQuery: itemsSearchState.searchQuery,
                                selection: itemsSearchState.selection,
                                location: locationState.location,
                                rating: ratingFilter,
                                maximumPrice: prices[
                                    context.read<MultiChipsCubit>().state],
                              ),
                            );
                      }
                    }
                    Navigator.pop(context);
                  },
                  child: Text(
                    AppLocalizations.of(context)!.finishText,
                    style:
                        GoogleFonts.poppins(fontSize: 17, color: Colors.white),
                  ),
                ),
              ),

              verticalPadding(height: 2),
            ],
          ),
        ));
  }
}
