import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ReviewTypeDialogContent extends StatelessWidget {
  const ReviewTypeDialogContent({super.key, required this.mediaFiles});

  final List<SharedMediaFile> mediaFiles;

  @override
  Widget build(BuildContext context) {
    return Dialog(
      insetPadding: const EdgeInsets.all(10),
      alignment: Alignment.bottomCenter,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Container(
        width: double.infinity,
        height: 28.h,
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 10),
          child: Column(
            children: [
              Row(
                children: [
                  Text(
                    "Select review type",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w700,
                      fontSize: 18,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: const Icon(Iconsax.close_circle),
                    onPressed: () {
                      Navigator.pop(context);
                    },
                  ),
                ],
              ),
              const Spacer(),
              ReviewTypeTile(
                title: "Restaurant review",
                icon: Iconsax.shop,
                onTap: () {
                  context.pushNamed(
                    AppRoutes.searchRestaurant,
                    extra: {
                      'isRestaurantReview': true,
                    },
                  );
                },
              ),
              verticalPadding(height: 1),
              ReviewTypeTile(
                title: "Food review",
                icon: Iconsax.menu,
                onTap: () {
                  context.pushNamed(
                    AppRoutes.searchRestaurant,
                    extra: {
                      'isRestaurantReview': false,
                    },
                  );
                },
              ),
              const Spacer(flex: 2),
            ],
          ),
        ),
      ),
    );
  }
}

class ReviewTypeTile extends StatelessWidget {
  const ReviewTypeTile({
    super.key,
    required this.title,
    required this.onTap,
    required this.icon,
  });

  final String title;
  final GestureTapCallback onTap;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        decoration: BoxDecoration(
          color: AppColors.grey100,
          borderRadius: BorderRadius.circular(12),
        ),
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 16, horizontal: 12),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Icon(icon, size: 24, color: AppColors.grey600),
              horizontalPadding(width: 2),
              Text(
                title,
                style: GoogleFonts.plusJakartaSans(
                  fontWeight: FontWeight.w500,
                  fontSize: 16,
                ),
              )
            ],
          ),
        ),
      ),
    );
  }
}
