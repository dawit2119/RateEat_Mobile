import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import '../../domain/entities/item.dart';

class RecommendedItems extends StatelessWidget {
  final List<Item>? recommendations;
  const RecommendedItems({super.key, required this.recommendations});

  mapRecommendedItems() {
    if (recommendations != null) {
      return recommendations!.map(
        (item) => RecommendedItemCard(
          item: item,
        ),
      );
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        ...mapRecommendedItems(),
      ],
    );
  }
}
