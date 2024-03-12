import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';
import 'package:rateeat_mobile/src/features/order/presentation/bloc/total_price/total_price_bloc.dart';
import 'package:rateeat_mobile/src/features/order/presentation/widgets/widgets.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/bloc/restaurant_menu/restaurant_menu_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/error_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import '../../../features.dart';
import '../../../homepage/domain/entities/item.dart';
import '../../../item_category/presentation/widgets/tag_shimmer.dart';
import '../../../restaurant_menu/data/models/restaurant_category.dart';
import '../../../restaurant_menu/presentation/bloc/restaurant_category/restaurant_category_bloc.dart';
import '../../../restaurant_menu/presentation/widgets/categories.dart';

class SelectOrdersPage extends StatefulWidget {
  final Restaurant restaurant;
  const SelectOrdersPage({
    super.key,
    required this.restaurant,
  });

  @override
  State<SelectOrdersPage> createState() => _SelectOrdersPageState();
}

class _SelectOrdersPageState extends State<SelectOrdersPage> {
  bool toggle = false;

  @override
  void initState() {
    context.read<CartCubit>().resetCart();
    context.read<OrderSocketStatusBloc>().add(OrderConnectSocket());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
        onTap: () {
          context.pop();
        },
        title: widget.restaurant.name!,
      ),
      body: buildRestaurantInfo(context),
      bottomSheet: BlocBuilder<CartCubit, Map<Item, int>>(
        builder: (context, state) {
          return GestureDetector(
            onTap: (state.isEmpty || toggle)
                ? () {}
                : () {
                    setState(() {
                      toggle = !toggle;
                    });
                  },
            child: Container(
              width: 100.w,
              padding: EdgeInsets.symmetric(
                vertical: 1.h,
                horizontal: 5.w,
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
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (state.isNotEmpty)
                    Flexible(child: displayPreviewItems(state)),
                  SizedBox(height: 1.2.h),
                  InkWell(
                    onTap: () {
                      if (state.isNotEmpty) {
                        context.read<TotalPriceBloc>().add(
                              GetOrderTotalPriceEvent(
                                cart: state,
                              ),
                            );
                        context.pushNamed(
                          AppRoutes.cartPage,
                          extra: widget.restaurant,
                        );
                      }
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        vertical: 16,
                        horizontal: 24,
                      ),
                      decoration: BoxDecoration(
                        color: (state.isEmpty)
                            ? AppColors.grey400
                            : AppColors.primaryColor,
                        borderRadius: BorderRadius.circular(20),
                        boxShadow: [
                          BoxShadow(
                            color: (state.isEmpty)
                                ? AppColors.grey400
                                : AppColors.primaryColor.withOpacity(0.7),
                            blurRadius: 5,
                            spreadRadius: 1,
                          ),
                        ],
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Row(
                            children: [
                              Icon(
                                Iconsax.reserve5,
                                color: Colors.white,
                                size: 18.sp,
                              ),
                              SizedBox(
                                width: 2.w,
                              ),
                              Text(
                                "${cartCubit.getTotalItemCount()} Items",
                                style: GoogleFonts.plusJakartaSans(
                                  fontWeight: FontWeight.w600,
                                  fontSize: 18.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          Text(
                            "${cartCubit.calculateTotalPrice()} ${widget.restaurant.currencyCode}",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 18.sp,
                              color: Colors.white,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget displayPreviewItems(selectedItems) {
    return toggle
        ? Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              //* Title and lose button
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Text(
                    "Order items",
                    style: GoogleFonts.poppins(
                      fontSize: 17.sp,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  GestureDetector(
                    onTap: () {
                      setState(() {
                        toggle = !toggle;
                      });
                    },
                    child: Container(
                      padding: EdgeInsets.all(7.sp),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(50),
                      ),
                      child: Icon(
                        Iconsax.arrow_down_1,
                        color: AppColors.textDark,
                        size: 21.sp,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 1.4.h,
              ),
              Flexible(
                child: ListView(
                  shrinkWrap: true,
                  children: [
                    ...selectedItems.keys.map(
                      (item) => SelectedOrderItemPreview(
                        item: item,
                        restaurant: widget.restaurant,
                        currencyCode: widget.restaurant.currencyCode,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.5.h,
              ),
            ],
          )
        : Padding(
            padding: EdgeInsets.symmetric(horizontal: 1.w),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Flexible(
                  child: StackedImagesDisplayWidget(
                    imageURLs: selectedItems.keys
                        .map((item) => item.imageUrl!)
                        .toList(),
                    videos: const [],
                  ),
                ),
                Container(
                  padding: EdgeInsets.all(7.sp),
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(50),
                  ),
                  child: Icon(
                    Iconsax.arrow_up_2,
                    color: AppColors.textDark,
                    size: 21.sp,
                  ),
                ),
              ],
            ),
          );
  }

  Widget buildRestaurantInfo(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 1.h),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocListener<RestaurantMenuBloc, RestaurantMenuState>(
            listenWhen: (previous, state) {
              return previous is RestaurantMenuCategoryItemsFetching &&
                  state is RestaurantMenuCategoryItemsFetched;
            },
            listener: (context, state) {
              if (state is RestaurantMenuCategoryItemsFetched &&
                  state.page == 1) {
                showCustomToast(
                    context: context,
                    toastMessage:
                        "${state.menu.totalItemsCount} items available",
                    toastType: ToastType.info);
              }
            },
            child: BlocBuilder<RestaurantCategoryBloc, RestaurantCategoryState>(
              builder: (context, state) {
                if (state is RestaurantCategoriesLoading) {
                  return SingleChildScrollView(
                    key: const Key("restaurant_menu_categories_loading"),
                    scrollDirection: Axis.horizontal,
                    child: Wrap(
                      direction: Axis.horizontal,
                      spacing: 2.0,
                      runSpacing: 2.0,
                      children: List.generate(
                        7,
                        (index) => const TagShimmer(),
                      ),
                    ),
                  );
                }
                if (state is RestaurantCategoriesLoaded) {
                  final categories = [
                    const RestaurantMenuCategoryModel(
                      id: "",
                      name: "All",
                      menuId: "",
                      isApproved: true,
                    ),
                    ...state.categories,
                  ];

                  return Categories(
                    categories: categories,
                    restaurantId: widget.restaurant.id!,
                  );
                }
                return Container();
              },
            ),
          ),
          BlocBuilder<RestaurantMenuBloc, RestaurantMenuState>(
            builder: (context, state) {
              if (state is RestaurantMenuCategoryItemsFetching) {
                return Expanded(
                  child: Container(
                    alignment: Alignment.center,
                    margin: EdgeInsets.all(
                      2.h,
                    ),
                    child: LoadingAnimationWidget.dotsTriangle(
                      color: AppColors.primaryColor,
                      size: 4.h,
                    ),
                  ),
                );
              } else if (state is RestaurantMenuCategoryItemsFetchingFailed) {
                return Expanded(
                  child: RestaurantMenuErrorWidget(
                    message: state.message,
                    restaurantId: widget.restaurant.id!,
                    refreshButtonOnPressed: () {
                      context.read<RestaurantMenuBloc>().add(
                            GetRestaurantMenuCategoryItems(
                              restaurantId: widget.restaurant.id!,
                              categoryId: '',
                              page: 1,
                              limit: 10,
                            ),
                          );
                      context.read<RestaurantCategoryBloc>().add(
                          GetRestaurantCategoriesEvent(
                              restaurantId: widget.restaurant.id!));
                    },
                  ),
                );
              } else if (state is RestaurantMenuCategoryItemsFetched) {
                return Expanded(
                  child: MenuListWidget(
                    restaurant: widget.restaurant,
                    menu: state.menu,
                  ),
                );
              } else if (state is RestaurantMenuCategoryItemsNextLoading) {
                return Expanded(
                  child: MenuListWidget(
                    restaurant: widget.restaurant,
                    menu: state.menu,
                  ),
                );
              }
              return RestaurantMenuErrorWidget(
                message: AppLocalizations.of(context)!.unknownErrorText,
                restaurantId: widget.restaurant.id!,
                refreshButtonOnPressed: () {
                  context.read<RestaurantMenuBloc>().add(
                        GetRestaurantMenuCategoryItems(
                          restaurantId: widget.restaurant.id!,
                          categoryId: '',
                          page: 1,
                          limit: 10,
                        ),
                      );
                  context.read<RestaurantCategoryBloc>().add(
                        GetRestaurantCategoriesEvent(
                          restaurantId: widget.restaurant.id!,
                        ),
                      );
                },
              );
            },
          ),
        ],
      ),
    );
  }
}

//Item with their count
class CartCubit extends Cubit<Map<Item, int>> {
  CartCubit() : super({});

  void removeFromCart(Item item) {
    final newState =
        Map<Item, int>.from(state); // Create a new copy of the state
    if (newState.containsKey(item)) {
      if (newState[item]! > 1) {
        newState[item] = newState[item]! - 1;
      } else {
        newState.remove(item)!;
      }
      emit(newState); // Emit the new state
    }
  }

  void addToCart(Item item) {
    final newState =
        Map<Item, int>.from(state); // Create a new copy of the state
    newState[item] = newState.containsKey(item) ? newState[item]! + 1 : 1;
    emit(newState);
  }

  double calculateTotalPrice() {
    if (state.isEmpty) return 0.0;
    return state.entries
        .map((entry) => (entry.key.price ?? 0) * entry.value)
        .reduce(
          (value, element) => value + element,
        );
  }

  bool isItemInCart(Item item) {
    return state.containsKey(item);
  }

  int getTotalItemCount() {
    return state.values.fold(0, (sum, count) => sum + count);
  }

  int getItemCount(Item item) {
    return state[item] ?? 0;
  }

  void resetCart() {
    final newState = Map<Item, int>.from(state);
    newState.clear();
    emit(newState);
  }
}
