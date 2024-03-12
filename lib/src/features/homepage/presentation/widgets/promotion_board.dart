import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/features/features.dart';

class PromotionBoard extends StatelessWidget {
  final List<Promotion>? promotions;
  const PromotionBoard({super.key, this.promotions});

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          PromotionBoardCard(
            imageUrl:
                'https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJ1cmdlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80',
          ),
          PromotionBoardCard(
            imageUrl:
                'https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJ1cmdlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80',
          ),
        ],
      ),
    );
  }
}
