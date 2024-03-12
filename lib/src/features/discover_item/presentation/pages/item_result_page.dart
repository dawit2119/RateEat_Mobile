import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/category/category_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/filter/filter_items_bloc.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/filter/filter_items_event.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/filter/filter_items_state.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/pages/filter_modal_sheet.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/selected_restaurant.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/bloc/search/selected_restaurant_state.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/widgets/divcover_menu_item_tile.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/widgets/item_result_header.dart';

import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/item_result.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/shimmer/item_search_results_shimmer.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../item_category/presentation/widgets/tag_shimmer.dart';
import '../../data/models/catagory_model.dart';
import '../bloc/category/category_event.dart';
import '../bloc/category/category_state.dart';

class ItemResultPage extends StatefulWidget {
  const ItemResultPage({
    super.key,
  });

  @override
  ItemResultPageState createState() => ItemResultPageState();
}

List<String> list = <String>[
  'Most Popular',
  'Highest Rated',
  'Price(From Lowest)'
];
Map<String, String> map = {
  "Most Popular": "popularity",
  "Highest Rated": "rating",
  "Price(From Lowest)": "price"
};

class ItemResultPageState extends State<ItemResultPage> {
  bool isFasting = false;
  String dropdownValue = list[1];
  final int limit = 7;
  final _itemScrollController = ScrollController();
  bool isSearch = false;

  TextEditingController searchItemController = TextEditingController();
  @override
  void initState() {
    super.initState();
    _itemScrollController.addListener(_onItemScroll);
    context.read<CategoryBloc>().add(
          GetCategoriesEvent(
            restaurantId: (context.read<SelectedRestaurantBloc>().state
                    as RestaurantSelectedSuccess)
                .selectedRestaurant
                .id,
          ),
        );

    context.read<FilterItemsBloc>().add(
          GetFilteredItemsEvent(
            restaurantId: (context.read<SelectedRestaurantBloc>().state
                    as RestaurantSelectedSuccess)
                .selectedRestaurant
                .id,
            maxPrice: context.read<DiscoverMenuPriceSelectorCubit>().state,
            fasting: isFasting,
            sortingQuery: map[dropdownValue].toString(),
            searchQuery: '',
            categoryId: context
                .read<DiscoverMenuSelectedCategoryCubit>()
                .state['categoryId'],
          ),
        );
    context.read<DiscoveryItemPageCubit>().changePage(1);
  }

  @override
  void dispose() {
    searchItemController.dispose();
    _itemScrollController
      ..removeListener(_onItemScroll)
      ..dispose();
    super.dispose();
  }

