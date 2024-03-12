import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  final String title;
  final bool isBack;
  final List<Widget>? actions;
  const CustomAppBar({
    super.key,
    required this.onTap,
    required this.title,
    this.isBack = true,
    this.actions,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return AppBar(
      elevation: 0,
      scrolledUnderElevation: 0,
      title: Padding(
          padding: EdgeInsets.only(top: screenHeight * 0.015),
          child: Text(
            title,
            style: titleTextStyle.copyWith(
              fontSize: 18.sp,
            ),
          )),
      centerTitle: true,
      toolbarHeight: screenHeight * 0.1,
      leadingWidth: isBack ? screenWidth * 0.25 : null,
      automaticallyImplyLeading: false,
      leading: isBack
          ? Padding(
              padding: EdgeInsets.only(
                  top: screenHeight * 0.018,
                  left: screenWidth * 0.04,
                  bottom: 2),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.start,
                crossAxisAlignment: CrossAxisAlignment.center,
                children: [
                  Container(
                    height: 6.h,
                    width: 5.h,
                    decoration: BoxDecoration(
                        color: Colors.white,
                        boxShadow: [...elevation_4],
                        shape: BoxShape.circle),
                    child: InkWell(
                      borderRadius: BorderRadius.circular(10),
                      onTap: onTap,
                      child: Center(
                        child: Icon(
                          Icons.arrow_back,
                          color: Colors.black,
                          size: 2.4
                              .h, // responsive size (scales with screen width)
                          semanticLabel: "Back",
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            )
          : Container(),
      actions: actions,
    );
  }

  @override
  Size get preferredSize => AppBar().preferredSize;
}
