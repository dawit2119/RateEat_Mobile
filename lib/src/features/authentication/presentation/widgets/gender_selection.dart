import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';

class GenderSelection extends StatefulWidget {
  final String? getGender;
  final Function(String) onGenderSelected;

  const GenderSelection(
      {super.key, required this.onGenderSelected, this.getGender});

  @override
  State<GenderSelection> createState() => _GenderSelectionState();
}

class _GenderSelectionState extends State<GenderSelection> {
  String? gender;

  @override
  void initState() {
    gender = widget.getGender;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Row(
        children: [
          Radio(
            value: 'Male',
            groupValue: gender,
            activeColor: AppColors.primaryColor,
            onChanged: (value) {
              setState(() {
                gender = value;
                widget.onGenderSelected(gender!);
              });
            },
          ),
          Text(
            AppLocalizations.of(context)!.maleGenderText,
            style: GoogleFonts.poppins(
              fontSize: SizeConfig.screenHeight * 0.02,
            ),
          ),
          SizedBox(width: SizeConfig.screenWidth * 0.03),
          Radio(
            value: "Female",
            groupValue: gender,
            activeColor: AppColors.primaryColor,
            onChanged: (value) {
              setState(() {
                gender = value;
                widget.onGenderSelected(gender!);
              });
            },
          ),
          Text(
            AppLocalizations.of(context)!.femaleGenderText,
            style: GoogleFonts.poppins(
              fontSize: SizeConfig.screenHeight * 0.02,
            ),
          ),
        ],
      ),
    );
  }
}
