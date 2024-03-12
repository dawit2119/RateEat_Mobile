import 'package:connectivity_plus/connectivity_plus.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ConnectivityService {
  final BuildContext appContext;
  var _isDialogShown = false;

  ConnectivityService(this.appContext) {
    Connectivity()
        .onConnectivityChanged
        .listen((List<ConnectivityResult> results) {
      if (results.contains(ConnectivityResult.none)) {
        if (!_isDialogShown) {
          _showConnectivityDialog();
          _isDialogShown = true;
        }
      } else {
        if (_isDialogShown && appContext.mounted) {
          Navigator.of(appContext, rootNavigator: true).pop('dialog');
          _isDialogShown = false;
        }
      }
    });
  }

  void _showConnectivityDialog() {
    showModalBottomSheet(
      context: appContext,
      clipBehavior: Clip.none,
      backgroundColor: Colors.transparent,
      barrierColor: Colors.transparent,
      isScrollControlled: true,
      elevation: 0,
      builder: (BuildContext context) {
        return Container(
          height: 14.h,
          margin: const EdgeInsets.all(10),
          color: Colors.red.shade400,
          child: Wrap(
            children: <Widget>[
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: <Widget>[
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.noInternetText,
                          style: GoogleFonts.poppins(
                            fontSize: 14,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        IconButton(
                          icon: const Icon(Icons.close),
                          onPressed: () => Navigator.of(context).pop(),
                        ),
                      ],
                    ),
                    const SizedBox(height: 8),
                    Text(
                      AppLocalizations.of(context)!.connText,
                      style: GoogleFonts.poppins(
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
