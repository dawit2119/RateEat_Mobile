import 'package:flutter/material.dart';

class SignInWithButton extends StatelessWidget {
  final String buttonText;
  final String buttonImage;
  final VoidCallback? onPressed;

  const SignInWithButton({
    super.key,
    required this.buttonText,
    required this.buttonImage,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.064,
      child: OutlinedButton(
        onPressed: onPressed,
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.white,
          side: const BorderSide(color: Color(0XFF959DA5)), // Outline color
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12.0), // Button border radius
          ),
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Image.asset(buttonImage,
                height: screenHeight * 0.044,
                width: 24.0), // You can replace this with your Google logo
            SizedBox(
                width: screenWidth * 0.05), // Spacing between the logo and text
            Text(
              buttonText,
              style: TextStyle(
                fontSize: screenHeight * 0.018,
                color: Colors.black,
              ),
            ),
          ],
        ),
      ),
    );
  }
}
