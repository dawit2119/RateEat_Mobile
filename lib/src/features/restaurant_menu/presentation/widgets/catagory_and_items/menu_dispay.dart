import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/category.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/catagory_and_items/category_items.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/catagory_and_items/category_list.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/catagory_and_items/restaurant_search_result.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class MenuCategory extends StatefulWidget {
  final List<CategoryEntity> items;

  const MenuCategory({super.key, required this.items});
  @override
  State<MenuCategory> createState() => _MenuCategoryState();
}

class _MenuCategoryState extends State<MenuCategory> {
  final _scrollController = ScrollController();
  final searchController = TextEditingController();
  final double itemCardHeight = 13.h;
  List<ItemModel> allItems = [];
  List<ItemModel> filteredItems = [];
  List<double> breakpoints = [];
  int selectedIndex = 0;

  @override
  void initState() {
    aggregateItems();
    createBreakpoints();
    super.initState();
    _scrollController.addListener(() {
      updateCategoryIndexOnScroll(_scrollController.offset);
    });
  }

  void createBreakpoints() {
    double firstBreakPoint =
        (widget.items[0].items.length * itemCardHeight) + 2.h;
    breakpoints.add(firstBreakPoint);
    for (int i = 1; i < widget.items.length; i++) {
      double br = breakpoints.last +
          (widget.items[i].items.length * itemCardHeight) +
          2.h;
      breakpoints.add(br);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(horizontal: 4.w, vertical: 1.5.h),
      child: Column(
        children: [
          //* Search Area
          Container(
            color: Colors.white,
            padding: EdgeInsets.symmetric(horizontal: 2.w),
            margin: EdgeInsets.only(
              bottom: 2.h,
            ),
            child: CustomTextInputField(
              hintText: "Search item...",
              canRequestFocus: true,
              controller: searchController,
              onChanged: (query) => searchItem(query),
            ),
          ),
          if (searchController.text.isNotEmpty)
            SingleChildScrollView(
              child: RestaurantSearchResult(
                items: filteredItems,
              ),
            ),
          if (searchController.text.isNotEmpty && filteredItems.isEmpty)
            Container(
              margin: EdgeInsets.all(2.h),
              child: Column(
                children: [
                  Text(
                    "No matching Result found",
                    style: GoogleFonts.poppins(
                      fontSize: 1.8.h,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                  CustomTextButton(
                    title: "Add item",
                    ontap: () {},
                  ),
                ],
              ),
            ),
          //* List of Categories
          if (searchController.text.isEmpty)
            RestaurantMenuCategories(
              items: widget.items,
              onChanged: scrollToMenu,
              selectedIndex: selectedIndex,
            ),
          SizedBox(height: 1.h),
          //* List of Items
          if (searchController.text.isEmpty)
            Expanded(
              child: SingleChildScrollView(
                controller: _scrollController,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    ...mapCategories(),
                  ],
                ),
              ),
            ),
        ],
      ),
    );
  }

  mapCategories() {
    if (widget.items.isNotEmpty) {
      return widget.items.map(
        (item) => RestaurantCategoryItem(category: item),
      );
    }
    return [];
  }

  void scrollToMenu(int index) {
    if (selectedIndex != index) {
      int totalItems = 0;
      for (int i = 0; i < index; i++) {
        totalItems += widget.items[i].items.length;
      }
      _scrollController.animateTo(
        (totalItems * itemCardHeight) + (index * 2.h),
        duration: const Duration(microseconds: 500),
        curve: Curves.ease,
      );
      setState(() {
        selectedIndex = index;
      });
    }
  }

  void updateCategoryIndexOnScroll(double offset) {
    for (int i = 0; i < widget.items.length; i++) {
      if (i == 0) {
        if ((offset < breakpoints.first) && (selectedIndex != 0)) {
          setState(() {
            selectedIndex = 0;
          });
        }
      } else if ((breakpoints[i - 1] <= offset) && (offset < breakpoints[i])) {
        setState(() {
          selectedIndex = i;
        });
      }
    }
  }

  //* All Items Search
  void aggregateItems() {
    allItems.clear();
    for (var category in widget.items) {
      allItems.addAll(category.items);
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
  void dispose() {
    super.dispose();
    _scrollController.dispose();
  }
}
