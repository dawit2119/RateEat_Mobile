import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/error_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../../../features.dart';
import '../../domain/entities/menu.dart' as m;

import '../bloc/restaurant_category/restaurant_category_bloc.dart';
import '../bloc/restaurant_menu/restaurant_menu_bloc.dart';
import '../widgets/candidate_item.dart';
import '../widgets/category_items.dart';

class MenuPage extends StatefulWidget {
  const MenuPage({
    super.key,
    required this.restaurant,
  });
  final Restaurant restaurant;
  @override
  State<MenuPage> createState() => MenuPageState();
}

class MenuPageState extends State<MenuPage> {
  final searchController = TextEditingController();
  String sortBy = "ratingDesc";
  @override
  void initState() {
    super.initState();
  }

  void searchItem(String query, BuildContext context) {
    context.read<RestaurantMenuBloc>().add(GetRestaurantMenuCategoryItems(
        query: query,
        restaurantId: widget.restaurant.id!,
        categoryId: context.read<RestaurantMenuBloc>().state
                is RestaurantMenuCategoryItemsFetched
            ? (context.read<RestaurantMenuBloc>().state
                    as RestaurantMenuCategoryItemsFetched)
                .categoryId
            : "",
        page: 1,
        limit: 10,
        sortBy: sortBy));
  }

