import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/bloc/restaurant_bloc/discover_result_event.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/widgets/items_widget.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import '../bloc/restaurant_bloc/discover_result_bloc.dart';
import '../bloc/restaurant_bloc/discover_result_state.dart';
import 'restaurant_info_section.dart';

class SearchResult extends StatefulWidget {
  const SearchResult({
    super.key,
  });
  @override
  State<SearchResult> createState() => _SearchResultState();
}

class _SearchResultState extends State<SearchResult> {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<FetchDiscoverRestaurantResultBloc,
        FetchDiscoverRestaurantResultState>(
      listener: (context, discoverRestaurantState) {
        if (discoverRestaurantState is DiscoverRestaurantLoaded) {
          final discoverStepsBloc = dpLocator<DiscoveryStepsBloc>();
          final page = discoverStepsBloc.state.discoverRestaurantProps.page;
          if (!discoverRestaurantState.searchLoadingStatus) {
            discoverStepsBloc.add(
              DiscoveryFilterUpdate(
                page: page - 1,
              ),
            );
          }
        }
      },
      builder: (context, discoverRestaurantState) {
        if (discoverRestaurantState is DiscoverRestaurantError) {
          return SizedBox(
            height: 60.h,
            child: Center(
              child: ErrorAndInfoDisplayWidget(
                assetImage: "assets/icons/no_internet_1.svg",
                title: AppLocalizations.of(context)!.noResultText,
                description: AppLocalizations.of(context)!.tryAgainOnlyText,
                onPressed: () {
                  //* Update the page counter
                  context
                      .read<DiscoveryStepsBloc>()
                      .add(const DiscoveryFilterUpdate(page: 1));
                  //* Fetch new result
                  context.read<FetchDiscoverRestaurantResultBloc>().add(
                        FetchNewDiscoverRestaurantResultEvent(
                          discoveryStepsBloc:
                              context.read<DiscoveryStepsBloc>(),
                        ),
                      );
                },
              ),
            ),
          );
        } else if (discoverRestaurantState is DiscoverRestaurantLoading) {
          return SizedBox(
            height: 60.h,
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                LoadingAnimationWidget.dotsTriangle(
                  color: AppColors.primaryColor,
                  size: 60,
                ),
                verticalPadding(height: 1),
                Text(
                  AppLocalizations.of(context)!.loadingText,
                  style: searchHintTextStyle,
                ),
              ],
            ),
          );
        } else if (discoverRestaurantState is DiscoverRestaurantsNextLoading) {
          var result = discoverRestaurantState.discoveredRestaurantResults;
          return SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                verticalPadding(height: 2),
                ...List.generate(
                  result.length,
                  (restaurantIndex) => Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      boxShadow: elevation_4,
                    ),
                    // height: 43.h,
                    width: 100.w,
                    padding: const EdgeInsets.all(10),
                    margin: const EdgeInsets.only(bottom: 20),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.start,
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        RestaurantInfoSection(
                          restaurant: result[restaurantIndex],
                        ),
                        verticalPadding(height: 2),
                        RestaurantItemsScrollableList(
                          restaurantItems: result[restaurantIndex].items!,
                          restaurantId: result[restaurantIndex].id!,
                          currencyCode: result[restaurantIndex].currencyCode,
                        ),
                      ],
                    ),
                  ),
                ),
                SizedBox(
                  height: 10.h,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.dotsTriangle(
                        color: AppColors.primaryColor,
                        size: 36,
                      ),
                      verticalPadding(height: 1),
                      Text(
                        AppLocalizations.of(context)!.loadText,
                        style: textMediumStyle,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          );
        } else if (discoverRestaurantState is DiscoverRestaurantLoaded) {
          var result = discoverRestaurantState.discoveredRestaurantResults;
          if (result.isEmpty) {
            return SizedBox(
              height: 60.h,
              width: double.infinity,
              child: ErrorAndInfoDisplayWidget(
                title: AppLocalizations.of(context)!.noResultText,
                description: AppLocalizations.of(context)!.filterAgainText,
                assetImage: "assets/icons/no_content.svg",
                onPressed: null,
              ),
            );
          } else {
            return SingleChildScrollView(
              child: Column(
                children: [
                  verticalPadding(height: 2),
                  ...List.generate(
                    result.length,
                    (restaurantIndex) => Container(
                      key: Key(
                          "restaurant_discover_card_${result[restaurantIndex].id!}"), // Key for testing
                      width: 100.w,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: elevation_4,
                      ),
                      padding: const EdgeInsets.all(10),
                      margin: const EdgeInsets.only(bottom: 20),
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RestaurantInfoSection(
                            restaurant: result[restaurantIndex],
                          ),
                          verticalPadding(height: 2),
                          RestaurantItemsScrollableList(
                            restaurantItems: result[restaurantIndex].items!,
                            restaurantId: result[restaurantIndex].id!,
                            currencyCode: result[restaurantIndex].currencyCode,
                          ),
                        ],
                      ),
                    ),
                  ),
                  if (discoverRestaurantState.hasReachedMax)
                    Padding(
                      padding: const EdgeInsets.all(16.0),
                      child: Center(
                        child: Text(
                          AppLocalizations.of(context)!.changeFiltersText,
                          style: GoogleFonts.poppins(
                            color: Colors.grey,
                            fontSize: 1.5.h,
                          ),
                        ),
                      ),
                    ),
                ],
              ),
            );
          }
        } else {
          return ErrorAndInfoDisplayWidget(
            assetImage: "assets/icons/no_content.svg",
            title: AppLocalizations.of(context)!.unknownErrorText,
            description: AppLocalizations.of(context)!.tryAgainText,
            onPressed: () {
              //* Update the page counter
              context
                  .read<DiscoveryStepsBloc>()
                  .add(const DiscoveryFilterUpdate(page: 1));
              //* Fetch new result
              context.read<FetchDiscoverRestaurantResultBloc>().add(
                    FetchNewDiscoverRestaurantResultEvent(
                      discoveryStepsBloc: context.read<DiscoveryStepsBloc>(),
                    ),
                  );
            },
          );
        }
      },
    );
  }
}
