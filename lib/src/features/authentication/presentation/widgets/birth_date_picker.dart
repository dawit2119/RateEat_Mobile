import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';

class BirthDateInput extends StatefulWidget {
  final String birthDay;
  final Function(String) selectedDate;

  const BirthDateInput(
      {super.key, required this.selectedDate, this.birthDay = ""});

  @override
  State<BirthDateInput> createState() => _BirthDateInputState();
}

class _BirthDateInputState extends State<BirthDateInput> {
  final TextEditingController _date = TextEditingController();

  @override
  void initState() {
    _date.text = widget.birthDay;
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return SizedBox(
      height: screenHeight * 0.064,
      child: GestureDetector(
        onTap: () => _selectDate(context),
        child: AbsorbPointer(
          child: TextFormField(
            controller: _date,
            decoration: InputDecoration(
              hintText: "yyyy-MM-dd",
              filled: true,
              fillColor: const Color(0xFFFBFCFF),
              labelStyle: TextStyle(
                color: const Color(0xFFCDCDCD),
                fontSize: screenHeight * 0.018,
                fontWeight: FontWeight.bold,
              ),
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(
                  color: const Color(0xFFCDCDCD),
                  width: screenHeight * 0.001,
                ),
                borderRadius: BorderRadius.circular(8.0),
              ),
              prefixIcon: Padding(
                padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
                child: const Icon(
                  Icons.calendar_today_outlined,
                  color: Color(0xFF9F9F9F),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate(BuildContext context) async {
    final DateTime currentDate = DateTime.now();
    final DateTime minimumAdultDate = DateTime(currentDate.year - 18);

    DateTime? picked = await showDatePicker(
      context: context,
      initialDate: currentDate,
      firstDate: DateTime(1900),
      lastDate: currentDate,
    );

    // Check if picked date is at least 18 years ago
    if (picked != null) {
      if (picked.isBefore(minimumAdultDate)) {
        setState(() {
          _date.text = DateFormat('yyyy-MM-dd').format(picked);
          widget.selectedDate(_date.text);
        });
      } else if (context.mounted) {
        // Show error message if the selected date does not meet the age criteria
        final appLocalization = AppLocalizations.of(context)!;
        showDialog(
            context: context,
            builder: (BuildContext context) {
              return AlertDialog(
                title: Text(
                  appLocalization.dateErrorText,
                  style: GoogleFonts.poppins(
                      fontSize: SizeConfig.screenHeight * 0.02,
                      fontWeight: FontWeight.w500),
                ),
                content: Text(
                  appLocalization.adultText,
                  style: GoogleFonts.poppins(
                    fontSize: SizeConfig.screenHeight * 0.02,
                  ),
                ),
                actions: <Widget>[
                  TextButton(
                    onPressed: () => Navigator.of(context).pop(),
                    child: Text(
                      appLocalization.okText,
                      style: GoogleFonts.poppins(
                        fontSize: SizeConfig.screenHeight * 0.02,
                      ),
                    ),
                  ),
                ],
              );
            });
      }
    }
  }
}
