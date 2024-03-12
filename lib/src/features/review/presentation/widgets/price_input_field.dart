import 'package:flutter/material.dart';

import '../../../../core/constants/constants.dart';

class PriceTextField extends StatelessWidget {
  final String hintText;
  final Color fillColor;
  final Color labelColor;
  final TextEditingController controller;
  final TextInputType? inputType;
  final String? Function(String?)? validator;
  final double? width;

  const PriceTextField({
    super.key,
    required this.hintText,
    required this.fillColor,
    required this.labelColor,
    required this.controller,
    this.validator,
    this.inputType,
    this.width,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = SizeConfig.screenHeight;
    return SizedBox(
      height: screenHeight * 0.064,
      width: width,
      child: TextFormField(
        controller: controller,
        keyboardType: inputType,
        validator: validator,
        //  canRequestFocus: true,
        decoration: InputDecoration(
          hintText: hintText,
          filled: true,
          fillColor: fillColor,
          labelStyle: TextStyle(
            color: labelColor,
            fontSize: screenHeight * 0.018,
          ),
          enabledBorder: OutlineInputBorder(
            borderSide: BorderSide(
              color: labelColor,
              width: screenHeight * 0.001,
            ),
            borderRadius: BorderRadius.circular(8.0),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(8.0),
            borderSide: const BorderSide(
              color: Color(0xFFFF3008),
            ),
          ),
        ),
      ),
    );
  }
}
