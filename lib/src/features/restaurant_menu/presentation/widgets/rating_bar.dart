import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';

class CustomRatingBar extends StatelessWidget {
  const CustomRatingBar({
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
      itemSize: 15,
      unratedColor: const Color(0xFFDAD9D9),
      itemPadding: const EdgeInsets.only(left: 5),
      itemBuilder: (context, _) => const Icon(
        Icons.star_rounded,
        color: Color(0xFFFF3008),
      ),
    );
  }
}
