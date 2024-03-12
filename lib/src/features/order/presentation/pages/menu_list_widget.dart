import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/error_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../homepage/domain/entities/item.dart';
import '../../../restaurant_menu/presentation/bloc/restaurant_category/restaurant_category_bloc.dart';
import '../../../restaurant_menu/presentation/bloc/restaurant_menu/restaurant_menu_bloc.dart';
import '../../../restaurant_menu/domain/entities/menu.dart' as m;
import '../widgets/category_items.dart';

class MenuListWidget extends StatefulWidget {
  const MenuListWidget({
    super.key,
    required this.menu,
    required this.restaurant,
  });
  final m.Menu menu;
  final Restaurant restaurant;
  @override
  State<MenuListWidget> createState() => MenuListWidgetState();
}

class MenuListWidgetState extends State<MenuListWidget> {
  final searchController = TextEditingController();
  List<Item> allItems = [];
  List<Item> filteredItems = [];
  @override
  void initState() {
    super.initState();

    aggregateItems();
  }

  void aggregateItems() {
    allItems.clear();
    for (var item in widget.menu.items) {
      allItems.add(item);
    }
    filteredItems = List.from(allItems); // Initially, display all items
  }

  void searchItem(String query) {
    if (query.isEmpty) {
      filteredItems = List.from(allItems);
    } else {
      filteredItems = allItems
          .where((item) =>
              item.itemName.toLowerCase().contains(query.toLowerCase()))
          .toList();
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<RestaurantCategoryBloc, RestaurantCategoryState>(
      builder: (context, state) {
        if (state is RestaurantCategoriesLoaded) {
          return Column(
            children: [
              Container(
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: CustomTextInputField(
                  hintText: AppLocalizations.of(context)!.searchItemText,
                  canRequestFocus: true,
                  controller: searchController,
                  onCancelled: () {},
                  onChanged: (query) => searchItem(query),
                ),
              ),
              searchController.text.isNotEmpty
                  ? Expanded(
                      child: filteredItems.isEmpty
                          ? ErrorAndInfoDisplayWidget(
                              key: const Key("AddCandidateItemButton"),
                              assetImage: 'assets/icons/no_content.svg',
                              title: AppLocalizations.of(context)!.noResultText,
                              description: "",
                              onPressed: null,
                            )
                          : Expanded(
                              child: OrderItems(
                                restaurantItems: filteredItems,
                                restaurant: widget.restaurant,
                              ),
                            ),
                    )
                  : Expanded(
                      child:
                          BlocBuilder<RestaurantMenuBloc, RestaurantMenuState>(
                        builder: (context, state) {
                          if (state is RestaurantMenuCategoryItemsFetching) {
                            return Center(
                              child: LoadingAnimationWidget.dotsTriangle(
                                color: AppColors.primaryColor,
                                size: 4.h,
                              ),
                            );
                          }
                          if (state is RestaurantMenuCategoryItemsNextLoading) {
                            return Column(
                              children: [
                                OrderItems(
                                  restaurant: widget.restaurant,
                                  restaurantItems: state.menu.items,
                                ),
                                SizedBox(height: 2.h),
                                Center(
                                  child: LoadingAnimationWidget.dotsTriangle(
                                    color: AppColors.primaryColor,
                                    size: 4.h,
                                  ),
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            );
                          }
                          if (state is RestaurantMenuCategoryItemsFetched) {
                            return Column(
                              children: [
                                OrderItems(
                                  restaurant: widget.restaurant,
                                  restaurantItems: state.menu.items,
                                ),
                                SizedBox(
                                  height: 10.h,
                                ),
                              ],
                            );
                          }
                          return Text(
                            state.toString(),
                          );
                        },
                      ),
                    )
            ],
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
                    restaurantId: widget.restaurant.id!));
          },
        );
      },
    );
  }
}

class KeepAliveWrapper extends StatefulWidget {
  final Widget child;

  const KeepAliveWrapper({super.key, required this.child});

  @override
  KeepAliveWrapperState createState() => KeepAliveWrapperState();
}

class KeepAliveWrapperState extends State<KeepAliveWrapper>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return widget.child;
  }

  @override
  bool get wantKeepAlive => true;
}
