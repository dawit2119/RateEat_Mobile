import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:intl_phone_field/countries.dart';
import 'package:intl_phone_field/country_picker_dialog.dart';
import 'package:intl_phone_field/intl_phone_field.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class PhoneNumberField extends StatelessWidget {
  final TextEditingController controller;
  final void Function(Country?)? onCountryChanged;
  final bool autoValidate;
  final Color fillColor;
  final bool readOnly;
  final bool enabled;

  const PhoneNumberField({
    super.key,
    this.enabled = true,
    this.onCountryChanged,
    this.fillColor = const Color(0xFFFBFCFF),
    required this.autoValidate,
    required this.controller,
    this.readOnly = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntlPhoneField(
      readOnly: readOnly,
      controller: controller,
      initialCountryCode: "ET",
      keyboardType: TextInputType.number,
      enabled: enabled,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      inputFormatters: [FilteringTextInputFormatter.digitsOnly],
      validator: (p0) {
        final check = p0 != null && p0.number != "";
        if (check) {
          if (p0.number.length < 10) {
            return AppLocalizations.of(context)!.phoneNoInvalidText;
          }
          if (!RegExp(r'^9\d+').hasMatch(p0.number)) {
            return AppLocalizations.of(context)!.phoneNoStartWithText;
          }
        }
        return null;
      },
      decoration: InputDecoration(
        hintText: AppLocalizations.of(context)!.phoneNoText,
        filled: true,
        fillColor: fillColor,
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: const Color(0xFFCDCDCD),
            width: .1.h,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        focusedBorder: const OutlineInputBorder(
          borderSide: BorderSide(
            color: Color(0xFF9F9F9F),
          ),
          borderRadius: BorderRadius.all(Radius.circular(10.0)),
        ),
      ),
      style: TextStyle(
        fontSize: 1.7.h,
      ),
      pickerDialogStyle: PickerDialogStyle(
        backgroundColor: Colors.white,
        searchFieldPadding: EdgeInsets.only(
          left: 8.w,
          right: 8.w,
          top: 1.h,
        ),
        searchFieldInputDecoration: InputDecoration(
          hintText: AppLocalizations.of(context)!.countryText,
        ),
        countryNameStyle: TextStyle(
          fontSize: 1.7.h,
        ),
      ),
      dropdownTextStyle: TextStyle(
        fontSize: 1.7.h,
      ),
      flagsButtonPadding: EdgeInsets.only(
        left: 2.w,
      ),
      languageCode: "en",
      onCountryChanged: onCountryChanged,
    );
  }
}
