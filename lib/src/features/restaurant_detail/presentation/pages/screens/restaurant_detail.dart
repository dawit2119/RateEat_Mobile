import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/service/firebase_analytics.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/order/presentation/pages/select_orders_page.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_event.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_detail/restaurant_detail_state.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_items/restaurant_items_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_popular_reviews/restaurant_popular_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/pages/restaurant_menu.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_restaurant_review/delete_restaurant_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/add_review_widget.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/restaurant_review_card.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/pages/widgets/widgets.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/shimmer/restaurant_review_shimmer.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/suggest_price_change.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'package:video_player/video_player.dart';

import '../../../../../core/service/local_analytics.dart';
import '../../../../../core/widgets/custom_alert_widget.dart';
import '../../../../homepage/presentation/widgets/shimmer/popular_items_shimmer.dart';
import '../../../../order/presentation/widgets/order_button.dart';
import '../../../../restaurant_menu/presentation/bloc/restaurant_category/restaurant_category_bloc.dart';
import '../../../../restaurant_menu/presentation/bloc/restaurant_menu/restaurant_menu_bloc.dart';
import '../../../../user_profile/presentation/pages/custom_tab_bar.dart';
import '../../bloc/restaurant_items/popular_restaurant_items_bloc.dart';
import '../widgets/popular_items.dart';

class RestaurantDetail extends StatefulWidget {
  final String? loginRedirection;
  final String restaurantId;
  final bool hasQuery;
  // used to inject mock video player controller
  final VideoPlayerController? videoPlayerController;
  const RestaurantDetail({
    super.key,
    required this.restaurantId,
    this.loginRedirection,
    this.hasQuery = false,
    this.videoPlayerController,
  });

  @override
  State<RestaurantDetail> createState() => _RestaurantDetailState();
}

class _RestaurantDetailState extends State<RestaurantDetail> {
  int reviewRetryCount = 0;
  int menuRetryCount = 0;
  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
  Map<String, double?> locationData = {"longitude": null, "latitude": null};

