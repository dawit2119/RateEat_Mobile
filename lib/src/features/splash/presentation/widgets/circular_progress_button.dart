import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/constants/constants.dart';

class CircularProgressButton extends StatelessWidget {
  final int currentPage;
  final int totalPages;
  final VoidCallback onPress;

  const CircularProgressButton({
    super.key,
    required this.currentPage,
    required this.totalPages,
    required this.onPress,
  });

  @override
  Widget build(BuildContext context) {
    double progress = (currentPage + 1) / totalPages;

    return GestureDetector(
      onTap: onPress,
      child: Stack(
        alignment: Alignment.center,
        children: [
          SizedBox(
            height: 8.h,
            width: 8.h,
            child: TweenAnimationBuilder<double>(
                duration: const Duration(milliseconds: 200),
                tween: Tween<double>(begin: 0, end: progress),
                builder: (context, value, child) {
                  return CircularProgressIndicator(
                    strokeCap: StrokeCap.round,
                    strokeWidth: .8.h,
                    value: value,
                    backgroundColor: const Color.fromARGB(255, 240, 241, 243),
                    valueColor: const AlwaysStoppedAnimation<Color>(
                        AppColors.secondaryColor),
                  );
                }),
          ),
          SvgPicture.asset(
            "assets/icons/arrow_right_solid.svg",
            height: 28,
            width: 28,
          ),
        ],
      ),
    );
  }
}
