import 'package:flutter/material.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';

class FilterAppBar extends StatelessWidget implements PreferredSizeWidget {
  final VoidCallback onTap;
  const FilterAppBar({super.key, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: Text(
        AppLocalizations.of(context)!.filterItemsText,
        style: bodyMediumStyle,
      ),
      centerTitle: true,
      automaticallyImplyLeading: false,
      actions: [
        Padding(
          padding: EdgeInsets.only(right: 2.w),
          child: IconButton(
            onPressed: onTap,
            icon: SvgPicture.asset(
              "assets/icons/cancel.svg",
              height: 15.sp,
              width: 15.sp,
            ),
          ),
        )
      ],
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(36.sp);
}
