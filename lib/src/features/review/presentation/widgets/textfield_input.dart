import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/constants/constants.dart';

class InputTextfield extends StatelessWidget {
  final String title;
  final TextEditingController textEditingController;
  const InputTextfield({
    super.key,
    required this.title,
    required this.textEditingController,
  });
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(
          child: Text(
            title,
            style: medium16,
          ),
        ),
        verticalPadding(height: 1.2),
        SizedBox(
          child: Material(
            color: Colors.white,
            child: TextFormField(
              controller: textEditingController,
              keyboardType: TextInputType.multiline,
              maxLines: 5,
              style: GoogleFonts.poppins(
                fontSize: 1.7.h,
              ),
              decoration: InputDecoration(
                hintText: AppLocalizations.of(context)!.gaveRateDesc,
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
