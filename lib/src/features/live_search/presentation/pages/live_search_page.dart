import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:geolocator/geolocator.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/user_engagement_analytics.dart';
import 'package:rateeat_mobile/src/core/service/firebase_analytics.dart';
import 'package:rateeat_mobile/src/core/service/local_analytics.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/live_search/data/data_sources/local_search_history_data_source.dart';
import 'package:rateeat_mobile/src/features/live_search/data/models/history.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/local_history/local_search_history_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/local_history/local_search_history_event.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/items_filter_search_result/items_filter_results_event.dart';

import '../../../authentication/data/data.dart';
import '../../../search_result/presentation/bloc/items_filter_search_result/items_filter_results_state.dart';
import '../bloc/live_search/search_event.dart';
import '../bloc/live_search/search_state.dart';
import '../bloc/live_search/search_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../discover_item/data/models/search_result.dart';
import '../../../homepage/domain/entities/item.dart';
import '../widgets/widgets.dart';

class LiveSearchPage extends StatefulWidget {
  const LiveSearchPage({
    super.key,
  });

  @override
  State<LiveSearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<LiveSearchPage> {
  final TextEditingController controller = TextEditingController();
  late String dropdownValue;
  List<String> list = [];

  bool getUser() {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      return user != null;
    } on CacheException {
      return false;
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
                var routeInfo = {
                  'routeName': AppRoutes.candidateRestaurantPage
                };
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

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    list = <String>[
      AppLocalizations.of(context)!.restaurantsText,
      AppLocalizations.of(context)!.itemsText
    ];
    dropdownValue = list[context.read<CategoriesToggleBloc>().state];
    // context.read<LiveSearchCubit>().changeQuery("");
    context.read<SearchBloc>().add(TriggerInitial());
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = SizeConfig.screenHeight;
    final screenWidth = SizeConfig.screenWidth;
    final locationState = BlocProvider.of<UserLocationBloc>(context).state;
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        toolbarHeight: screenHeight * 0.07,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(
              top: screenHeight * 0.015, left: screenWidth * 0.04),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: screenHeight * 0.05,
                width: screenHeight * 0.05,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [...elevation_4],
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.pop();
                  },
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 2.4.h,
                      semanticLabel: "Back",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
              horizontal: screenWidth * 0.05, vertical: screenHeight * 0.01),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              //* Search Title
              Text(
                dropdownValue == AppLocalizations.of(context)!.itemsText
                    ? AppLocalizations.of(context)!.findYourFavoriteFoodText
                    : AppLocalizations.of(context)!.favRestText,
                style: GoogleFonts.poppins(
                  fontSize: screenHeight * 0.024,
                  fontWeight: FontWeight.w500,
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              //* Search Area
              Center(
                child: Container(
                  height: screenHeight * 0.055,
                  width: double.infinity,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: const BorderRadius.all(
                      Radius.circular(20),
                    ),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.grey.withOpacity(0.3),
                        spreadRadius: 0.7,
                        blurRadius: 3,
                      ),
                    ],
                  ),
                  child: BlocConsumer<UserLocationBloc, UserLocationState>(
                    listener: (context, state) {
                      if (state is UserLocationError) {
                        showCustomToast(
                          context: context,
                          toastMessage: AppLocalizations.of(context)!
                              .locationPermissionText,
                          toastType: ToastType.warning,
                        );
                        Future.delayed(
                          const Duration(seconds: 2),
                          () async {
                            await Geolocator.openAppSettings();
                          },
                        );
                      }
                    },
                    builder: (context, state) {
                      if (state is UserLocationLoading) {
                        return Center(
                          child: LoadingAnimationWidget.dotsTriangle(
                            color: AppColors.primaryColor,
                            size: screenHeight * 0.04,
                          ),
                        );
                      }
                      if (state is UserLocationLoaded) {
                        return IntrinsicHeight(
                          child: Row(
                            mainAxisAlignment: MainAxisAlignment.start,
                            crossAxisAlignment: CrossAxisAlignment
                                .center, // Center row children vertically
                            children: [
                              Expanded(
                                child: BlocBuilder<
                                    RestaurantsFilterSearchResultsBloc,
                                    RestaurantsFilterSearchResultsState>(
                                  builder: (context, filterState) {
                                    return TextFormField(
                                      autofocus: true,
                                      controller: controller,
                                      cursorColor: Colors.black,
                                      decoration: InputDecoration(
                                        hintText: filterState
                                                .searchQuery.isEmpty
                                            ? "${AppLocalizations.of(context)!.locateYourNextMealText}..."
                                            : "",
                                        hintStyle: GoogleFonts.poppins(
                                          fontSize: screenHeight * 0.014,
                                          color: AppColors.grey400,
                                        ),
                                        border: InputBorder.none,
                                        contentPadding:
                                            const EdgeInsets.symmetric(
                                                vertical: 10, horizontal: 10),
                                      ),
                                      style: GoogleFonts.poppins(
                                        fontSize: screenHeight * 0.015,
                                        color: AppColors.grey600,
                                      ),
                                      onChanged: (searchQuery) {
                                        context
                                            .read<LiveSearchCubit>()
                                            .changeQuery(searchQuery);
                                        if (dropdownValue ==
                                            AppLocalizations.of(context)!
                                                .itemsText) {
                                          context.read<SearchBloc>().add(
                                                ItemSearchEvent(
                                                  query: searchQuery,
                                                  latitude:
                                                      state.location.latitude,
                                                  longitude:
                                                      state.location.longitude,
                                                ),
                                              );
                                        } else {
                                          context.read<SearchBloc>().add(
                                              RestaurantSearchEvent(
                                                  query: searchQuery));
                                        }
                                      },
                                    );
                                  },
                                ),
                              ),
                              BlocBuilder<LiveSearchCubit, String>(
                                builder: (context, liveSearchState) {
                                  var query =
                                      context.read<LiveSearchCubit>().state;
                                  return Opacity(
                                    opacity: query.isEmpty ? 0.0 : 1.0,
                                    child: Padding(
                                      padding: EdgeInsets.only(right: 15.sp),
                                      child: InkWell(
                                        splashColor: AppColors.primaryColor
                                            .withOpacity(.2),
                                        borderRadius:
                                            BorderRadius.circular(12.sp),
                                        onTap: () {
                                          context.read<SearchBloc>().add(
                                                TriggerInitial(),
                                              );
                                          controller.clear();
                                          context
                                              .read<LiveSearchCubit>()
                                              .changeQuery("");
                                        },
                                        child: Container(
                                          height: screenHeight * 0.025,
                                          width: screenHeight * 0.025,
                                          decoration: BoxDecoration(
                                            color: AppColors.grey200
                                                .withOpacity(0.4),
                                            borderRadius:
                                                BorderRadius.circular(11.sp),
                                          ),
                                          child: Padding(
                                            padding: EdgeInsets.all(
                                                screenHeight * 0.005),
                                            child: SvgPicture.asset(
                                              "assets/icons/x.svg",
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  );
                                },
                              ),
                              SizedBox(
                                height: screenHeight * 0.04,
                                child: VerticalDivider(
                                  width: 1,
                                  thickness: 1.3,
                                  color: Colors.grey.withOpacity(0.3),
                                ),
                              ),
                              const SizedBox(
                                width: 10,
                              ),
                              DropdownButton<String>(
                                dropdownColor: Colors.white,
                                value: dropdownValue,
                                icon: Icon(
                                  Icons.arrow_drop_down,
                                  size: 2.4.h,
                                  color: AppColors.primaryColor,
                                ),
                                borderRadius: BorderRadius.circular(6),
                                elevation: 10,
                                underline: Container(height: 0),
                                onChanged: (String? value) {
                                  setState(() {
                                    dropdownValue = value!;
                                  });
                                  context.read<SearchBloc>().add(
                                        TriggerInitial(),
                                      );
                                  context
                                      .read<CategoriesToggleBloc>()
                                      .toggleSwitch(
                                          list.indexOf(dropdownValue));
                                  // controller.text = "";
                                  context.read<LocalSearchHistoryBloc>().add(
                                        GetLocalSearchHistory(
                                          localSearchType: dropdownValue ==
                                                  AppLocalizations.of(context)!
                                                      .itemsText
                                              ? LocalSearchType.items
                                              : LocalSearchType.restaurants,
                                        ),
                                      );

                                  if (controller.text != '') {
                                    if (dropdownValue ==
                                        AppLocalizations.of(context)!
                                            .itemsText) {
                                      context.read<SearchBloc>().add(
                                            ItemSearchEvent(
                                              query: controller.text,
                                              latitude: state.location.latitude,
                                              longitude:
                                                  state.location.longitude,
                                            ),
                                          );
                                    } else {
                                      context.read<SearchBloc>().add(
                                            RestaurantSearchEvent(
                                                query: controller.text),
                                          );
                                    }
                                  }
                                },
                                items: list.map<DropdownMenuItem<String>>(
                                    (String value) {
                                  return DropdownMenuItem<String>(
                                    value: value,
                                    child: Text(
                                      value,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenHeight * 0.015,
                                        color: AppColors.grey500,
                                      ),
                                    ),
                                  );
                                }).toList(),
                              ),
                            ],
                          ),
                        );
                      }
                      return Container(
                        key: const Key("Can't get user location"),
                      );
                    },
                  ),
                ),
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),

              //* Search Results
              BlocBuilder<SearchBloc, SearchState>(
                builder: (context, state) {
                  if (state is SearchLoading) {
                    return Center(
                      key: const Key('live search loading'),
                      child: LoadingAnimationWidget.dotsTriangle(
                        color: AppColors.primaryColor,
                        size: 4.h,
                      ),
                    );
                  } else if (state is RestaurantSearchLoaded) {
                    List<RestaurantResult> restaurants = state.results;
                    return restaurants.isEmpty
                        ? SizedBox(
                            height: 50.h,
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                ErrorAndInfoDisplayWidget(
                                  assetImage: 'assets/icons/no_content.svg',
                                  title: AppLocalizations.of(context)!
                                      .noResultText,
                                  description: AppLocalizations.of(context)!
                                      .searchNoText,
                                  onPressed: null,
                                ),
                                verticalPadding(height: 1),
                                TextButton(
                                  style: ButtonStyle(
                                    backgroundColor: WidgetStatePropertyAll(
                                        AppColors.primaryColor
                                            .withOpacity(.15)),
                                  ),
                                  onPressed: getUser()
                                      ? () {
                                          context.pushNamed(AppRoutes
                                              .candidateRestaurantPage);
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
                              ],
                            ),
                          )
                        : Column(
                            children: [
                              ...List.generate(
                                restaurants.length,
                                (index) => Column(
                                  children: [
                                    InkWell(
                                      borderRadius: BorderRadius.circular(
                                        4,
                                      ),
                                      onTap: () {
                                        if (controller.text.isNotEmpty) {
                                          context
                                              .read<LocalSearchHistoryBloc>()
                                              .add(
                                                AddLocalSearchHistory(
                                                  history: History(
                                                    id: restaurants[index].id,
                                                    title:
                                                        restaurants[index].name,
                                                  ),
                                                  localSearchType:
                                                      LocalSearchType
                                                          .restaurants,
                                                ),
                                              );
                                        }
                                        context.read<SearchBloc>().add(
                                              TriggerInitial(),
                                            );

                                        //* Update Restaurant Search Analytics
                                        dpLocator<AnalyticsObserver>()
                                            .sendAnalyticsEvent(
                                          eventName: 'restaurant_search',
                                          params: {
                                            'restaurant_id':
                                                restaurants[index].id,
                                            'restaurant_name':
                                                restaurants[index].name,
                                          },
                                        );
                                        dpLocator<LocalAnalyticsObserver>()
                                            .updateUserEngagementAnalytics(
                                                update: UserEngagementAnalytics(
                                                    restaurantSearchPage: 1));
                                        context.pushNamed(
                                          AppRoutes.restaurantDetail,
                                          pathParameters: {
                                            'restaurantId':
                                                restaurants[index].id
                                          },
                                        );
                                      },
                                      child: SearchResultTile(
                                        isLast: index == restaurants.length - 1,
                                        title: restaurants[index].name,
                                      ),
                                    ),
                                    if (!(index == restaurants.length - 1))
                                      Divider(
                                        color:
                                            AppColors.grey200.withOpacity(.6),
                                      ),
                                  ],
                                ),
                              ),
                              verticalPadding(height: 2),
                              ElevatedButton(
                                style: ButtonStyle(
                                  padding: WidgetStatePropertyAll(
                                    EdgeInsets.symmetric(
                                        vertical: 16, horizontal: 24.sp),
                                  ),
                                  shape: WidgetStatePropertyAll(
                                    RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12),
                                    ),
                                  ),
                                  elevation: const WidgetStatePropertyAll(0),
                                  overlayColor: WidgetStatePropertyAll(
                                      AppColors.primaryColor.withOpacity(.4)),
                                  backgroundColor: WidgetStatePropertyAll(
                                    AppColors.primaryColor.withOpacity(.2),
                                  ),
                                ),
                                onPressed: getUser()
                                    ? () {
                                        context.pushNamed(
                                            AppRoutes.candidateRestaurantPage);
                                      }
                                    : () {
                                        _showLoginDialog(context);
                                      },
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    // const Icon(
                                    //   Iconsax.additem ,
                                    //   color: Colors.black,
                                    // ),
                                    // horizontalPadding(width: 4),
                                    Column(
                                      children: [
                                        Text(
                                          "Suggest a restaurant",
                                          style: bodyTextStyle.copyWith(
                                            color: Colors.black,
                                            fontSize: 14,
                                            fontWeight: FontWeight.w400,
                                          ),
                                        ),
                                      ],
                                    )
                                  ],
                                ),
                              ),
                            ],
                          );
                  } else if (state is ItemSearchLoaded) {
                    List<Item> items = state.results;
                    return items.isEmpty
                        ? ErrorAndInfoDisplayWidget(
                            assetImage: 'assets/icons/no_content.svg',
                            title: AppLocalizations.of(context)!.noResultText,
                            description:
                                AppLocalizations.of(context)!.searchNoText,
                            onPressed: null,
                          )
                        : ListView.builder(
                            shrinkWrap: true,
                            itemCount: items.length,
                            itemBuilder: (BuildContext context, int index) {
                              return Column(
                                children: [
                                  InkWell(
                                    borderRadius: BorderRadius.circular(
                                      4,
                                    ),
                                    onTap: () {
                                      if (controller.text.isNotEmpty) {
                                        context
                                            .read<LocalSearchHistoryBloc>()
                                            .add(
                                              AddLocalSearchHistory(
                                                history: History(
                                                  id: items[index].itemId,
                                                  title: items[index].itemName,
                                                ),
                                                localSearchType:
                                                    LocalSearchType.items,
                                              ),
                                            );
                                      }
                                      //* Update Item Search Analytics
                                      dpLocator<AnalyticsObserver>()
                                          .sendAnalyticsEvent(
                                        eventName: 'item_search',
                                        params: {
                                          'item_id': items[index].itemId,
                                          'item_name': items[index].itemName,
                                        },
                                      );
                                      dpLocator<LocalAnalyticsObserver>()
                                          .updateUserEngagementAnalytics(
                                              update: UserEngagementAnalytics(
                                                  itemSearchPage: 1));

                                      if (locationState is UserLocationLoaded) {
                                        context
                                            .read<
                                                ItemsFilterSearchResultsBloc>()
                                            .add(
                                              GetFilteredItemsEvent(
                                                searchQuery:
                                                    items[index].itemName,
                                                selection: ItemsFilterState
                                                    .highestRated,
                                                isFasting: false,
                                                rating: 0,
                                                location:
                                                    locationState.location,
                                                maximumPrice: 5000,
                                                latitude: locationState
                                                    .location.latitude,
                                                longitude: locationState
                                                    .location.longitude,
                                              ),
                                            );
                                      }
                                      context
                                          .read<CategoriesToggleBloc>()
                                          .toggleSwitch(
                                            list.indexOf(dropdownValue),
                                          );
                                      context
                                          .read<LiveSearchCubit>()
                                          .changeQuery(
                                            items[index].itemName,
                                          );
                                      context.pop();
                                      context.read<SearchBloc>().add(
                                            TriggerInitial(),
                                          );
                                    },
                                    child: SearchResultTile(
                                      isLast: index == items.length - 1,
                                      title: items[index].itemName,
                                    ),
                                  ),
                                  if (!(index == items.length - 1))
                                    Divider(
                                      color: AppColors.grey200.withOpacity(.6),
                                    ),
                                ],
                              );
                            },
                          );
                  } else if (state is SearchError) {
                    return Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: <Widget>[
                          ErrorAndInfoDisplayWidget(
                            assetImage: "assets/icons/no_internet.svg",
                            title: "Loading results failed.",
                            description:
                                "Unable to load results. Please try again.",
                            onPressed: () {
                              if (locationState is UserLocationLoaded) {
                                context.read<SearchBloc>().add(
                                      dropdownValue == "Items"
                                          ? RestaurantSearchEvent(
                                              query: controller.text)
                                          : ItemSearchEvent(
                                              query: controller.text,
                                              latitude: locationState
                                                  .location.latitude,
                                              longitude: locationState
                                                  .location.longitude,
                                            ),
                                    );
                              }
                            },
                          ),
                        ],
                      ),
                    );
                  } else {
                    return locationState is UserLocationLoaded
                        ? Column(
                            children: [
                              PopularSearches(
                                dropDownValue: dropdownValue,
                                controller: controller,
                                latitude: locationState.location.latitude,
                                longitude: locationState.location.longitude,
                              ),
                              SizedBox(
                                height: screenHeight * 0.01,
                              ),
                              LocalSearches(
                                dropDownValue: dropdownValue,
                                controller: controller,
                                latitude: locationState.location.latitude,
                                longitude: locationState.location.longitude,
                              )
                            ],
                          )
                        : Container();
                  }
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    this.isLast = false,
    required this.title,
  });

  final String title;

  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 26.sp,
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.sp),
                child: SizedBox(
                  height: 30.sp,
                  width: 30.sp,
                  child: Padding(
                    padding: EdgeInsets.symmetric(horizontal: 6.sp),
                    child: SvgPicture.asset(
                      "assets/icons/search_result.svg",
                    ),
                  ),
                ),
              ),
              SizedBox(
                width: 50.w,
                child: Text(
                  title,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                  style: TextStyle(
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class LiveSearchCubit extends Cubit<String> {
  LiveSearchCubit() : super("");
  void changeQuery(query) => emit(query);
}
