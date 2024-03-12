import 'package:flutter/material.dart';

class TextInputField extends StatelessWidget {
  final String hintText;
  final IconData icon;
  final Color fillColor;
  final Color labelColor;
  final TextEditingController controller;
  final String? Function(String?)? validator;
  final TextInputType? inputType;

  const TextInputField(
      {super.key,
      required this.hintText,
      required this.icon,
      required this.fillColor,
      required this.labelColor,
      required this.controller,
      required this.validator,
      this.inputType});

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.064,
      child: TextFormField(
        controller: controller,
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
          prefixIcon: Padding(
            padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
            child: Icon(
              icon,
              color: const Color(0xFF9F9F9F),
            ),
          ),
        ),
        validator: validator ?? (value) => null,
      ),
    );
  }
}
