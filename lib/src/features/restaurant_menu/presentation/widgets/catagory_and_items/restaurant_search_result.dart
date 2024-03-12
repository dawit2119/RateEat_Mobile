import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/catagory_and_items/item_card.dart';

class RestaurantSearchResult extends StatelessWidget {
  final List<ItemModel> items;

  const RestaurantSearchResult({
    super.key,
    required this.items,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* List of Items
        ...mapListItems(),
      ],
    );
  }

  mapListItems() {
    if (items.isNotEmpty) {
      return items.map(
        (item) => CategoryItemCard(
          item: item,
          currencyCode: "", //TODO we need to get
        ),
      );
    }
    return [];
  }
}
