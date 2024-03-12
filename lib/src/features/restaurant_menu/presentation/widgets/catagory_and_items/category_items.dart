import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/category.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/catagory_and_items/item_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RestaurantCategoryItem extends StatelessWidget {
  final CategoryEntity category;

  const RestaurantCategoryItem({
    super.key,
    required this.category,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Title Text form category
        Text(
          category.name ?? "",
          style: GoogleFonts.poppins(
            fontSize: 2.h,
            fontWeight: FontWeight.w500,
          ),
        ),
        //* List of Items
        ...mapListItems(),
      ],
    );
  }

  mapListItems() {
    if (category.items.isNotEmpty) {
      return category.items.map(
        (item) => CategoryItemCard(
          item: item,
          currencyCode: "", //TODO we need currency for items too
        ),
      );
    }
    return [];
  }
}
