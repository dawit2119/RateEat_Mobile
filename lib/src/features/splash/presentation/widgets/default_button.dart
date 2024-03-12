import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';

import '../../../../core/constants/constants.dart';

class DefaultButton extends StatelessWidget {
  const DefaultButton({
    super.key,
    required this.buttonText,
    required this.onPressed,
    this.isLoading = false,
  });
  final String buttonText;
  final Function onPressed;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 54,
      child: ElevatedButton(
        onPressed: () => onPressed(),
        style: ButtonStyle(
          backgroundColor: const WidgetStatePropertyAll(AppColors.primaryColor),
          shape: WidgetStatePropertyAll(
            RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
          ),
        ),
        child: Center(
          child: !isLoading
              ? Text(
                  buttonText,
                  style: medium16.copyWith(color: Colors.white),
                )
              : Center(
                  child: LoadingAnimationWidget.discreteCircle(
                    color: Colors.white,
                    secondRingColor: AppColors.grey100,
                    thirdRingColor: Colors.white30,
                    size: 24,
                  ),
                ),
        ),
      ),
    );
  }
}
