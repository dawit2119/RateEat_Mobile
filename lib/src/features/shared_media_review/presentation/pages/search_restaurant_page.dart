import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/shared_media_review/presentation/bloc/search_restaurant/search_restaurant_event.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../bloc/search_restaurant/search_restaurant_bloc.dart';
import '../bloc/search_restaurant/search_restaurant_state.dart';
import '../widgets/restaurant_search_result_tile.dart';

class SearchRestaurantPageGlobal extends StatefulWidget {
  const SearchRestaurantPageGlobal({
    super.key,
    required this.isRestaurantReview,
  });

  final bool isRestaurantReview;

  @override
  State<SearchRestaurantPageGlobal> createState() =>
      _SearchRestaurantPageState();
}

class _SearchRestaurantPageState extends State<SearchRestaurantPageGlobal> {
  TextEditingController searchFieldController = TextEditingController();

  @override
  void initState() {
    context.read<UserLocationBloc>().add(const GetUserLocation());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        onTap: () => context.pop(),
        title: 'Search Restaurant',
      ),
      body: SafeArea(
        child: SizedBox(
          height: 100.h,
          width: 100.w,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Column(
              children: [
                verticalPadding(height: 3),
                CustomTextInputField(
                  autoFocus: true,
                  canRequestFocus: true,
                  hintText: 'Search for a restaurant',
                  controller: searchFieldController,
                  onChanged: (value) {
                    context.read<SearchRestaurantBloc>().add(
                          SearchRestaurantEvent(query: value),
                        );
                  },
                ),
                verticalPadding(height: 4),
                Expanded(
                  child: BlocConsumer<UserLocationBloc, UserLocationState>(
                      listener: (context, userLocationState) {
                    if (userLocationState is UserLocationLoaded) {
                      context.read<SearchRestaurantBloc>().add(
                            GetNearbyRestaurantEvent(
                              latitude: userLocationState.location.latitude,
                              longitude: userLocationState.location.longitude,
                            ),
                          );
                    }
                  }, builder: (context, userLocationState) {
                    return BlocBuilder<SearchRestaurantBloc,
                            SearchRestaurantState>(
                        builder: (context, searchRestaurantState) {
                      if (searchRestaurantState is SearchRestaurantInitial) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Image.asset(
                              height: 200,
                              width: 200,
                              'assets/images/Page_not_found.png',
                              fit: BoxFit.cover,
                            ),
                            verticalPadding(height: 3),
                            Text(
                              'Search a Restaurant',
                              style: semiBold18,
                            ),
                            verticalPadding(height: 1),
                            Text(
                              'Search for a restaurant to see matching results',
                              style: regular16,
                              textAlign: TextAlign.center,
                            ),
                            const Spacer(flex: 2),
                          ],
                        );
                      } else if (searchRestaurantState
                          is SearchRestaurantLoading) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            LoadingAnimationWidget.discreteCircle(
                              color: AppColors.primaryColor,
                              secondRingColor: AppColors.grey100,
                              size: 40,
                            ),
                            verticalPadding(height: 2),
                            Text(
                              "Loading results",
                              style: regular16,
                              textAlign: TextAlign.center,
                            ),
                            verticalPadding(height: 2),
                            const Spacer(flex: 2),
                          ],
                        );
                      } else if (searchRestaurantState
                          is SearchRestaurantLoaded) {
                        if (searchRestaurantState.restaurants.isEmpty) {
                          return Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Spacer(),
                              Image.asset(
                                height: 200,
                                width: 200,
                                'assets/images/Page_not_found.png',
                                fit: BoxFit.cover,
                              ),
                              verticalPadding(height: 3),
                              Text(
                                'No Results Found',
                                style: semiBold18,
                              ),
                              verticalPadding(height: 1),
                              Text(
                                searchRestaurantState.isSearchEvent
                                    ? 'We couldn’t find any restaurants matching your search.'
                                    : 'No nearby restaurants found. Try searching for a restaurant.',
                                style: regular16,
                                textAlign: TextAlign.center,
                              ),
                              const Spacer(flex: 2),
                            ],
                          );
                        }
                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              searchRestaurantState.isSearchEvent
                                  ? 'Search Results'
                                  : 'Nearby Restaurantss',
                              style: medium18,
                            ),
                            verticalPadding(height: 1),
                            Expanded(
                              child: ListView.builder(
                                shrinkWrap: true,
                                physics: const AlwaysScrollableScrollPhysics(),
                                itemCount:
                                    searchRestaurantState.restaurants.length,
                                itemBuilder: (context, index) {
                                  var restaurant =
                                      searchRestaurantState.restaurants[index];
                                  if (restaurant.id != null &&
                                      restaurant.name != null) {
                                    return RestaurantSearchResultTile(
                                      isRestaurantReview:
                                          widget.isRestaurantReview,
                                      restaurantId: searchRestaurantState
                                          .restaurants[index].id!,
                                      restaurantName: searchRestaurantState
                                          .restaurants[index].name!,
                                    );
                                  }
                                  return Container();
                                },
                              ),
                            ),
                          ],
                        );
                      } else if (searchRestaurantState
                          is SearchRestaurantError) {
                        return Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            const Spacer(),
                            Image.asset(
                              height: 200,
                              width: 200,
                              'assets/images/Error_page_2.png',
                              fit: BoxFit.cover,
                            ),
                            verticalPadding(height: 3),
                            Text(
                              'An error has accured',
                              style: semiBold18,
                            ),
                            verticalPadding(height: 1),
                            Text(
                              searchRestaurantState.message,
                              style: regular16,
                              textAlign: TextAlign.center,
                            ),
                            verticalPadding(height: 2),
                            CustomTextButton(
                              title: "Try Again",
                              ontap: () {
                                context.read<SearchRestaurantBloc>().add(
                                      const SearchRestaurantEvent(query: ''),
                                    );
                              },
                            ),
                            const Spacer(flex: 2),
                          ],
                        );
                      }
                      return const SizedBox();
                    });
                  }),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
