import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import './custom_persistent_bottom_navbar.dart';
import '../core.dart';

// Don't pul inside unbounded height widget
class RedirectLoginWidget extends StatelessWidget {
  const RedirectLoginWidget({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.read<DiscoverSelectedScreenCubit>().toDiscoverOptionsPage();
          context.read<BottomNavigationCubit>().changeIndex(1);
          context.goNamed(
            AppRoutes.home,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          elevation: 0,
          scrolledUnderElevation: 0,
          automaticallyImplyLeading: false,
          actions: [
            Container(
              margin: EdgeInsets.only(
                  right: SizeConfig.screenWidth * 0.04,
                  top: SizeConfig.screenHeight * 0.01),
              height: SizeConfig.screenHeight * 0.05,
              width: SizeConfig.screenHeight * 0.05,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [...elevation_4],
                  borderRadius: BorderRadius.circular(10)),
              child: InkWell(
                borderRadius: BorderRadius.circular(10),
                onTap: () {
                  context.pushNamed(AppRoutes.settingsPage);
                },
                child: Center(
                  child: Icon(
                    Icons.settings,
                    color: Colors.black,
                    size: screenHeight * 0.025,
                    semanticLabel: "Settings",
                  ),
                ),
              ),
            ),
          ],
        ),
        body: Padding(
          padding: EdgeInsets.all(20.sp),
          child: Column(
            children: [
              // const Spacer(flex: 3),
              Expanded(
                flex: 3,
                child: SvgPicture.asset(
                  "assets/icons/profile_check.svg",
                ),
              ),
              verticalPadding(height: 2),

              Wrap(children: [
                Text(
                  AppLocalizations.of(context)!.noAccText,
                  style: GoogleFonts.poppins(
                    fontSize: 2.h,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ]),
              SizedBox(
                height: 5.h,
              ),
              CustomMainButton(
                title: AppLocalizations.of(context)!.loginText,
                onTap: () {
                  context.pushNamed(AppRoutes.login);
                },
                horizontalPadding: 8.sp,
              ),
              const Spacer(flex: 3),
            ],
          ),
        ),
      ),
    );
  }
}
