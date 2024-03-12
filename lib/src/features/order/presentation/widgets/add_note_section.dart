import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class AddNoteField extends StatelessWidget {
  final String title;
  final String hintText;
  final TextEditingController textEditingController;
  final FocusNode? focusNode;
  const AddNoteField(
      {super.key,
      required this.title,
      required this.textEditingController,
      required this.hintText,
      this.focusNode});
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: 17.sp,
            ),
          ),
        ),
        SizedBox(
          height: 1.5.h,
        ),
        SizedBox(
          child: Material(
            color: Colors.white,
            child: TextFormField(
              focusNode: focusNode,
              controller: textEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: 4,
              style: GoogleFonts.poppins(
                fontSize: 1.7.h,
              ),
              decoration: InputDecoration(
                hintText: hintText,
                enabledBorder: OutlineInputBorder(
                  borderSide: const BorderSide(
                    color: Colors.black38,
                    width: 0.0,
                  ),
                  borderRadius: BorderRadius.circular(8.0),
                ),
                focusedBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(8.0),
                  borderSide: const BorderSide(
                    color: Color(0xFFFF3008),
                    width: 0.0,
                  ),
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }
}
