import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:iconsax/iconsax.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../core.dart';

FToast fToast = FToast();

void showCustomToast({
  required BuildContext context,
  required ToastType toastType,
  required String toastMessage,
  bool showIcon = true,
}) {
  fToast.init(context);

  final toastStyle = ToastStyleFactory.getStyle(toastType);

  Widget toast = Container(
    width: 90.w,
    padding: const EdgeInsets.symmetric(
      horizontal: 24.0,
      vertical: 12.0,
    ),
    margin: const EdgeInsets.symmetric(
      horizontal: 16,
    ),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(12),
      color: toastStyle.backgroundColor,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.max,
      children: [
        if (showIcon)
          Icon(
            toastStyle.icon,
            color: Colors.white,
          ),
        const SizedBox(
          width: 12.0,
        ),
        Flexible(
          flex: 2,
          child: Text(
            toastMessage,
            maxLines: 3,
            overflow: TextOverflow.ellipsis,
            style: const TextStyle(
              color: AppColors.textWhite,
              fontSize: 14,
            ),
          ),
        ),
      ],
    ),
  );

  // Custom Toast Position
  fToast.showToast(
    child: toast,
    gravity: ToastGravity.TOP,
    toastDuration: const Duration(seconds: 2),
    positionedToastBuilder:
        (BuildContext context, Widget child, ToastGravity? gravity) {
      return Positioned(
        key: const Key('customToast'),
        bottom: 16.0 + MediaQuery.of(context).viewInsets.bottom,
        child: SizedBox(
          width: 100.w,
          child: Center(child: child),
        ),
      );
    },
  );
}

enum ToastType {
  success,
  error,
  warning,
  info,
}

class ToastStyle {
  final IconData icon;
  final Color backgroundColor;

  ToastStyle({
    required this.icon,
    required this.backgroundColor,
  });
}

class ToastStyleFactory {
  static ToastStyle getStyle(ToastType type) {
    switch (type) {
      case ToastType.success:
        return ToastStyle(
          icon: Iconsax.tick_circle,
          backgroundColor: AppColors.successColor,
        );
      case ToastType.error:
        return ToastStyle(
          icon: Iconsax.close_square,
          backgroundColor: const Color.fromARGB(255, 255, 101, 74),
        );
      case ToastType.warning:
        return ToastStyle(
          icon: Iconsax.warning_2,
          backgroundColor: const Color.fromARGB(255, 255, 184, 77),
        );

      case ToastType.info:
        return ToastStyle(
          icon: Iconsax.info_circle,
          backgroundColor: const Color.fromARGB(255, 99, 174, 255),
        );
      default:
        throw Exception('Invalid toast type');
    }
  }
}
