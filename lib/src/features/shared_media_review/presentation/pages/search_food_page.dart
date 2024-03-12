import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../bloc/search_food/search_food_bloc.dart';
import '../bloc/search_food/search_food_event.dart';
import '../bloc/search_food/search_food_state.dart';
import '../widgets/food_search_result_tile.dart';

class SearchFoodPage extends StatefulWidget {
  const SearchFoodPage({super.key, required this.restaurantId});

  final String restaurantId;

  @override
  State<SearchFoodPage> createState() => _SearchItemPageState();
}

class _SearchItemPageState extends State<SearchFoodPage> {
  TextEditingController searchFieldController = TextEditingController();

  @override
  void initState() {
    context.read<SearchFoodBloc>().add(
          GetHighestedRatedRestaurantItems(restaurantId: widget.restaurantId),
        );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        onTap: () => context.pop(),
        title: 'Search Food',
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
                  hintText: 'Search for a food',
                  controller: searchFieldController,
                  onChanged: (value) {
                    context.read<SearchFoodBloc>().add(
                          SearchFoodEvent(
                            restaurantId: widget.restaurantId,
                            query: value,
                          ),
                        );
                  },
                ),
                verticalPadding(height: 4),
                Expanded(
                  child: BlocBuilder<SearchFoodBloc, SearchFoodState>(
                      builder: (context, searchFoodState) {
                    if (searchFoodState is SearchFoodInitial) {
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
                            'Search a Food',
                            style: semiBold18,
                          ),
                          verticalPadding(height: 1),
                          Text(
                            'Search for a food to see matching results',
                            style: regular16,
                            textAlign: TextAlign.center,
                          ),
                          const Spacer(flex: 2),
                        ],
                      );
                    } else if (searchFoodState is SearchFoodLoading) {
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
                    } else if (searchFoodState is SearchFoodLoaded) {
                      if (searchFoodState.foods.isEmpty) {
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
                              searchFoodState.isSearchEvent
                                  ? 'We couldn’t find any foods matching your search.'
                                  : 'No food items available. Please check back later.',
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
                            searchFoodState.isSearchEvent
                                ? 'Search Results'
                                : 'Highest Rated Items',
                            style: medium18,
                          ),
                          verticalPadding(height: 1),
                          Expanded(
                            child: ListView.builder(
                              shrinkWrap: true,
                              physics: const AlwaysScrollableScrollPhysics(),
                              itemCount: searchFoodState.foods.length,
                              itemBuilder: (context, index) {
                                var food = searchFoodState.foods[index];
                                if (food.id != null && food.name != null) {
                                  return FoodSearchResultTile(
                                    foodId: searchFoodState.foods[index].id!,
                                    foodName:
                                        searchFoodState.foods[index].name!,
                                  );
                                }
                                return Container();
                              },
                            ),
                          ),
                        ],
                      );
                    } else if (searchFoodState is SearchFoodError) {
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
                            searchFoodState.message,
                            style: regular16,
                            textAlign: TextAlign.center,
                          ),
                          verticalPadding(height: 2),
                          CustomTextButton(
                            title: "Try Again",
                            ontap: () {
                              context.read<SearchFoodBloc>().add(
                                    SearchFoodEvent(
                                      restaurantId: widget.restaurantId,
                                      query: '',
                                    ),
                                  );
                            },
                          ),
                          const Spacer(flex: 2),
                        ],
                      );
                    }
                    return const SizedBox();
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