  void showAddCandidateItemModalSheet(
      {required BuildContext context,
      required Restaurant restaurant,
      required List<String> categories,
      required m.Menu menu}) {
    showModalBottomSheet(
      clipBehavior: Clip.hardEdge,
      isDismissible: true,
      context: context,
      backgroundColor: Colors.white,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(16),
          topRight: Radius.circular(16),
        ),
      ),
      isScrollControlled: true,
      builder: (BuildContext context) {
        return CandidateItem(
          restaurant: restaurant,
          categories: categories,
          menuId: menu.id,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    final sortingMethods = {
      AppLocalizations.of(context)!.mostPopularText: "number_of_reviewsDesc",
      AppLocalizations.of(context)!.ratedText: "ratingDesc",
      AppLocalizations.of(context)!.priceText: "priceAsc",
      AppLocalizations.of(context)!.itemNameText: "nameAsc"
    };
    return BlocBuilder<RestaurantCategoryBloc, RestaurantCategoryState>(
      builder: (context, state) {
        if (state is RestaurantCategoriesLoaded) {
          return Column(
            children: [
              Container(
                width: 100.w,
                color: Colors.white,
                padding: EdgeInsets.symmetric(horizontal: 4.w),
                margin: const EdgeInsets.symmetric(
                  vertical: 10,
                ),
                child: Row(
                  children: [
                    SizedBox(
                      width: 80.w,
                      child: CustomTextInputField(
                        hintText: AppLocalizations.of(context)!.searchItemText,
                        canRequestFocus: true,
                        controller: searchController,
                        onCancelled: () {},
                        onChanged: (query) => searchItem(query, context),
                      ),
                    ),
                    DropdownButton(
                        selectedItemBuilder: (context) {
                          return sortingMethods.keys.map((name) {
                            return const SizedBox();
                          }).toList();
                        },
                        underline: const SizedBox(),
                        menuWidth: 40.w,
                        style: const TextStyle(color: Colors.black),
                        iconSize: 6.w,
                        isExpanded: false,
                        isDense: true,
                        padding: const EdgeInsets.all(8.0),
                        icon: const Icon(Icons.sort),
                        borderRadius: BorderRadius.circular(6),
                        elevation: 4,
                        dropdownColor: Colors.white,
                        focusColor: AppColors.grey200,
                        items: sortingMethods.keys.map((name) {
                          return DropdownMenuItem(
                              value: sortingMethods[name]!, child: Text(name));
                        }).toList(),
                        onChanged: (val) {
                          context.read<RestaurantMenuBloc>().add(
                              GetRestaurantMenuCategoryItems(
                                  query: searchController.text,
                                  restaurantId: widget.restaurant.id!,
                                  categoryId: context
                                              .read<RestaurantMenuBloc>()
                                              .state
                                          is RestaurantMenuCategoryItemsFetched
                                      ? (context
                                                  .read<RestaurantMenuBloc>()
                                                  .state
                                              as RestaurantMenuCategoryItemsFetched)
                                          .categoryId
                                      : "",
                                  page: 1,
                                  limit: 10,
                                  sortBy: val!));
                          setState(() {
                            sortBy = val;
                          });
                        })
                  ],
                ),
              ),
              BlocBuilder<RestaurantMenuBloc, RestaurantMenuState>(
                  builder: (context, menuState) {
                if (menuState is RestaurantMenuCategoryItemsFetching) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Container(
                        alignment: Alignment.center,
                        margin: EdgeInsets.all(
                          2.h,
                        ),
                        child: LoadingAnimationWidget.dotsTriangle(
                          color: AppColors.primaryColor,
                          size: 4.h,
                        ),
                      ),
                    ],
                  );
                } else if (menuState
                    is RestaurantMenuCategoryItemsFetchingFailed) {
                  return Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      RestaurantMenuErrorWidget(
                        message: menuState.message,
                        restaurantId: widget.restaurant.id!,
                        refreshButtonOnPressed: () {
                          context.read<RestaurantMenuBloc>().add(
                                GetRestaurantMenuCategoryItems(
                                  restaurantId: widget.restaurant.id!,
                                  categoryId: '',
                                  page: 1,
                                  limit: 10,
                                  query: searchController.text,
                                  sortBy: sortBy,
                                ),
                              );
                          context.read<RestaurantCategoryBloc>().add(
                              GetRestaurantCategoriesEvent(
                                  restaurantId: widget.restaurant.id!));
                        },
                      ),
                    ],
                  );
                } else if (menuState is RestaurantMenuCategoryItemsFetched ||
                    menuState is RestaurantMenuCategoryItemsNextLoading) {
                  return Column(
                    children: [
                      searchController.text.isNotEmpty
                          ? (menuState is RestaurantMenuCategoryItemsFetched
                                  ? menuState.menu.items.isEmpty
                                  : (menuState
                                          as RestaurantMenuCategoryItemsNextLoading)
                                      .menu
                                      .items
                                      .isEmpty)
                              ? ErrorAndInfoDisplayWidget(
                                  key: const Key("AddCandidateItemButton"),
                                  assetImage: 'assets/icons/no_content.svg',
                                  title: AppLocalizations.of(context)!
                                      .noResultText,
                                  description: AppLocalizations.of(context)!
                                      .doYouWantToAddCandidateITemText,
                                  buttonText:
                                      AppLocalizations.of(context)!.addItemText,
                                  onPressed: () async {
                                    final user =
                                        dpLocator<AuthenticationLocalSource>()
                                            .getUserCredential();
                                    if (user != null) {
                                      showAddCandidateItemModalSheet(
                                        menu: (menuState
                                                is RestaurantMenuCategoryItemsFetched
                                            ? menuState.menu
                                            : (menuState
                                                    as RestaurantMenuCategoryItemsNextLoading)
                                                .menu),
                                        context: context,
                                        restaurant: widget.restaurant,
                                        categories: state.categories
                                            .map((e) => e.name)
                                            .toList()
                                          ..add("Other"),
                                      );
                                      searchController.clear();
                                      searchItem(
                                          searchController.text, context);
                                    } else {
                                      showCustomToast(
                                        context: context,
                                        toastMessage:
                                            "Login first to add items.",
                                        toastType: ToastType.warning,
                                      );
                                    }
                                  },
                                )
                              : CategoryItems(
                                  restaurantItems: (menuState
                                          is RestaurantMenuCategoryItemsFetched
                                      ? menuState.menu.items
                                      : (menuState
                                              as RestaurantMenuCategoryItemsNextLoading)
                                          .menu
                                          .items),
                                  restaurant: widget.restaurant,
                                  sortBy: sortBy,
                                )
                          : BlocBuilder<RestaurantMenuBloc,
                              RestaurantMenuState>(
                              builder: (context, state) {
                                if (state
                                    is RestaurantMenuCategoryItemsFetching) {
                                  return Center(
                                    child: LoadingAnimationWidget.dotsTriangle(
                                      color: AppColors.primaryColor,
                                      size: 4.h,
                                    ),
                                  );
                                }
                                if (state
                                    is RestaurantMenuCategoryItemsNextLoading) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    child: CategoryItems(
                                      restaurant: widget.restaurant,
                                      restaurantItems: state.menu.items,
                                      sortBy: sortBy,
                                    ),
                                  );
                                }
                                if (state
                                    is RestaurantMenuCategoryItemsFetched) {
                                  return Container(
                                    margin: const EdgeInsets.only(
                                      bottom: 10,
                                    ),
                                    child: CategoryItems(
                                      restaurant: widget.restaurant,
                                      restaurantItems: state.menu.items,
                                      sortBy: sortBy,
                                    ),
                                  );
                                }
                                return Text(
                                  state.toString(),
                                );
                              },
                            ),
                      Text(
                          "Loaded ${menuState is RestaurantMenuCategoryItemsFetched ? (menuState).menu.loadedItemsCount : menuState is RestaurantMenuCategoryItemsNextLoading ? (menuState).menu.loadedItemsCount : 0} of ${menuState is RestaurantMenuCategoryItemsFetched ? (menuState).menu.totalItemsCount : menuState is RestaurantMenuCategoryItemsNextLoading ? (menuState).menu.totalItemsCount : 0} items"),
                    ],
                  );
                }
                return Text(menuState.toString());
              })
            ],
          );
        }
        return Container();
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
