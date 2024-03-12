import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/order/presentation/widgets/order_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

class QRMenuPage extends StatefulWidget {
  final String restaurantId;

  const QRMenuPage({
    super.key,
    required this.restaurantId,
  });

  @override
  State<StatefulWidget> createState() {
    return QRMenuPageState();
  }
}

class QRMenuPageState extends State<QRMenuPage> {
  QRCategory? selectedCategory;
  bool? isFasting;
  int minRating = 0;
  List<PriceRange> priceRanges = [
    const PriceRangeModel(minPrice: null, maxPrice: 200, count: null),
    const PriceRangeModel(minPrice: 200, maxPrice: 500, count: null),
    const PriceRangeModel(minPrice: 500, maxPrice: 1000, count: null),
    const PriceRangeModel(minPrice: 1000, maxPrice: 2000, count: null),
    const PriceRangeModel(minPrice: 2000, maxPrice: null, count: null),
  ];
  int? minPrice;
  int? maxPrice;
  String? sortBy;
  String sortType = "Desc";
  ScrollController categoriesController = ScrollController();
  ScrollController pageScrollController = ScrollController();
  TextEditingController searchController = TextEditingController();
  String restaurantName = "";
  String restaurantImage = "";

  @override
  void initState() {
    super.initState();
    // if (context.read<QRMenuBloc>().state is! QRMenuLoaded) {
    context.read<QRMenuBloc>().add(
          GetQRMenu(
              restaurantId: widget.restaurantId,
              page: 1,
              sortBy: sortBy,
              sortType: "Desc",
              isFasting: isFasting,
              query: "",
              maxPrice: maxPrice,
              minPrice: minPrice,
              minRating: minRating),
        );
    // }

    categoriesController.addListener(() {
      if (categoriesController.position.pixels ==
          categoriesController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
    pageScrollController.addListener(() {
      if (pageScrollController.position.pixels ==
          pageScrollController.position.maxScrollExtent) {
        loadNextPage();
      }
    });
  }

  void callBack(QRCategoryModel category) {
    setState(() {
      selectedCategory = category;
    });
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: selectedCategory == null,
      onPopInvokedWithResult: (didPop, result) {
        if (!didPop) {
          if (selectedCategory != null) {
            setState(() {
              selectedCategory = null;
            });
          } else {
            context.pop();
          }
        } else {
          return;
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: Colors.white,
          leading: Container(),
          centerTitle: true,
          title:
              BlocBuilder<QRMenuBloc, QRMenuState>(builder: (context, state) {
            return BlocListener<QRMenuBloc, QRMenuState>(
              listener: (context, state) {
                if (state is QRMenuLoaded) {
                  setState(() {
                    restaurantName = state.menu.restaurantName;
                    restaurantImage = state.menu.restaurantImageUrl ?? "";
                  });
                }
              },
              child: GestureDetector(
                onTap: () {
                  context.pushNamed(
                    AppRoutes.restaurantDetail,
                    pathParameters: {
                      'restaurantId': widget.restaurantId,
                    },
                  );
                },
                child: SizedBox(
                  width: 55.w,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      if ((state is QRMenuLoaded &&
                              (state.menu.restaurantImageUrl ?? "") != "") ||
                          restaurantImage != "")
                        CachedNetworkImage(
                          imageUrl: (state is QRMenuLoaded &&
                                  (state.menu.restaurantImageUrl ?? "") != "")
                              ? state.menu.restaurantImageUrl!
                              : restaurantImage,
                          height: 4.h,
                        ),
                      SizedBox(width: 3.w),
                      SizedBox(
                        width: (30.w),
                        child: Text(
                          state is QRMenuLoaded
                              ? state.menu.restaurantName
                              : restaurantName,
                          maxLines: 1,
                          style: GoogleFonts.poppins(
                              color: Colors.black,
                              fontSize: 20.sp,
                              fontWeight: FontWeight.w600),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          }),
          actions: [
            IconButton(
              onPressed: () {
                showFilterBottomSheet();
              },
              icon: Container(
                padding: EdgeInsets.all(2.w),
                decoration: BoxDecoration(
                  color: const Color(0xFFFFF3ED),
                  borderRadius: BorderRadius.circular(5.w),
                ),
                child: Icon(
                  Iconsax.document_filter,
                  color: AppColors.grey700,
                  size: 20.sp,
                ),
              ),
            ),
          ],
        ),
        body: SingleChildScrollView(
          physics: const NeverScrollableScrollPhysics(),
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(horizontal: 3.w),
                child: TextFormField(
                  controller: searchController,
                  onChanged: (text) {
                    context.read<QRMenuBloc>().add(GetQRMenu(
                        restaurantId: widget.restaurantId,
                        page: 1,
                        sortType: sortType,
                        isFasting: isFasting,
                        category: selectedCategory,
                        query: text,
                        sortBy: sortBy,
                        maxPrice: maxPrice,
                        minPrice: minPrice,
                        minRating: minRating));
                  },
                  textAlignVertical: TextAlignVertical.center,
                  decoration: InputDecoration(
                    filled: true,
                    border: InputBorder.none,
                    enabledBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(50), // Rounded corners
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    focusedBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(50), // Rounded corners
                      borderSide: const BorderSide(color: Colors.transparent),
                    ),
                    errorBorder: OutlineInputBorder(
                      borderRadius:
                          BorderRadius.circular(50), // Rounded corners
                      borderSide: const BorderSide(
                          color: Colors.red), // Error border color
                    ),
                    hintStyle: GoogleFonts.poppins(
                      color: AppColors.grey500,
                      fontSize: 16.sp,
                    ),
                    contentPadding: EdgeInsets.symmetric(
                      horizontal: 20.sp,
                      vertical: 8.sp,
                    ),
                    hintText: "Search",
                    fillColor: AppColors.grey100,
                    labelStyle: TextStyle(
                      color: AppColors.grey500,
                      fontSize: 18.h,
                    ),
                    prefixIcon: Padding(
                      padding: EdgeInsets.symmetric(
                        horizontal: 20.sp,
                        vertical: 15.sp,
                      ),
                      child: const Icon(
                        Iconsax.search_normal_1,
                        color: AppColors.grey500,
                      ),
                    ),
                  ),
                ),
              ),
              BlocListener<QRMenuBloc, QRMenuState>(
                listener: (context, state) {
                  setState(
                    () {
                      minRating = state.minRating ?? 0;
                      maxPrice = state.maxPrice;
                      minPrice = state.minPrice;
                      sortBy = state.sortBy;
                      sortType = state.sortType;
                      if (state is QRMenuLoaded &&
                          !state.menu.categories.contains(selectedCategory)) {
                        selectedCategory = null;
                      }
                    },
                  );
                },
                child: BlocBuilder<QRMenuBloc, QRMenuState>(
                    builder: (context, state) {
                  if (state is QRMenuLoaded || state is QRMenuNextLoading) {
                    return Container(
                      padding:
                          EdgeInsets.symmetric(vertical: 1.h, horizontal: 2.w),
                      color: Colors.transparent,
                      child: Column(
                        children: [
                          Padding(
                            padding: EdgeInsets.symmetric(vertical: 1.h),
                            child: SizedBox(
                              width: 95.w,
                              child: SingleChildScrollView(
                                scrollDirection: Axis.horizontal,
                                controller: categoriesController,
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.start,
                                  children: [
                                    GestureDetector(
                                      onTap: () {
                                        setState(() {
                                          selectedCategory = null;
                                        });
                                      },
                                      child: CategoryChip(
                                        leadingWidget: Icon(
                                          Iconsax.element_plus,
                                          color: Colors.black,
                                          size: 18.sp,
                                        ),
                                        categoryName: "All",
                                        selectionColor: AppColors.primaryColor,
                                        isSelected: selectedCategory == null,
                                      ),
                                    ),
                                    ...(state is QRMenuLoaded
                                            ? state.menu.categories
                                            : (state as QRMenuNextLoading)
                                                .menu
                                                .categories)
                                        .map((category) => GestureDetector(
                                              onTap: () {
                                                setState(() {
                                                  selectedCategory = category;
                                                });
                                              },
                                              child: CategoryChip(
                                                isSelected: selectedCategory ==
                                                    category,
                                                selectionColor:
                                                    AppColors.primaryColor,
                                                categoryName: category.name,
                                                leadingWidget:
                                                    SvgPicture.network(
                                                        category.imageUri),
                                              ),
                                            )),
                                    if (state is QRMenuNextLoading)
                                      Shimmer.fromColors(
                                        baseColor: AppColors.shimmerBaseColor,
                                        highlightColor:
                                            AppColors.shimmerHighlightColor,
                                        child: Container(
                                          height: 5.h,
                                          width: 20.w,
                                          decoration: BoxDecoration(
                                            borderRadius:
                                                BorderRadius.circular(10.0),
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          Row(
                            children: [
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFasting = isFasting == true ? null : true;
                                  });
                                  context.read<QRMenuBloc>().add(
                                        GetQRMenu(
                                          restaurantId: widget.restaurantId,
                                          page: 1,
                                          sortType: sortType,
                                          isFasting: isFasting,
                                          query: searchController.text,
                                          sortBy: sortBy,
                                          minPrice: minPrice,
                                          maxPrice: maxPrice,
                                          minRating: minRating,
                                        ),
                                      );
                                },
                                child: CategoryChip(
                                  selectionColor: AppColors.primaryColor,
                                  isSelected: isFasting ?? false,
                                  categoryName: "Vegetarian",
                                ),
                              ),
                              GestureDetector(
                                onTap: () {
                                  setState(() {
                                    isFasting =
                                        isFasting == false ? null : false;
                                  });
                                  context.read<QRMenuBloc>().add(
                                        GetQRMenu(
                                          restaurantId: widget.restaurantId,
                                          page: 1,
                                          sortType: sortType,
                                          isFasting: isFasting,
                                          query: searchController.text,
                                          sortBy: sortBy,
                                          minPrice: minPrice,
                                          maxPrice: maxPrice,
                                          minRating: minRating,
                                        ),
                                      );
                                },
                                child: CategoryChip(
                                  selectionColor: AppColors.primaryColor,
                                  isSelected: !(isFasting ?? true),
                                  categoryName: "Non-Vegetarian",
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            height: 1.h,
                          ),
                          SizedBox(
                            // height: constraints.maxHeight -
                            //     MediaQuery.of(context).viewInsets.bottom,
                            height:
                                68.h - MediaQuery.of(context).viewInsets.bottom,
                            child: SingleChildScrollView(
                              physics: const AlwaysScrollableScrollPhysics(),
                              controller: pageScrollController,
                              child: Column(
                                children: [
                                  ...(state is QRMenuLoaded
                                          ? state.menu.categories
                                          : (state as QRMenuNextLoading)
                                              .menu
                                              .items
                                              .keys)
                                      .map(
                                    (category) {
                                      if (selectedCategory != null &&
                                          category != selectedCategory) {
                                        return const SizedBox();
                                      }
                                      return CategoryWidget(
                                        category: category,
                                        items: (state is QRMenuLoaded
                                                ? state.menu.items
                                                : (state as QRMenuNextLoading)
                                                    .menu
                                                    .items)[category] ??
                                            [],
                                        isSelected: selectedCategory != null,
                                        selector: callBack,
                                      );
                                    },
                                  ),
                                  if (state is QRMenuLoaded &&
                                      (state.menu.categories.isEmpty ||
                                          (state.menu.items[selectedCategory]
                                                  ?.isEmpty ??
                                              false)))
                                    const ErrorAndInfoDisplayWidget(
                                      assetImage: 'assets/icons/no_content.svg',
                                      title: "No item found",
                                      description: "Change applied filterings",
                                    ),
                                  if (state is QRMenuNextLoading &&
                                      selectedCategory == null)
                                    Shimmer.fromColors(
                                      baseColor: AppColors.shimmerBaseColor,
                                      highlightColor:
                                          AppColors.shimmerHighlightColor,
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: SingleChildScrollView(
                                          scrollDirection: Axis.horizontal,
                                          child: Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceEvenly,
                                            children: List.generate(
                                              4,
                                              (index) => Container(
                                                margin: EdgeInsets.symmetric(
                                                    horizontal: 3.w),
                                                height: 20.h,
                                                width: 40.w,
                                                decoration: BoxDecoration(
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          10.0),
                                                  color: Colors.white,
                                                ),
                                              ),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  SizedBox(height: 10.h),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),
                    );
                  } else if (state is QRMenuLoading || state is QRMenuInitial) {
                    return SizedBox(
                      height: 80.h,
                      width: 100.w,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          LoadingAnimationWidget.dotsTriangle(
                              color: AppColors.primaryColor, size: 30.sp),
                          const Text("Loading menu")
                        ],
                      ),
                    );
                  } else if (state is QRMenuFailed) {
                    return ErrorAndInfoDisplayWidget(
                      assetImage: 'assets/icons/no_internet.svg',
                      title: "Server failure",
                      description: "Failed to get data from server",
                      onPressed: () {
                        context.read<QRMenuBloc>().add(GetQRMenu(
                            restaurantId: widget.restaurantId,
                            page: 1,
                            isFasting: isFasting,
                            category: selectedCategory,
                            query: searchController.text,
                            sortBy: sortBy,
                            sortType: sortType,
                            maxPrice: maxPrice,
                            minPrice: minPrice,
                            minRating: minRating));
                      },
                    );
                  } else {
                    return ErrorAndInfoDisplayWidget(
                        assetImage: 'assets/icons/no_internet.svg',
                        title: "Unknown error",
                        description: "Failed to get data from server",
                        onPressed: () {
                          context.read<QRMenuBloc>().add(GetQRMenu(
                              restaurantId: widget.restaurantId,
                              page: 1,
                              isFasting: isFasting,
                              category: selectedCategory,
                              query: searchController.text,
                              sortBy: sortBy,
                              sortType: sortType,
                              maxPrice: maxPrice,
                              minPrice: minPrice,
                              minRating: minRating));
                        });
                  }
                }),
              ),
            ],
          ),
        ),
        bottomNavigationBar: BlocBuilder<QRMenuBloc, QRMenuState>(
          builder: (context, state) {
            if (state is QRMenuLoaded || state is QRMenuNextLoading) {
              var menu = state is QRMenuLoaded
                  ? state.menu
                  : (state as QRMenuNextLoading).menu;
              bool isOpen;
              if (menu.restaurant?.closingHour != null &&
                  menu.restaurant?.openingHour != null) {
                var now = DateTime.now();
                var closingHour = menu.restaurant!.closingHour!.split(":");
                var openingHour = menu.restaurant!.openingHour!.split(":");
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
              if ((menu.restaurant?.restaurantOrderServiceAvailable ?? false) &&
                  // (menu.restaurant?.restaurantOrderServiceOnline ?? false) &&
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
                        if (dpLocator<AuthenticationLocalSource>()
                                .getUserCredential() ==
                            null) {
                          _showLoginDialog(
                            context,
                            restaurant: menu.restaurant,
                          );
                          return;
                        }

                        context.pushNamed(
                          AppRoutes.qrOrderPage,
                          pathParameters: {
                            "restaurantId": menu.restaurant?.id ?? "",
                          },
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
    );
  }

  void showFilterBottomSheet() {
    showModalBottomSheet(
        context: context,
        isScrollControlled: true,
        builder: (context) {
          return QrMenuFilterBottomSheet(
            restaurantId: widget.restaurantId,
            isFasting: isFasting,
            selectedCategory: selectedCategory,
            query: searchController.text,
            sortBy: sortBy,
            sortType: sortType,
            minRating: minRating,
            maxPrice: maxPrice,
            minPrice: minPrice,
          );
        });
  }

  void loadNextPage() {
    final state = context.read<QRMenuBloc>().state;
    if (state is QRMenuLoaded && !state.hasReachedMax) {
      context.read<QRMenuBloc>().add(GetQRMenu(
          restaurantId: widget.restaurantId,
          page: state.page + 1,
          query: searchController.text,
          isFasting: isFasting,
          sortBy: sortBy,
          maxPrice: maxPrice,
          minPrice: minPrice,
          minRating: minRating,
          sortType: sortType));
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
                'routeName': AppRoutes.qrMenuPage,
                'restaurant_id': restaurant?.id ?? "",
                'qr_menu': context.read<QRMenuBloc>().state is QRMenuLoaded
                    ? (context.read<QRMenuBloc>().state as QRMenuLoaded).menu
                    : null,
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
