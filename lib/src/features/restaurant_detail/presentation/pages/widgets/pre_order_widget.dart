import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PreOrderButton extends StatelessWidget {
  const PreOrderButton({
    super.key,
    this.onTap,
  });
  final void Function()? onTap;
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100.w,
      height: 12.h,
      alignment: Alignment.center,
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(
            12,
          ),
          topRight: Radius.circular(
            12,
          ),
        ),
      ),
      child: InkWell(
        onTap: onTap,
        child: Container(
            height: 8.h,
            width: 90.w,
            padding: const EdgeInsets.symmetric(
              vertical: 16,
              horizontal: 24,
            ),
            decoration: BoxDecoration(
              color: const Color(0xffFF3008),
              borderRadius: BorderRadius.circular(10),
            ),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              // crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Text(
                  "Order Available",
                  style: GoogleFonts.plusJakartaSans(
                    fontWeight: FontWeight.w600,
                    fontSize: 18,
                    color: Colors.white,
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                SvgPicture.asset(
                  "assets/icons/pre_order.svg",
                  fit: BoxFit.scaleDown,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
              ],
            )),
      ),
    );
  }
}
