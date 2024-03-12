import 'package:flutter/material.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import '../../../../homepage/domain/entities/item.dart';

class RelatedItemsWidget extends StatelessWidget {
  final List<Item>? recommendations;
  const RelatedItemsWidget({super.key, required this.recommendations});

  mapRecommendedItems() {
    if (recommendations != null) {
      return recommendations!.map((item) => Padding(
            padding: const EdgeInsets.only(right: 12),
            child: FoodCard(
              item: item,
            ),
          ));
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          AppLocalizations.of(context)!.similarDishes,
          style: TextStyle(
              fontSize: screenHeight * 0.018,
              fontWeight: FontWeight.bold,
              color: const Color(0xFF586069)),
        ),
        SizedBox(
          height: screenHeight * 0.015,
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              ...mapRecommendedItems(),
            ],
          ),
        ),
      ],
    );
  }
}
