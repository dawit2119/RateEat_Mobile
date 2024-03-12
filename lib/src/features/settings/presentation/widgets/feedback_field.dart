import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';

class FeedbackField extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;
  const FeedbackField(
      {super.key, required this.textEditingController, required this.title});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Text(
            title,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.screenHeight * 0.023,
            ),
          ),
        ),
        SizedBox(
          height: SizeConfig.screenHeight * 0.015,
        ),
        SizedBox(
          child: Material(
            color: Colors.white,
            child: TextFormField(
              controller: textEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              style: GoogleFonts.poppins(
                fontSize: SizeConfig.screenHeight * 0.017,
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.expDetailText,
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
