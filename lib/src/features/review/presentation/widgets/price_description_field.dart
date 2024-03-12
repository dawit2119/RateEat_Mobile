import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';

class PriceDescription extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;

  const PriceDescription(
      {super.key, required this.title, required this.textEditingController});
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      child: Material(
        color: Colors.white,
        child: TextFormField(
          controller: textEditingController,
          keyboardType: TextInputType.multiline,
          //  canRequestFocus: true,
          maxLines: 3,
          style: GoogleFonts.poppins(
            fontSize: SizeConfig.screenHeight * 0.017,
          ),
          decoration: InputDecoration(
            hintText: title,
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
    );
  }
}
