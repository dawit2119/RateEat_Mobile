import 'package:flutter/material.dart';

import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';

import 'package:rateeat_mobile/src/core/core.dart';

import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/widgets/text_with_icon_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SettingsPage extends StatefulWidget {
  bool getUser() {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      return user != null;
    } on CacheException {
      return false;
    }
  }

  const SettingsPage({super.key});

  @override
  SettingsPageState createState() => SettingsPageState();
}

class SettingsPageState extends State<SettingsPage> {
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      appBar: CustomAppBar(
          onTap: () {
            context.pop();
          },
          title: AppLocalizations.of(context)!.settingsText),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          child: Column(
            key: const Key('settings_column'),
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalPadding(height: 3),
              //* General Settings
              Text(
                AppLocalizations.of(context)!.generalText,
                style: semiBold16,
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              // const Divider(
              //   height: 1,
              //   thickness: 0.2,
              //   color: Colors.grey,
              // ),
              //? Language Preferences
              TextWithIconWidget(
                leading: const Icon(
                  Icons.language,
                  size: 18,
                ),
                title: AppLocalizations.of(context)!.langText,
                subTitle: AppLocalizations.of(context)!.changeLanguageText,
                onPressed: () {
                  context.pushNamed(AppRoutes.languagePage);
                },
              ),
              //? Account Connections
              // widget.getUser()
              //     ? TextWithIconWidget(
              //         leading: const Icon(
              //           Icons.link,
              //           size: 18,
              //         ),
              //         title: AppLocalizations.of(context)!.accConnText,
              //         subTitle: AppLocalizations.of(context)!.checkAccText,
              //         onPressed: () {
              //           // context.pushNamed(AppRoutes.connectedAccounts);
              //         },
              //       )
              //     : Container(),

              widget.getUser()
                  ? TextWithIconWidget(
                      leading: const Icon(
                        Iconsax.settings,
                        size: 18,
                      ),
                      title: AppLocalizations.of(context)!.preferenceText,
                      subTitle:
                          AppLocalizations.of(context)!.preferenceDescription,
                      onPressed: () {
                        context.pushNamed(AppRoutes.userPreferencesPage);
                      },
                    )
                  : Container(),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              TextWithIconWidget(
                leading: const Icon(
                  Icons.attach_money,
                  size: 18,
                ),
                title: AppLocalizations.of(context)!.currencyText,
                subTitle: AppLocalizations.of(context)!.currencyDescription,
                onPressed: () {
                  context.pushNamed(AppRoutes.currencyPage);
                },
              ),
              SizedBox(
                height: screenHeight * 0.02,
              ),
              //* Notification Settings
              // Text(
              //   AppLocalizations.of(context)!.notificationText,
              //   style: GoogleFonts.poppins(
              //     fontWeight: FontWeight.w500,
              //     fontSize: screenHeight * .02,
              //     color: Colors.black45,
              //     letterSpacing: 0.9,
              //   ),
              // ),
              // SizedBox(
              //   height: screenHeight * 0.01,
              // ),
              // const Divider(
              //   height: 1,
              //   thickness: 0.2,
              //   color: Colors.grey,
              // ),

              // TextWithIconWidget(
              //   leading: const Icon(
              //     Icons.notifications,
              //     size: 18,
              //   ),
              //   // title: AppLocalizations.of(context)!.privacyText,
              //   title: AppLocalizations.of(context)!.pushText,
              //   subTitle: AppLocalizations.of(context)!.dailyText,
              //   onPressed: () {},
              // ),
              // TextWithIconWidget(
              //   leading: const Icon(
              //     Icons.sms_rounded,
              //     size: 18,
              //   ),
              //   // title: AppLocalizations.of(context)!.privacyText,
              //   title: AppLocalizations.of(context)!.smsText,
              //   subTitle: AppLocalizations.of(context)!.dailyText,
              //   onPressed: () {},
              // ),
              // SizedBox(
              //   height: screenHeight * 0.03,
              // ),
              //* Privacy Settings
              Text(
                AppLocalizations.of(context)!.privacyTitleText,
                style: semiBold16,
              ),
              SizedBox(
                height: screenHeight * 0.01,
              ),
              // const Divider(
              //   height: 1,
              //   thickness: 0.2,
              //   color: Colors.grey,
              // ),

              TextWithIconWidget(
                leading: const Icon(
                  Icons.lock,
                  size: 18,
                ),
                title: AppLocalizations.of(context)!.termsText,
                subTitle: AppLocalizations.of(context)!.termsAndConditionsText,
                onPressed: () {
                  context.pushNamed(AppRoutes.termsPage);
                },
              ),
              TextWithIconWidget(
                leading: const Icon(
                  Icons.privacy_tip,
                  size: 18,
                ),
                title: AppLocalizations.of(context)!.privacyText,
                subTitle: AppLocalizations.of(context)!.seePrivacyPolicyText,
                onPressed: () {
                  context.pushNamed(AppRoutes.privacyPage);
                },
              ),
              TextWithIconWidget(
                leading: const Icon(
                  Icons.feedback_rounded,
                  size: 18,
                ),
                title: AppLocalizations.of(context)!.giveFeedbackText,
                subTitle: AppLocalizations.of(context)!.expDetailText,
                onPressed: () {
                  context.pushNamed(AppRoutes.giveFeedbackPage);
                },
              ),
              //* Logout Button
              widget.getUser()
                  ? TextWithIconWidget(
                      leading: Icon(
                        Icons.logout,
                        color: AppColors.primaryColor,
                        size: screenHeight * 0.025,
                      ),
                      title: AppLocalizations.of(context)!.logoutText,
                      titleColor: AppColors.primaryColor,
                      subTitle: AppLocalizations.of(context)!.logoutWantText,
                      onPressed: () {
                        _showLogOutDialog(ctx: context);
                      },
                    )
                  : Container(),

              //* Delete Account Button
              widget.getUser()
                  ? TextWithIconWidget(
                      leading: Icon(
                        Icons.delete_forever,
                        color: AppColors.primaryColor,
                        size: screenHeight * 0.025,
                      ),
                      title: AppLocalizations.of(context)!.deleteAccountText,
                      titleColor: AppColors.primaryColor,
                      subTitle: AppLocalizations.of(context)!
                          .confirmDeleteAccountText,
                      onPressed: () {
                        _showDeleteAccountDialog(ctx: context);
                      },
                    )
                  : Container()
            ],
          ),
        ),
      ),
    );
  }

  void _showLogOutDialog({required ctx}) {
    String logout = AppLocalizations.of(ctx)!.logoutText;
    String cancel = AppLocalizations.of(ctx)!.cancelText;
    final description = AppLocalizations.of(context)!.logoutWantText;
    showDialog(
      context: ctx,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(logout),
          content:
              Text(description), // <-- description/message here [web:1][web:3]
          actions: <Widget>[
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: Text(cancel),
            ),
            TextButton(
              onPressed: () {
                dpLocator<AuthenticationBloc>().add(LogoutEvent());
                Navigator.pop(ctx);

                // If you use go_router, use the outer context (ctx) to navigate
                ctx.goNamed(AppRoutes.onboarding);
              },
              child: Text(
                logout,
                style: const TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }

  void _showDeleteAccountDialog({required ctx}) {
    String deleteAccount = AppLocalizations.of(ctx)!.deleteAccountText;
    String delete = AppLocalizations.of(ctx)!.deleteText;
    String cancel = AppLocalizations.of(ctx)!.cancelText;
    showDialog(
      context: ctx,
      builder: (ctx) {
        return AlertDialog(
          backgroundColor: Colors.white,
          surfaceTintColor: Colors.white,
          title: Text(deleteAccount),
          actions: <Widget>[
            TextButton(
              onPressed: () {
                Navigator.pop(ctx);
              },
              child: Text(cancel),
              // AppLocalizations.of(ctx)!.cancelText
            ),
            TextButton(
              onPressed: () {
                //* Delete session from local storage
                dpLocator<AuthenticationBloc>().add(DeleteAccountEvent());
                //* Navigate to login screen
                Navigator.pop(ctx);
                context.goNamed(
                  AppRoutes.onboarding,
                );
              },
              child: Text(
                delete,
                style: const TextStyle(color: AppColors.primaryColor),
              ),
            ),
          ],
        );
      },
    );
  }
}
