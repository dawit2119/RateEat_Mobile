import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class OrderItemRatingBar extends StatelessWidget {
  const OrderItemRatingBar({
    super.key,
    required this.rating,
  });
  final double rating;
  @override
  Widget build(BuildContext context) {
    return RatingBar.builder(
      initialRating: rating,
      ignoreGestures: true,
      minRating: 1,
      glowColor: const Color(0xFFB5BABE),
      glowRadius: 0.1,
      direction: Axis.horizontal,
      onRatingUpdate: (rating) {},
      allowHalfRating: true,
      itemCount: 5,
      itemSize: 18,
      unratedColor: const Color(0xFFDAD9D9),
      itemBuilder: (context, _) => const Icon(
        Icons.star_rounded,
        color: Color(0xFFFF3008),
      ),
    );
  }
}
