import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/verify_edit_profile/verify_edit_profile_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class VerifyEmailPage extends StatefulWidget {
  final dynamic user;
  const VerifyEmailPage({
    super.key,
    required this.user,
  });

  @override
  State<VerifyEmailPage> createState() => _VerifyEmailPageState();
}

class _VerifyEmailPageState extends State<VerifyEmailPage> {
  final _formKey = GlobalKey<FormState>();
  final userId =
      dpLocator<AuthenticationLocalSource>().getUserCredential()!.id!;
  OtpFieldController otpController = OtpFieldController();
  String otpValue = "";
  late String _email;
  //*Resend Opt timer
  int secondsRemaining = 60;
  bool enableResend = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
    _email = widget.user['email'];
    timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (secondsRemaining != 0) {
        setState(() {
          secondsRemaining--;
        });
      } else {
        setState(() {
          enableResend = true;
        });
      }
    });
  }

  @override
  void dispose() {
    otpValue = "";
    timer.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SingleChildScrollView(
        child: BlocListener<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is SendEditEmailOtpState &&
                state.status == AuthStatus.loaded) {
              showCustomToast(
                context: context,
                showIcon: false,
                toastMessage: AppLocalizations.of(context)!.otpSentText,
                toastType: ToastType.success,
              );
              setState(() {
                secondsRemaining = 0;
                enableResend = false;
              });
            }
          },
          child: Padding(
            padding: EdgeInsets.symmetric(horizontal: 7.6.w),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4.h,
                ),
                Center(
                  child: SizedBox(
                    height: 35.h,
                    child: Image.asset('assets/images/amico.png'),
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.otpText,
                  style: GoogleFonts.poppins(
                    fontSize: 4.3.h,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),

                // Email
                Text(
                  AppLocalizations.of(context)!.otpSentToText,
                  style: GoogleFonts.poppins(
                    fontSize: 1.9.h,
                    color: const Color(0xFFCDCDCD),
                  ),
                ),
                SizedBox(
                  height: 4.h,
                ),

                Text(
                  _email,
                  style: GoogleFonts.poppins(
                    fontSize: 1.9.h,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                // OTP input
                SizedBox(
                  height: 2.h,
                ),
                Form(
                  key: _formKey,
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      OTPTextField(
                          controller: otpController,
                          length: 6,
                          width: MediaQuery.of(context).size.width.w,
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldWidth: 45,
                          fieldStyle: FieldStyle.box,
                          outlineBorderRadius: 15,
                          style: GoogleFonts.poppins(fontSize: 1.7.h),
                          onChanged: (pin) {
                            setState(() {
                              otpValue = pin;
                            });
                          },
                          onCompleted: (pin) {
                            setState(() {
                              otpValue = pin;
                            });
                          }),

                      SizedBox(
                        height: 3.h,
                      ),
                      // Resend OTP
                      Text(
                        AppLocalizations.of(context)!.notOtpSentText,
                        style: GoogleFonts.poppins(
                          fontSize: 1.9.h,
                          color: const Color(0xFFCDCDCD),
                        ),
                      ),
                      Row(
                        mainAxisAlignment: MainAxisAlignment.start,
                        crossAxisAlignment: CrossAxisAlignment.center,
                        children: [
                          BlocBuilder<AuthenticationBloc, AuthenticationState>(
                            builder: (context, state) {
                              return TextButton(
                                style: TextButton.styleFrom(
                                    backgroundColor: Colors.white,
                                    padding: EdgeInsets.zero),
                                onPressed: ((state is SendEditEmailOtpState &&
                                            state.status ==
                                                AuthStatus.loading) ||
                                        !enableResend)
                                    ? null
                                    : () async {
                                        context.read<AuthenticationBloc>().add(
                                              SendEditEmailOtpEvent(
                                                email: _email,
                                              ),
                                            );
                                        otpValue = "";
                                      },
                                child: Text(
                                  AppLocalizations.of(context)!.resendText,
                                  style: GoogleFonts.poppins(
                                    fontSize: 2.2.h,
                                    color: enableResend
                                        ? Colors.black
                                        : Colors.grey,
                                    fontWeight: enableResend
                                        ? FontWeight.bold
                                        : FontWeight.normal,
                                  ),
                                ),
                              );
                            },
                          ),
                          SizedBox(
                            width: 3.w,
                          ),
                          if (!enableResend)
                            Text(
                              '$secondsRemaining seconds',
                              style: GoogleFonts.poppins(
                                color: Colors.black,
                                fontSize: 1.5.h,
                              ),
                            ),
                        ],
                      ),

                      SizedBox(
                        height: 10.h,
                      ),
                      BlocConsumer<VerifyEditProfileBloc,
                          VerifyEditProfileState>(
                        listener: (BuildContext context,
                            VerifyEditProfileState verifyState) {
                          if (verifyState is VerifyEditProfileSuccess) {
                            showCustomToast(
                              context: context,
                              showIcon: false,
                              toastMessage: AppLocalizations.of(context)!
                                  .profileUpdatedText,
                              toastType: ToastType.success,
                            );
                            context.read<GetUserProfileBloc>().add(
                                  GetUserProfileEvent(
                                    userId: userId,
                                  ),
                                );
                            context.goNamed(AppRoutes.home);
                          } else if (verifyState is VerifyEditProfileError) {
                            showCustomToast(
                              context: context,
                              toastMessage: verifyState.error,
                              toastType: ToastType.error,
                            );
                          }
                        },
                        builder: (context, state) {
                          return SizedBox(
                            width: double.infinity,
                            height: 6.4.h,
                            child: ElevatedButton(
                              onPressed: (state is VerifyEditProfileLoading)
                                  ? null
                                  : () {
                                      if (otpValue.length < 6) {
                                        showCustomToast(
                                          context: context,
                                          toastMessage:
                                              AppLocalizations.of(context)!
                                                  .validOtpText,
                                          toastType: ToastType.error,
                                        );
                                        return;
                                      }
                                      _formKey.currentState!.save();
                                      var user = widget.user;
                                      user['otp'] = otpValue;

                                      context.read<VerifyEditProfileBloc>().add(
                                            SubmitVerifyEditProfileEvent(
                                              user: UserModel(
                                                email: user['email'],
                                              ),
                                              updateData: user,
                                            ),
                                          );
                                    },
                              style: ElevatedButton.styleFrom(
                                foregroundColor: Colors.white, // Text color
                                backgroundColor:
                                    const Color(0xFFFF3008), // Text color
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12.0),
                                ),
                              ),
                              child: (state is VerifyEditProfileLoading)
                                  ? LoadingAnimationWidget.dotsTriangle(
                                      color: Colors.white,
                                      size: 4.h,
                                    )
                                  : Text(
                                      AppLocalizations.of(context)!.confirmText,
                                      style: GoogleFonts.poppins(
                                          color: Colors.white, fontSize: 2.h),
                                    ),
                            ),
                          );
                        },
                      ),
                    ],
                  ),
                )
              ],
            ),
          ),
        ),
      ),
    );
  }
}
