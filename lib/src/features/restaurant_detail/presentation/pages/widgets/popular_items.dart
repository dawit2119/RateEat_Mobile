import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/pages/widgets/popular_item_card.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/domain/entities/entities.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/bloc/restaurant_menu/restaurant_menu_bloc.dart';

import '../../../../map_section/domain/entities/restaurant.dart';
import '../../../../restaurant_menu/presentation/bloc/restaurant_category/restaurant_category_bloc.dart';

class PopularItemsPage extends StatelessWidget {
  final List<RestaurantMenuItem> restaurantItems;
  final Restaurant restaurant;
  const PopularItemsPage({
    super.key,
    required this.restaurantItems,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return ListView(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      children: [
        GridView.builder(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            crossAxisCount: 2,
            childAspectRatio: 0.78,
          ),
          itemBuilder: (BuildContext context, int index) {
            var item = restaurantItems[index];
            return PopularItem(
              item: item,
              restaurant: restaurant,
            );
          },
          itemCount: restaurantItems.length,
        ),
        const SizedBox(
          height: 10,
        ),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Container(),
            SingleChip(
              selected: true,
              title: AppLocalizations.of(context)!.seeMenu,
              onTap: () {
                context.read<RestaurantCategoryBloc>().add(
                      GetRestaurantCategoriesEvent(
                        restaurantId: restaurant.id!,
                      ),
                    );
                context.read<RestaurantMenuBloc>().add(
                      GetRestaurantMenuCategoryItems(
                        restaurantId: restaurant.id!,
                        categoryId: "",
                        page: 1,
                        limit: 10,
                      ),
                    );
                context.pushNamed(
                  AppRoutes.restaurantMenu,
                  pathParameters: {
                    "restaurantId": restaurant.id!,
                  },
                  extra: restaurant,
                );
              },
            ),
          ],
        ),
      ],
    );
  }
}
