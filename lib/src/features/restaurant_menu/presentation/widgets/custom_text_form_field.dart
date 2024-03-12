import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:rateeat_mobile/src/core/theme/theme.dart';

class CustomTextFormField extends StatelessWidget {
  final String hintText;
  final Color fillColor;
  final Color labelColor;
  final TextEditingController controller;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final double? width;
  final IconData? leftIcon;
  final List<TextInputFormatter>? inputFormatters;

  const CustomTextFormField({
    super.key,
    required this.hintText,
    required this.fillColor,
    required this.labelColor,
    required this.controller,
    this.validator,
    this.inputType,
    this.width,
    this.leftIcon,
    this.inputFormatters,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: width,
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: validator,
        autovalidateMode: AutovalidateMode.onUserInteraction,
        inputFormatters: inputFormatters,
        decoration: InputDecoration(
          prefixIcon: leftIcon != null
              ? Icon(
                  leftIcon,
                )
              : null,
          contentPadding: const EdgeInsets.symmetric(
            vertical: 10,
            horizontal: 12,
          ),
          hintText: hintText,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.secondaryColor),
          ),
          errorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.errrorColor),
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: const BorderSide(color: AppColors.grey300),
          ),
          focusedErrorBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(10),
            borderSide: const BorderSide(color: AppColors.primaryColor),
          ),
          filled: true,
          fillColor: Colors.white,
        ),
      ),
    );
  }
}
