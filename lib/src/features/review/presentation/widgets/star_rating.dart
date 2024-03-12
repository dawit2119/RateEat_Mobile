import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';

class StarRatingInput extends StatelessWidget {
  final ValueChanged<double> onRatingChanged;
  final double? rating;
  final String? title;
  final String? description;
  const StarRatingInput({
    super.key,
    required this.onRatingChanged,
    this.rating,
    this.title,
    this.description,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        //* Give Rating Title
        Text(
          title ?? AppLocalizations.of(context)!.giveRateText,
          style: medium16,
        ),
        verticalPadding(height: .8),
        if (description != null)
          Text(
            description!,
            style: regular16.copyWith(color: AppColors.grey600),
          ),
        verticalPadding(height: 1.2),
        //* Rating Selector
        RatingBar.builder(
          initialRating: rating ?? 4,
          minRating: 1,
          glow: false,
          glowColor: AppColors.grey100,
          glowRadius: 0.1,
          direction: Axis.horizontal,
          onRatingUpdate: onRatingChanged,
          allowHalfRating: false,
          itemCount: 5,
          unratedColor: AppColors.grey200,
          itemPadding: EdgeInsets.zero,
          itemBuilder: (context, _) => const Icon(
            Iconsax.star1,
            color: AppColors.primaryColor,
          ),
        ),
      ],
    );
  }
}
