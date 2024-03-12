import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';

class IconButtonsRow extends StatelessWidget {
  final Function() onGalleryPressed;
  final Function() onCameraPressed;

  const IconButtonsRow({
    super.key,
    required this.onGalleryPressed,
    required this.onCameraPressed,
  });

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: SizeConfig.screenHeight * 0.15,
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          _buildButtonColumn(Icons.photo_library_outlined,
              AppLocalizations.of(context)!.galleryText, onGalleryPressed),
          _buildButtonColumn(Icons.camera_alt_outlined,
              AppLocalizations.of(context)!.cameraText, onCameraPressed),
        ],
      ),
    );
  }

  Widget _buildButtonColumn(IconData icon, String label, Function() onPressed) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        Container(
          padding: const EdgeInsets.all(6.0),
          decoration: BoxDecoration(
            color: Colors.red,
            borderRadius: BorderRadius.circular(10.0),
          ),
          child: IconButton(
            icon: Icon(icon),
            onPressed: onPressed,
            tooltip: label,
            color: Colors.white,
          ),
        ),
        const SizedBox(height: 8.0),
        Text(
          label,
          style: GoogleFonts.poppins(
            fontSize: 16,
            fontWeight: FontWeight.w500,
          ),
        ),
      ],
    );
  }
}