  @override
  void initState() {
    super.initState();
    final cartCubit = context.read<CartCubit>();
    cartCubit.resetCart();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    var userLocationState = context.read<UserLocationBloc>().state;
    if (userLocationState is UserLocationLoaded) {
      Location location = userLocationState.location;
      locationData = {
        'longitude': location.longitude,
        "latitude": location.latitude
      };
    }
    return MultiBlocProvider(
      providers: [
        //* ----------------------------- Restaurant Detail Bloc --------------------------------
        BlocProvider<RestaurantDetailBloc>(
          create: (context) => dpLocator<RestaurantDetailBloc>()
            ..add(GetRestaurantDetailEvent(
              restaurantId: widget.restaurantId,
              longitude: locationData['longitude'],
              latitude: locationData['latitude'],
            )),
        ),
        BlocProvider<RestaurantPopularItemsBloc>(
          create: (context) => dpLocator<RestaurantPopularItemsBloc>()
            ..add(GetRestaurantPopularItems(
              restaurantId: widget.restaurantId,
            )),
        ),
        BlocProvider<RestaurantPopularReviewsBloc>(
          create: (context) => dpLocator<RestaurantPopularReviewsBloc>()
            ..add(GetRestaurantPopularReviewsEvent(
                restaurantId: widget.restaurantId)),
        ),
      ],
      child: PopScope(
        canPop: false,
        onPopInvokedWithResult: (didPop, _) {
          if (widget.hasQuery || widget.loginRedirection != null) {
            context.goNamed(
              AppRoutes.home,
            );
          } else {
            context.pop();
          }
        },
        child: Scaffold(
          body: BlocConsumer<RestaurantDetailBloc, RestaurantDetailState>(
            key: UniqueKey(), // Ensure a unique key
            listener: (context, state) {},
            builder: (context, state) {
              if (state is RestaurantDetailLoading) {
                return SizedBox(
                  key: const Key("Restaurant Detail Loading"),
                  height: 100.h,
                  width: 100.w,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        LoadingAnimationWidget.dotsTriangle(
                          color: AppColors.primaryColor,
                          size: 6.h,
                        ),
                        SizedBox(
                          height: 1.h,
                        ),
                        Text(
                          AppLocalizations.of(context)!.restaurantDetailsText,
                          style: subTitleTextStyle,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (state is RestaurantDetailError) {
                return SizedBox(
                  key: const Key("Restaurant Detail Error"),
                  height: 100.h,
                  width: 100.w,
                  child: Center(
                    child: ErrorAndInfoDisplayWidget(
                      assetImage: "assets/icons/no_internet.svg",
                      title: AppLocalizations.of(context)!.unknownErrorText,
                      description: AppLocalizations.of(context)!.tryAgainText,
                      onPressed: () {
                        context.read<RestaurantDetailBloc>().add(
                            GetRestaurantDetailEvent(
                                restaurantId: widget.restaurantId));
                        context.read<RestaurantPopularReviewsBloc>().add(
                            GetRestaurantPopularReviewsEvent(
                                restaurantId: widget.restaurantId));
                      },
                    ),
                  ),
                );
              } else if (state is RestaurantDetailSuccess) {
                final RestaurantModel restaurant = state.restaurant;
                context.read<UserReviewsPageCubit>().changePage(1);
                context.read<RestaurantPopularReviewsBloc>().add(
                      GetRestaurantPopularReviewsEvent(
                          restaurantId: restaurant.id ?? ""),
                    );
                if (user != null && context.mounted) {
                  context.read<UserReviewBloc>().add(
                        GetUserReviewEvent(
                          userId: user!.id ?? "",
                        ),
                      );
                }
                //* add the analytics for restaurant detail
                dpLocator<AnalyticsObserver>().sendAnalyticsEvent(
                  eventName: 'restaurant_detail',
                  params: {
                    'restaurant_id': restaurant.id,
                    'restaurant_name': restaurant.name,
                    'restaurant_average_rating': restaurant.averageRating,
                    'restaurant_average_price': restaurant.averagePrice,
                    'restaurant_opening_hour': restaurant.openingHour,
                    'restaurant_closing_hour': restaurant.closingHour,
                  },
                );
                dpLocator<LocalAnalyticsObserver>()
                    .updateRestaurantAnalytics(params: {
                  'restaurant_id': restaurant.id,
                  'restaurant_name': restaurant.name,
                });

                return CustomScrollView(
                  slivers: [
                    //* Highlights
                    SliverPersistentHeader(
                      delegate: CustomSliverRestaurantAppBarDelegate(
                        expandedHeight: 40.h,
                        restaurant: restaurant,
                        videoPlayerController: widget.videoPlayerController,
                      ),
                      pinned: true,
                    ),
                    SliverToBoxAdapter(
                      child: buildRestaurantInfo(restaurant, context),
                    )
                  ],
                );
              }
              return Container();
            },
          ),
          bottomNavigationBar:
              BlocBuilder<RestaurantDetailBloc, RestaurantDetailState>(
            builder: (context, state) {
              if (state is RestaurantDetailSuccess) {
                bool isOpen;
                if (state.restaurant.closingHour != null &&
                    state.restaurant.openingHour != null) {
                  var now = DateTime.now();
                  var closingHour = state.restaurant.closingHour!.split(":");
                  var openingHour = state.restaurant.openingHour!.split(":");
                  var closingTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    int.parse(closingHour[0]),
                    int.parse(closingHour[1]),
                    int.parse(closingHour[2]),
                  );
                  var openingTime = DateTime(
                    now.year,
                    now.month,
                    now.day,
                    int.parse(openingHour[0]),
                    int.parse(openingHour[1]),
                    int.parse(openingHour[2]),
                  );
                  isOpen = closingTime.compareTo(now) == 1 &&
                      now.compareTo(openingTime) == 1;
                } else {
                  isOpen = false;
                }
                if (state.restaurant.restaurantOrderServiceAvailable &&
                    state.restaurant.restaurantOrderServiceOnline &&
                    isOpen) {
                  return IntrinsicHeight(
                    child: Container(
                      width: 100.w,
                      padding: EdgeInsets.symmetric(
                        horizontal: 5.w,
                        vertical: 1.5.h,
                      ),
                      decoration: const BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.only(
                          topLeft: Radius.circular(25),
                          topRight: Radius.circular(25),
                        ),
                        boxShadow: [
                          BoxShadow(
                            color: AppColors.grey200,
                            offset: Offset(1, -5),
                            blurRadius: 9,
                          ),
                        ],
                      ),
                      child: OrderButton(
                        child: Text(
                          AppLocalizations.of(context)!.orderNowCapitalText,
                          style: GoogleFonts.plusJakartaSans(
                            fontWeight: FontWeight.w600,
                            fontSize: 14,
                            color: Colors.white,
                          ),
                        ),
                        onTap: () {
                          if (user == null) {
                            _showLoginDialog(
                              context,
                              restaurant: state.restaurant,
                            );
                            return;
                          }
                          context.read<RestaurantCategoryBloc>().add(
                                GetRestaurantCategoriesEvent(
                                  restaurantId: state.restaurant.id!,
                                ),
                              );
                          context.read<RestaurantMenuBloc>().add(
                                GetRestaurantMenuCategoryItems(
                                  restaurantId: state.restaurant.id!,
                                  categoryId: "",
                                  page: 1,
                                  limit: 10,
                                ),
                              );
                          context.pushNamed(
                            AppRoutes.selectOrdersPage,
                            pathParameters: {
                              "restaurantId": state.restaurant.id!,
                            },
                            extra: state.restaurant,
                          );
                        },
                      ),
                    ),
                  );
                }
              }
              return Container(
                height: 0,
              );
            },
          ),
        ),
      ),
    );
  }

  Widget buildRestaurantInfo(RestaurantModel restaurant, context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Alerts
        if (restaurant.doShowAvailabilityAlert)
          Padding(
            padding: EdgeInsets.symmetric(
              horizontal: 1.h,
              vertical: .4.h,
            ),
            child: const CustomAlertWidget(
              text:
                  'Be aware. The restaurant might not be available at the moment',
            ),
          ),
        //* Restaurant Detail Info
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: EdgeInsets.symmetric(horizontal: 4.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: 6),
                  RestaurantTitle(
                    restaurant: restaurant,
                  ),
                  //SizedBox(height: 1.h),
                  //* Map Information
                  //  SuggestPriceChange(isItem: false, restaurant: restaurant),
                  const Divider(
                    color: AppColors.grey200,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  //Popular Items
                  Text(
                    AppLocalizations.of(context)!.popularText,
                    style: titleTextStyle.copyWith(
                      fontSize: 17.sp,
                      color: const Color(
                        0xFF586069,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.5.h),
                  BlocBuilder<RestaurantPopularItemsBloc, RestaurantItemsState>(
                    builder: (context, state) {
                      if (state is RestaurantPopularItemsFetching) {
                        return const PopularItemsShimmerVertical();
                      }
                      if (state is RestaurantPopularItemsFetched) {
                        return state.popularItems.isEmpty
                            ? Container(
                                padding:
                                    const EdgeInsets.symmetric(horizontal: 5),
                                margin: const EdgeInsets.only(
                                  top: 10,
                                  bottom: 15,
                                ),
                                child: Center(
                                  child: Text(
                                    AppLocalizations.of(context)!.noPopularText,
                                    style: GoogleFonts.poppins(
                                      fontSize: 16.sp,
                                      color: Colors.red,
                                    ),
                                  ),
                                ),
                              )
                            : Container(
                                margin: const EdgeInsets.only(
                                  bottom: 10,
                                ),
                                child: PopularItemsPage(
                                  restaurantItems: state.popularItems,
                                  restaurant: restaurant,
                                ),
                              );
                      }
                      if (menuRetryCount < 4) {
                        menuRetryCount++;
                        context.read<RestaurantPopularItemsBloc>().add(
                              GetRestaurantPopularItems(
                                restaurantId: widget.restaurantId,
                              ),
                            );
                        return Container();
                      }
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Text(
                              AppLocalizations.of(context)!.errorPopularText,
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                                color: Colors.red,
                              ),
                            ),
                            SizedBox(
                              height: 1.h,
                            ), // Add spacing between text and button
                            ElevatedButton(
                              onPressed: () {
                                context.read<RestaurantPopularItemsBloc>().add(
                                      GetRestaurantPopularItems(
                                        restaurantId: widget.restaurantId,
                                      ),
                                    );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(Colors.red),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.retryText,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    },
                  ),

                  //* Restaurant Information
                  SizedBox(height: 4.h),
                  //* Add Review Button
                  AddReview(
                    isItem: false,
                    restaurant: restaurant,
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                  Text(
                    AppLocalizations.of(context)!.userReviewText,
                    style: titleTextStyle.copyWith(
                      fontSize: 17.sp,
                      color: const Color(
                        0xFF586069,
                      ),
                    ),
                  ),
                  SizedBox(height: 1.h),
                  BlocBuilder<RestaurantPopularReviewsBloc,
                      RestaurantPopularReviewsState>(
                    builder: (context, state) {
                      if (state is PopularRestaurantReviewsLoading) {
                        return const RestaurantShimmerDisplay();
                      } else if (state is PopularRestaurantReviewsLoaded) {
                        final reviews = state.popularReviews.reviews;
                        if (reviews.isEmpty) {
                          return Column(
                            key: Key(
                                "popular_restaurant_reviews_loaded_and_empty"),
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Center(
                                child: Text(
                                  AppLocalizations.of(context)!.firstReviewText,
                                  style: GoogleFonts.poppins(
                                    fontSize: 16.sp,
                                  ),
                                ),
                              ),
                              SizedBox(height: 2.h),
                            ],
                          );
                        }
                        return BlocConsumer<DeleteRestaurantReviewBloc,
                            DeleteRestaurantReviewState>(
                          listener: (context, state) {
                            if (state is DeleteRestaurantReviewSuccess) {
                              showCustomToast(
                                context: context,
                                toastMessage: "Restaurant ${state.message}",
                                toastType: ToastType.success,
                                showIcon: false,
                              );

                              //* Call to load the current Review
                              context.read<RestaurantPopularReviewsBloc>().add(
                                  GetRestaurantPopularReviewsEvent(
                                      restaurantId: restaurant.id!));
                              context.read<UserReviewBloc>().add(
                                    GetUserReviewEvent(
                                      userId: user!.id!,
                                    ),
                                  );
                            } else if (state is DeleteRestaurantReviewFailure) {
                              showCustomToast(
                                context: context,
                                toastMessage: "Restaurant ${state.message}",
                                toastType: ToastType.error,
                                showIcon: false,
                              );
                            } else {}
                          },
                          builder: (context, state) {
                            return Column(
                              key: Key(
                                  "popular_restaurant_reviews_loaded_and_has_values"),
                              children: [
                                ListView.builder(
                                  physics: const NeverScrollableScrollPhysics(),
                                  shrinkWrap: true,
                                  itemCount: reviews.length,
                                  scrollDirection: Axis.vertical,
                                  itemBuilder: (context, index) {
                                    final currentReview = reviews[index];
                                    return RestaurantReviewsCard(
                                        restaurant: restaurant,
                                        userReview: currentReview);
                                  },
                                ),
                                if ((restaurant.numberOfReviews ?? 0) >
                                    reviews.length)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Container(),
                                      SingleChip(
                                        selected: true,
                                        title: AppLocalizations.of(context)!
                                            .seeText,
                                        onTap: () {
                                          context.pushNamed(
                                            AppRoutes.restaurantReviews,
                                            pathParameters: {
                                              'restaurantId': restaurant.id!
                                            },
                                            extra: {
                                              'restaurant': restaurant,
                                            },
                                          );
                                        },
                                      ),
                                    ],
                                  ),
                                const SizedBox(
                                  height: 10,
                                ),
                              ],
                            );
                          },
                        );
                      } else if (state is PopularRestaurantReviewsFailure) {
                        if (reviewRetryCount < 4) {
                          reviewRetryCount++;
                          context.read<RestaurantPopularReviewsBloc>().add(
                              GetRestaurantPopularReviewsEvent(
                                  restaurantId: widget.restaurantId));

                          return Container();
                        }
                        return Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: <Widget>[
                              Text(
                                AppLocalizations.of(context)!.errorReviewText,
                                style: const TextStyle(
                                  color: Colors.red,
                                  fontWeight: FontWeight.w400,
                                ),
                              ),
                              SizedBox(
                                height: 1.h,
                              ), // Add spacing between text and button
                              ElevatedButton(
                                onPressed: () {
                                  context
                                      .read<RestaurantPopularReviewsBloc>()
                                      .add(GetRestaurantPopularReviewsEvent(
                                          restaurantId: widget.restaurantId));
                                },
                                style: ButtonStyle(
                                  backgroundColor:
                                      WidgetStateProperty.all<Color>(
                                          Colors.red),
                                ),
                                child: Text(
                                    AppLocalizations.of(context)!.retryText,
                                    style:
                                        const TextStyle(color: Colors.white)),
                              ),
                              SizedBox(height: 3.h),
                            ],
                          ),
                        );
                      } else {
                        return Container();
                      }
                    },
                  ),
                  SizedBox(
                    height: 1.h,
                  ),
                ],
              ),
            ),
          ],
        ),
      ],
    );
  }

  getOpeningHoursWidget(Restaurant restaurant) {
    // try {
    DateFormat formatter = DateFormat('HH:mm:ss');
    DateTime now = DateTime.now();
    DateTime? openingTime = formatter.parse(restaurant.openingHour!);
    DateTime? closingTime = formatter.parse(restaurant.closingHour!);

    bool isOpen() {
      if (openingTime == null || closingTime == null) return false;

      // Get today's date at midnight to avoid date components interfering with the comparison
      DateTime todayMidnight = DateTime(now.year, now.month, now.day);

      // Add the parsed time components to today's date
      openingTime = todayMidnight.add(
          Duration(hours: openingTime!.hour, minutes: openingTime!.minute));
      closingTime = todayMidnight.add(
          Duration(hours: closingTime!.hour, minutes: closingTime!.minute));

      return now.isAfter(openingTime!) && now.isBefore(closingTime!);
    }

    if (isOpen()) {
      return Text(
        AppLocalizations.of(context)!.openText,
        style: GoogleFonts.poppins(
          color: AppColors.successColor,
          fontSize: 16.sp,
          fontWeight: FontWeight.w600,
        ),
      );
    } else {
      return Text(
        AppLocalizations.of(context)!.closedText,
        style: GoogleFonts.poppins(
          fontSize: 16.sp,
          color: AppColors.failureColor,
          fontWeight: FontWeight.w600,
        ),
      );
    }
  }
}

void _showLoginDialog(
  BuildContext context, {
  Restaurant? restaurant,
}) {
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
                'routeName': AppRoutes.restaurantDetail,
                'restaurant': restaurant,
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