  final items = List.generate(7, (index) => const TagShimmer());
  @override
  Widget build(BuildContext context) {
    Map<String, String> localized = {
      "Most Popular": AppLocalizations.of(context)!.mostPopularText,
      "Highest Rated": AppLocalizations.of(context)!.ratedText,
      "Price(From Lowest)": AppLocalizations.of(context)!.priceText
    };
    double screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size(100.w, screenHeight * 0.15),
        child: Padding(
          padding: EdgeInsets.only(left: 4.sw, top: 2.sh, right: 4.sw),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              ItemResultHeader(
                path: "assets/icons/arrow_left.svg",
                onTap: () {
                  Navigator.pop(context);
                },
              ),
              SizedBox(
                width: 5.w,
              ),
              Expanded(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                      (context.read<SelectedRestaurantBloc>().state
                              as RestaurantSelectedSuccess)
                          .selectedRestaurant
                          .name,
                      style: medium18.copyWith(
                        color: Colors.black,
                      )),
                ),
              ),
              SizedBox(
                width: 3.w,
              ),
              ItemResultHeader(
                path: "assets/icons/filter.svg",
                onTap: () {
                  showFilterModalSheet(
                      navigator: Navigator.of(context),
                      context: context,
                      restaurantId: (context
                              .read<SelectedRestaurantBloc>()
                              .state as RestaurantSelectedSuccess)
                          .selectedRestaurant
                          .id,
                      isFasting: isFasting,
                      dropdownValue: dropdownValue,
                      searchQuery: searchItemController.text,
                      sortingValue: dropdownValue,
                      currencyCode: "");
                },
              )
            ],
          ),
        ),
      ),
      body: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(height: 2.sh),
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 4.sw,
            ),
            child: CustomTextInputField(
              showTrailing: true,
              autoFocus: true,
              hintText: AppLocalizations.of(context)!.searchItemText,
              canRequestFocus: true,
              controller: searchItemController,
              onCancelled: () {
                searchItemController.clear();

                context.read<FilterItemsBloc>().add(
                      GetFilteredItemsEvent(
                        restaurantId: (context
                                .read<SelectedRestaurantBloc>()
                                .state as RestaurantSelectedSuccess)
                            .selectedRestaurant
                            .id,
                        maxPrice: context
                            .read<DiscoverMenuPriceSelectorCubit>()
                            .state,
                        fasting: isFasting,
                        sortingQuery: map[dropdownValue].toString(),
                        searchQuery: '',
                      ),
                    );
              },
              onChanged: (query) {
                context.read<FilterItemsBloc>().add(
                      GetFilteredItemsEvent(
                        restaurantId: (context
                                .read<SelectedRestaurantBloc>()
                                .state as RestaurantSelectedSuccess)
                            .selectedRestaurant
                            .id,
                        maxPrice: context
                            .read<DiscoverMenuPriceSelectorCubit>()
                            .state,
                        fasting: isFasting,
                        sortingQuery: map[dropdownValue].toString(),
                        searchQuery: searchItemController.text,
                      ),
                    );
              },
            ),
          ),
          SizedBox(height: 2.sh),
          BlocBuilder<CategoryBloc, CategoryState>(
            builder: (context, state) {
              if (state is CategoryLoading) {
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
              } else if (state is CategoryLoaded) {
                final categories = [
                  Category(
                    totalItems: 0,
                    item: [],
                    updatedAt: '',
                    createdAt: '',
                    menuId: '',
                    isApproved: false,
                    id: '',
                    name: 'All',
                  ), // The "All" category
                  ...state.categories, // Your actual categories
                ];

                return SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Padding(
                    padding: EdgeInsets.only(left: 4.sw),
                    child: Row(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: List.generate(
                          categories.length,
                          (index) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 4),
                            child: DivcoverMenuItemTile(
                              categoryName: categories[index].name,
                              categoryIconUrl: null,
                              totalItems: categories[index].totalItems,
                              onTap: () {
                                final selectedCategoryId = categories[index].id;
                                final isSelected = context
                                    .read<DiscoverMenuSelectedCategoryCubit>()
                                    .state['isSelected'];
                                final prevSelectedCategoryId = context
                                    .read<DiscoverMenuSelectedCategoryCubit>()
                                    .state['categoryId'];

                                // If the selected category is already selected and it's not "All", deselect it
                                if (prevSelectedCategoryId ==
                                        selectedCategoryId &&
                                    isSelected &&
                                    selectedCategoryId != '') {
                                  context
                                      .read<DiscoverMenuSelectedCategoryCubit>()
                                      .changeSelectedCategory(
                                        categoryId: '',
                                        isSelected: true, // Reset to "All"
                                      );
                                  context.read<FilterItemsBloc>().add(
                                        GetFilteredItemsEvent(
                                          restaurantId: (context
                                                      .read<
                                                          SelectedRestaurantBloc>()
                                                      .state
                                                  as RestaurantSelectedSuccess)
                                              .selectedRestaurant
                                              .id,
                                          maxPrice: context
                                              .read<
                                                  DiscoverMenuPriceSelectorCubit>()
                                              .state,

                                          fasting: context
                                              .read<
                                                  DiscoverMenuFastingSelectorCubit>()
                                              .state,
                                          sortingQuery:
                                              map[dropdownValue].toString(),
                                          searchQuery:
                                              searchItemController.text,
                                          categoryId: '', // Fetch all items
                                        ),
                                      );
                                }
                                // If "All" is clicked, select "All" and fetch all items
                                else if (selectedCategoryId == '') {
                                  context
                                      .read<DiscoverMenuSelectedCategoryCubit>()
                                      .changeSelectedCategory(
                                        categoryId: '',
                                        isSelected: true,
                                      );
                                  context.read<FilterItemsBloc>().add(
                                        GetFilteredItemsEvent(
                                          restaurantId: (context
                                                      .read<
                                                          SelectedRestaurantBloc>()
                                                      .state
                                                  as RestaurantSelectedSuccess)
                                              .selectedRestaurant
                                              .id,
                                          maxPrice: context
                                              .read<
                                                  DiscoverMenuPriceSelectorCubit>()
                                              .state,

                                          fasting: context
                                              .read<
                                                  DiscoverMenuFastingSelectorCubit>()
                                              .state,
                                          sortingQuery:
                                              map[dropdownValue].toString(),
                                          searchQuery:
                                              searchItemController.text,
                                          categoryId: '', // Fetch all items
                                        ),
                                      );
                                }
                                // If a different category is selected
                                else {
                                  context
                                      .read<DiscoverMenuSelectedCategoryCubit>()
                                      .changeSelectedCategory(
                                        categoryId: selectedCategoryId,
                                        isSelected: true,
                                      );
                                  context.read<FilterItemsBloc>().add(
                                        GetFilteredItemsEvent(
                                          restaurantId: (context
                                                      .read<
                                                          SelectedRestaurantBloc>()
                                                      .state
                                                  as RestaurantSelectedSuccess)
                                              .selectedRestaurant
                                              .id,
                                          maxPrice: context
                                              .read<
                                                  DiscoverMenuPriceSelectorCubit>()
                                              .state,

                                          fasting: context
                                              .read<
                                                  DiscoverMenuFastingSelectorCubit>()
                                              .state,
                                          sortingQuery:
                                              map[dropdownValue].toString(),
                                          searchQuery:
                                              searchItemController.text,
                                          categoryId:
                                              selectedCategoryId, // Fetch items for the selected category
                                        ),
                                      );
                                }
                              },
                            ),
                          ),
                        )),
                  ),
                );
              } else if (state is CategoryError) {
                return ErrorAndInfoDisplayWidget(
                  assetImage: "assets/icons/no_content.svg",
                  title: AppLocalizations.of(context)!.unknownErrorText,
                  description: AppLocalizations.of(context)!.tryAgainText,
                  onPressed: () {
                    context.read<CategoryBloc>().add(
                          GetCategoriesEvent(
                            restaurantId: (context
                                    .read<SelectedRestaurantBloc>()
                                    .state as RestaurantSelectedSuccess)
                                .selectedRestaurant
                                .id,
                          ),
                        );
                  },
                );
              } else {
                return ErrorAndInfoDisplayWidget(
                  assetImage: "assets/icons/no_internet.svg",
                  title: AppLocalizations.of(context)!.networkText,
                  description: AppLocalizations.of(context)!.connText,
                  onPressed: () {
                    context.read<CategoryBloc>().add(
                          GetCategoriesEvent(
                            restaurantId: (context
                                    .read<SelectedRestaurantBloc>()
                                    .state as RestaurantSelectedSuccess)
                                .selectedRestaurant
                                .id,
                          ),
                        );
                  },
                );
              }
            },
          ),
          Padding(
            padding: const EdgeInsets.only(left: 18, right: 18),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Spacer(),
                Row(
                  crossAxisAlignment: CrossAxisAlignment.center,
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    DropdownButton<String>(
                      value: dropdownValue,
                      iconSize: 0.0,
                      borderRadius: BorderRadius.circular(6),
                      elevation: 10,
                      style: const TextStyle(color: Colors.black),
                      focusColor: Colors.white,
                      alignment: Alignment.centerRight,
                      underline: Container(height: 0),
                      onChanged: (String? value) {
                        context.read<DiscoveryItemPageCubit>().changePage(1);
                        context
                            .read<FilterItemsBloc>()
                            .add(ResetFilterItemsEvent());

                        setState(() {
                          dropdownValue = value!;

                          context.read<FilterItemsBloc>().add(
                                GetFilteredItemsEvent(
                                  restaurantId: (context
                                          .read<SelectedRestaurantBloc>()
                                          .state as RestaurantSelectedSuccess)
                                      .selectedRestaurant
                                      .id,
                                  maxPrice: context
                                      .read<DiscoverMenuPriceSelectorCubit>()
                                      .state,
                                  fasting: context
                                      .read<DiscoverMenuFastingSelectorCubit>()
                                      .state,
                                  sortingQuery: map[dropdownValue].toString(),
                                  searchQuery: searchItemController.text,
                                ),
                              );
                        });
                      },
                      items: list.map<DropdownMenuItem<String>>((String value) {
                        return DropdownMenuItem<String>(
                          value: value,
                          alignment: Alignment.centerLeft,
                          child: Row(
                            children: [
                              Padding(
                                padding: EdgeInsets.fromLTRB(0, 0, 7, 0),
                                child: Icon(
                                  Icons.sort,
                                  size: 2.4.h,
                                ),
                              ),
                              Text(
                                localized[value].toString(),
                                style: GoogleFonts.getFont('Poppins',
                                    color: const Color(0xff3e3e3e),
                                    fontSize: 16.sp),
                              ),
                            ],
                          ),
                        );
                      }).toList(),
                    ),
                    Icon(
                      Icons.keyboard_arrow_down_outlined,
                      color: Color(0xff3e3e3e),
                      size: 2.0.h,
                    ),
                  ],
                ),
                horizontalPadding(width: 2),
              ],
            ),
          ),
          BlocBuilder<FilterItemsBloc, FilterItemsState>(
            builder: (context, state) {
              if (state is FilterItemsLoading) {
                return const Expanded(child: ItemSearchResultsShimmer());
              } else if (state is FilterItemsLoadingMore) {
                final items = state.items;
                return Expanded(
                  child: SingleChildScrollView(
                    controller: _itemScrollController,
                    child: Column(
                      children: [
                        GridView.builder(
                          physics: const NeverScrollableScrollPhysics(),
                          shrinkWrap: true,
                          gridDelegate:
                              SliverGridDelegateWithFixedCrossAxisCount(
                            crossAxisCount: 2,
                            mainAxisSpacing: 1.sh,
                            crossAxisSpacing: 1.sw,
                            childAspectRatio: 0.75,
                          ),
                          itemCount: items.length,
                          itemBuilder: (context, index) {
                            var item = items[index];
                            return ItemResult(
                              id: item.itemId,
                              imageUrl: item.imageUrl!,
                              rating: item.averageRating!,
                              foodName: item.itemName,
                              restaurantName: (context
                                      .read<SelectedRestaurantBloc>()
                                      .state as RestaurantSelectedSuccess)
                                  .selectedRestaurant
                                  .name,
                              price: item.price!,
                              noOfReviews: item.numberOfReviews,
                              ridingTime: item.ridingTime,
                              walkingTime: item.walkingTime,
                              distance: item.distance,
                              currency: item.currencyCode,
                            );
                          },
                        ),
                        Column(
                          children: [
                            SizedBox(height: screenHeight * 0.01),
                            const ItemSearchResultsShimmer(
                              shimmerCount: 1,
                            ),
                            SizedBox(height: screenHeight * 0.01),
                          ],
                        )
                      ],
                    ),
                  ),
                );
              } else if (state is FilterItemsLoaded) {
                final results = state.items;

                if (state.isLoadingMore == false) {
                  var prevPage = context.read<DiscoveryItemPageCubit>().state;
                  context
                      .read<DiscoveryItemPageCubit>()
                      .changePage(prevPage - 1);
                }
                if (results.isEmpty) {
                  return Expanded(
                      child: ErrorAndInfoDisplayWidget(
                    assetImage: 'assets/icons/no_content.svg',
                    title: AppLocalizations.of(context)!.noResultText,
                    description: AppLocalizations.of(context)!.searchNoText,
                    onPressed: null,
                  ));
                } else {
                  return Expanded(
                    child: SingleChildScrollView(
                      controller: _itemScrollController,
                      child: Column(
                        children: [
                          GridView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            gridDelegate:
                                SliverGridDelegateWithFixedCrossAxisCount(
                              crossAxisSpacing: 8.0,
                              mainAxisSpacing: 8.0,
                              crossAxisCount: 2,
                              childAspectRatio: 0.78,
                            ),
                            itemCount: results.length,
                            itemBuilder: (context, index) {
                              var item = results[index];
                              return ItemResult(
                                id: item.itemId,
                                imageUrl: item.imageUrl!,
                                rating: item.averageRating!,
                                foodName: item.itemName,
                                restaurantName: (context
                                        .read<SelectedRestaurantBloc>()
                                        .state as RestaurantSelectedSuccess)
                                    .selectedRestaurant
                                    .name,
                                price: item.price!,
                                noOfReviews: item.numberOfReviews,
                                ridingTime: item.ridingTime,
                                walkingTime: item.walkingTime,
                                distance: item.distance,
                                currency: item.currencyCode,
                              );
                            },
                          ),
                          if (state.hasReachedMax)
                            Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: Center(
                                child: Text(
                                  "That's all , try changing the filters :( ",
                                  style: GoogleFonts.poppins(
                                    color: Colors.grey,
                                    fontSize: 1.5.h,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  );
                }
              } else if (state is FilterItemsError) {
                return Expanded(
                  child: Column(
                    children: [
                      ErrorAndInfoDisplayWidget(
                        assetImage: "assets/icons/no_content.svg",
                        title: AppLocalizations.of(context)!.unknownErrorText,
                        description: AppLocalizations.of(context)!.tryAgainText,
                        onPressed: () {
                          context.read<DiscoveryItemPageCubit>().changePage(1);
                          context
                              .read<FilterItemsBloc>()
                              .add(ResetFilterItemsEvent());

                          context.read<FilterItemsBloc>().add(
                                GetFilteredItemsEvent(
                                  restaurantId: (context
                                          .read<SelectedRestaurantBloc>()
                                          .state as RestaurantSelectedSuccess)
                                      .selectedRestaurant
                                      .id,
                                  maxPrice: r'$$$$',
                                  fasting: false,
                                  sortingQuery: map[dropdownValue].toString(),
                                  searchQuery: searchItemController.text,
                                ),
                              );
                        },
                      ),
                      const Spacer(flex: 2),
                    ],
                  ),
                );
              } else {
                return ErrorAndInfoDisplayWidget(
                  assetImage: "assets/icons/no_internet.svg",
                  title: AppLocalizations.of(context)!.networkText,
                  description: AppLocalizations.of(context)!.connText,
                  onPressed: () {
                    context.read<DiscoveryItemPageCubit>().changePage(1);
                    context
                        .read<FilterItemsBloc>()
                        .add(ResetFilterItemsEvent());

                    context.read<FilterItemsBloc>().add(
                          GetFilteredItemsEvent(
                            restaurantId: (context
                                    .read<SelectedRestaurantBloc>()
                                    .state as RestaurantSelectedSuccess)
                                .selectedRestaurant
                                .id,
                            maxPrice: r'$$$$',
                            fasting: false,
                            sortingQuery: map[dropdownValue].toString(),
                            searchQuery: searchItemController.text,
                          ),
                        );
                  },
                );
              }
            },
          ),
        ],
      ),
    );
  }

  mapItems(items) {
    if (items != null) {
      return GridView.count(
        physics:
            const NeverScrollableScrollPhysics(), // Prevents nested scrolling
        shrinkWrap: true, // Ensures GridView takes only required height
        crossAxisCount: 2, // Two items per row
        mainAxisSpacing: 5, // Spacing between rows
        crossAxisSpacing: 5, // Spacing between columns
        childAspectRatio: 0.75, // Adjusts height/width ratio for cards
        children: items
            .map<Widget>(
              (item) => ItemResult(
                id: item.itemId,
                imageUrl: item.imageUrl!,
                rating: item.averageRating!,
                foodName: item.itemName,
                restaurantName: (context.read<SelectedRestaurantBloc>().state
                        as RestaurantSelectedSuccess)
                    .selectedRestaurant
                    .name,
                price: item.price!,
                noOfReviews: item.numberOfReviews,
                ridingTime: item.ridingTime,
                walkingTime: item.walkingTime,
                distance: item.distance,
                currency: item.currencyCode,
              ),
            )
            .toList(),
      );
    }
    return [];
  }

  void _onItemScroll() {
    final state = context.read<FilterItemsBloc>().state;
    if ((state is FilterItemsLoaded) && state.hasReachedMax && _isItemBottom) {
      return;
    }
    if (_isItemBottom && (state is FilterItemsLoaded) && !state.hasReachedMax) {
      var prevPage = context.read<DiscoveryItemPageCubit>().state;

      context.read<DiscoveryItemPageCubit>().changePage(prevPage + 1);
      context.read<FilterItemsBloc>().add(
            GetFilteredItemsEvent(
              page: prevPage + 1,
              limit: limit,
              restaurantId: (context.read<SelectedRestaurantBloc>().state
                      as RestaurantSelectedSuccess)
                  .selectedRestaurant
                  .id,
              fasting: context.read<DiscoverMenuFastingSelectorCubit>().state,
              maxPrice: context.read<DiscoverMenuPriceSelectorCubit>().state,
              sortingQuery: map[dropdownValue].toString(),
              searchQuery: searchItemController.text,
              categoryId: context
                  .read<DiscoverMenuSelectedCategoryCubit>()
                  .state['categoryId'],
            ),
          );
    }
  }

  bool get _isItemBottom {
    if (!_itemScrollController.hasClients) return false;
    return _itemScrollController.position.maxScrollExtent ==
        _itemScrollController.position.pixels;
  }

  // Future onTagFilter() {
  // context.read<PopularBloc>().reset();
  // if (context.read<UserLocationBloc>().state is UserLocationLoaded) {
  //   var userLocation = (context.read<UserLocationBloc>().state as UserLocationLoaded).location;

  //   context.read<PopularBloc>().add(
  //         GetTopRatedEvent(
  //           page: 1,
  //           lat: userLocation.latitude,
  //           lng: userLocation.longitude,
  //           tag: context.read<TagBloc>().state.selectedTag,
  //         ),
  //       );
  //   context.read<HomePageNearbyRestaurantBloc>().add(
  //         GetNearByRestaurants(
  //           lat: userLocation.latitude,
  //           lng: userLocation.longitude,
  //           tag: context.read<TagBloc>().state.selectedTag,
  //           page: 1,
  //         ),
  //       );
  // } else {
  //   context.read<PopularBloc>().add(
  //         GetTopRatedEvent(
  //           page: 1,
  //           tag: context.read<TagBloc>().state.selectedTag,
  //         ),
  //       );
  //   context.read<RecommendedBloc>().add(
  //         GetRecommendedEvent(
  //           page: 1,
  //           tag: context.read<TagBloc>().state.selectedTag,
  //         ),
  //       );
  // }

  //   return Future.delayed(
  //     const Duration(
  //       seconds: 1,
  //     ),
  //   );
  // }
}

class DiscoveryItemPageCubit extends Cubit<int> {
  DiscoveryItemPageCubit() : super(1);
  void changePage(page) => emit(page);
}
