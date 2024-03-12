import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CustomAlertWidget extends StatefulWidget {
  final String text;

  const CustomAlertWidget({super.key, required this.text});

  @override
  State<CustomAlertWidget> createState() => _CustomAlertWidgetState();
}

class _CustomAlertWidgetState extends State<CustomAlertWidget> {
  bool _isExpanded = false;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        setState(() {
          _isExpanded = !_isExpanded;
        });
      },
      child: Container(
        padding: const EdgeInsets.symmetric(horizontal: 24.0, vertical: 12.0),
        decoration: BoxDecoration(
          color: const Color(0xFFFFDFB5),
          borderRadius: BorderRadius.circular(5.0),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment:
              CrossAxisAlignment.start, // Align items to the start
          children: [
            const Icon(
              Icons.warning_rounded,
              color: Color(0xffFB8B1C),
              size: 24.0,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: AnimatedCrossFade(
                firstChild: Text(
                  widget.text,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 1.7.h,
                  ),
                  overflow: TextOverflow.ellipsis,
                  maxLines: 1,
                ),
                secondChild: Text(
                  widget.text,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w500,
                    fontSize: 1.7.h,
                  ),
                  softWrap: true, // Ensure the text wraps
                ),
                crossFadeState: _isExpanded
                    ? CrossFadeState.showSecond
                    : CrossFadeState.showFirst,
                duration: const Duration(milliseconds: 300),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
