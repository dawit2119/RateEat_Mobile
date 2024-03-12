import 'dart:async';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../homepage/domain/entities/item.dart';
import 'review_bubble_icon.dart';

class ReviewFloatingButton extends StatefulWidget {
  final Item? item;
  final bool isItem;
  final RestaurantModel? restaurant;

  const ReviewFloatingButton({
    super.key,
    required this.isItem,
    this.item,
    this.restaurant,
  });

  @override
  State<ReviewFloatingButton> createState() => _ReviewFloatingButtonState();
}

class _ReviewFloatingButtonState extends State<ReviewFloatingButton> {
  bool _showLabel = false;
  Timer? _hideTimer;

  bool getUser() {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      return user != null;
    } on CacheException {
      return false;
    }
  }

  @override
  void initState() {
    super.initState();
    // Optional: show label briefly the first time
    WidgetsBinding.instance.addPostFrameCallback((_) {
      _revealLabelFor(const Duration(seconds: 2));
    });
  }

  @override
  void dispose() {
    _hideTimer?.cancel();
    super.dispose();
  }

  void _revealLabelFor(Duration duration) {
    _hideTimer?.cancel();
    setState(() => _showLabel = true);
    _hideTimer = Timer(duration, () {
      if (mounted) setState(() => _showLabel = false);
    });
  }

  void _onPressed() {
    if (getUser()) {
      if (widget.isItem) {
        context.pushNamed(
          AppRoutes.addItemReview,
          pathParameters: {'itemId': widget.item!.itemId},
          extra: {"item": widget.item},
        );
      } else {
        context.pushNamed(
          AppRoutes.addRestaurantReview,
          pathParameters: {'restaurantId': widget.restaurant!.id!},
          extra: {"restaurant": widget.restaurant},
        );
      }
      return;
    }

    _showLoginDialog(
      context,
      isItem: widget.isItem,
      item: widget.item,
      restaurant: widget.restaurant,
    );
  }

  @override
  Widget build(BuildContext context) {
    final label = AppLocalizations.of(context)!.addReviewText;

    return Stack(
      clipBehavior: Clip.none,
      alignment: Alignment.bottomRight,
      children: [
        // Animated label chip above the FAB
        Positioned(
          bottom: 72,
          right: 0,
          child: IgnorePointer(
            child: AnimatedOpacity(
              duration: const Duration(milliseconds: 180),
              opacity: _showLabel ? 1 : 0,
              child: AnimatedSlide(
                duration: const Duration(milliseconds: 180),
                offset: _showLabel ? Offset.zero : const Offset(0, 0.2),
                child: Container(
                  padding:
                      EdgeInsets.symmetric(horizontal: 3.w, vertical: 0.9.h),
                  decoration: BoxDecoration(
                    color: Colors.black.withOpacity(0.75),
                    borderRadius: BorderRadius.circular(999),
                  ),
                  child: Text(
                    label,
                    style: GoogleFonts.poppins(
                      fontSize: 13.sp,
                      fontWeight: FontWeight.w600,
                      color: Colors.white,
                      height: 1.0,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ),

        // Circular FAB with Custom Message Icon
        MouseRegion(
          onEnter: (_) => _revealLabelFor(const Duration(seconds: 2)),
          child: GestureDetector(
            onLongPress: () => _revealLabelFor(const Duration(seconds: 2)),
            child: FloatingActionButton(
              heroTag: 'review_fab',
              onPressed: _onPressed,
              backgroundColor: AppColors.primaryButtonColor,
              elevation: 8,
              shape: const CircleBorder(),
              // Here is the custom icon
              child: const ReviewBubbleIcon(
                size: 24,
                color: Colors.white,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

void _showLoginDialog(
  BuildContext context, {
  Item? item,
  required bool isItem,
  RestaurantModel? restaurant,
}) {
  showDialog(
    context: context,
    builder: (BuildContext ctx) {
      return AlertDialog(
        title: Text(AppLocalizations.of(context)!.loginRequiredText),
        content: Text(AppLocalizations.of(context)!.loginNeededText),
        actions: <Widget>[
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text(AppLocalizations.of(context)!.cancelText),
          ),
          TextButton(
            onPressed: () {
              final routeInfo = {
                'routeName': isItem
                    ? AppRoutes.addItemReview
                    : AppRoutes.addRestaurantReview,
                'item': item,
                'restaurant': restaurant,
              };
              Navigator.of(ctx).pop();
              context.pushNamed(AppRoutes.login, extra: routeInfo);
            },
            child: Text(AppLocalizations.of(context)!.loginText),
          ),
        ],
      );
    },
  );
}
