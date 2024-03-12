import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/constants/constants.dart';
import '../../domain/entities/restaurant_category.dart';
import '../bloc/restaurant_menu/restaurant_menu_bloc.dart';

class Categories extends StatefulWidget {
  const Categories({
    super.key,
    required this.categories,
    required this.restaurantId,
  });
  final List<RestaurantCategory> categories;
  final String restaurantId;

  @override
  State<Categories> createState() => _CategoriesState();
}

class _CategoriesState extends State<Categories>
    with SingleTickerProviderStateMixin {
  TabController? controller;

  @override
  void initState() {
    controller = TabController(
      length: widget.categories.length,
      vsync: this,
    );
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      color: Colors.white,
      padding: const EdgeInsets.only(right: 10, bottom: 10),
      child: Theme(
        data: ThemeData(
          tabBarTheme: TabBarThemeData(
            tabAlignment: TabAlignment.start,
            labelPadding: const EdgeInsets.only(left: 14.0, right: 4.0),
            overlayColor: WidgetStateProperty.all(
              Colors.transparent,
            ), // Removes the ripple effect
            unselectedLabelColor: Colors.grey,
            labelStyle: const TextStyle(decoration: TextDecoration.none),
            unselectedLabelStyle:
                const TextStyle(decoration: TextDecoration.none),
          ),
        ),
        child: TabBar(
          onTap: (index) {
            context.read<RestaurantMenuBloc>().add(
                  GetRestaurantMenuCategoryItems(
                      restaurantId: widget.restaurantId,
                      categoryId: widget.categories[index].id,
                      page: 1,
                      limit: 10,
                      query: context.read<RestaurantMenuBloc>().state
                              is RestaurantMenuCategoryItemsFetched
                          ? (context.read<RestaurantMenuBloc>().state
                                  as RestaurantMenuCategoryItemsFetched)
                              .query
                          : ""),
                );
          },
          isScrollable: true,
          controller: controller,
          dividerColor: Colors.transparent,
          indicatorSize: TabBarIndicatorSize.label,
          indicatorColor: Colors.transparent,
          labelStyle: TextStyle(
            fontSize: 17.sp,
            fontWeight: FontWeight.w600,
            color: AppColors.grey700,
          ),
          unselectedLabelColor: Colors.grey,
          unselectedLabelStyle:
              const TextStyle(decoration: TextDecoration.none),
          tabs: widget.categories.asMap().entries.map((entry) {
            var index = entry.key;
            var category = entry.value;
            return _customTab(
              index,
              category.name,
            );
          }).toList(),
        ),
      ),
    );
  }

  Widget _customTab(int index, String label) {
    return ValueListenableBuilder(
        valueListenable: controller!.animation!,
        builder: (_, __, ___) {
          bool isSelected = controller!.index == index;
          return Chips(
            isSelected: isSelected,
            label: label,
          );
        });
  }
}
