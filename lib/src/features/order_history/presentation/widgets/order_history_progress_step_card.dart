import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/presentation/widgets/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderHistoryProgressStepCard extends StatelessWidget {
  final String time;
  final String title;
  final String orderId;
  final bool isCompleted;
  final bool isCurrent;
  final int currentStatusIndex;
  final bool isLastRow;
  final String restaurantId;

  const OrderHistoryProgressStepCard({
    super.key,
    required this.time,
    required this.title,
    required this.orderId,
    required this.isCompleted,
    required this.isCurrent,
    required this.currentStatusIndex,
    this.isLastRow = false,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color.fromARGB(26, 255, 48, 8)
                    : const Color(0xffF6F6F6),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? SvgPicture.asset(
                        "assets/icons/checks.svg",
                        fit: BoxFit.scaleDown,
                        height: 14.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xffFF3008),
                          BlendMode.srcIn,
                        ),
                      )
                    : Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? const Color(0xffFF9292)
                              : const Color(0xffD9D9D9),
                          shape: BoxShape.circle,
                        ),
                      ),
              ),
            ),
            if (!isLastRow)
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                width: 3,
                height: 6.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  gradient: isCurrent
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFFF3008).withOpacity(1.0),
                            const Color(0xFFFF3008).withOpacity(0.1),
                          ],
                        )
                      : null,
                  color: isCompleted
                      ? const Color(0xFFFF3008)
                      : !isCurrent
                          ? const Color(0xffE5E7EB)
                          : null,
                ),
              ),
          ],
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (time.isNotEmpty)
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                maxLines: 1,
                title,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              (isCurrent)
                  ? (isCurrent && currentStatusIndex == 1 ||
                          currentStatusIndex == 2)
                      ? InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return CancelOrderBottomSheet(
                                  orderId: orderId,
                                  restaurantId: restaurantId,
                                );
                              },
                              isScrollControlled: true,
                            );
                          },
                          child: Container(
                            width: 30.w,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Cancel Order",
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.5.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 30.w,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Current State",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.5.sp,
                              color: Colors.white,
                            ),
                          ),
                        )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }
}
