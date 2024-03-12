import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/category.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RestaurantMenuCategories extends StatefulWidget {
  final List<CategoryEntity> items;
  final ValueChanged<int> onChanged;
  final int selectedIndex;

  const RestaurantMenuCategories(
      {super.key,
      required this.onChanged,
      required this.selectedIndex,
      required this.items});

  @override
  State<RestaurantMenuCategories> createState() =>
      _RestaurantMenuCategoriesState();
}

class _RestaurantMenuCategoriesState extends State<RestaurantMenuCategories> {
  late ScrollController _controller;
  @override
  void initState() {
    super.initState();
    _controller = ScrollController();
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      controller: _controller,
      scrollDirection: Axis.horizontal,
      child: Row(
        children: List.generate(
          widget.items.length,
          (index) {
            return Padding(
              padding: EdgeInsets.only(bottom: 1.h, right: 4.w),
              child: InkWell(
                onTap: () {
                  widget.onChanged(index);
                },
                child: Text(
                  widget.items[index].name ?? "",
                  style: GoogleFonts.poppins(
                    color: index == widget.selectedIndex
                        ? Colors.red
                        : Colors.black54,
                    fontSize: 2.2.h, // Adjust the font size as needed
                    fontWeight: index == widget.selectedIndex
                        ? FontWeight.w600
                        : FontWeight.normal,
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }

  @override
  void didUpdateWidget(covariant RestaurantMenuCategories oldWidget) {
    _controller.animateTo(widget.selectedIndex * 10.w,
        duration: const Duration(milliseconds: 300), curve: Curves.ease);
    super.didUpdateWidget(oldWidget);
  }

  @override
  void dispose() {
    super.dispose();
    _controller.dispose();
  }
}
