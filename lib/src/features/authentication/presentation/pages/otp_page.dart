import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:otp_text_field/otp_field.dart';
import 'package:otp_text_field/style.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';

class OtpPage extends StatefulWidget {
  final Map<String, dynamic> previousRouteInfo;
  const OtpPage({
    super.key,
    required this.previousRouteInfo,
  });

  @override
  State<OtpPage> createState() => _OtpPageState();
}

class _OtpPageState extends State<OtpPage> {
  final _formKey = GlobalKey<FormState>();
  OtpFieldController otpController = OtpFieldController();
  String otpValue = "";
  String? errorMessage;

  //*Resend OTP timer - reduced to 120 seconds (2 minutes)
  int secondsRemaining = 300;
  bool enableResend = false;
  late Timer timer;

  @override
  void initState() {
    super.initState();
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
    timer.cancel();
    otpValue = "";
    super.dispose();
  }

  String _formatTime(int seconds) {
    int minutes = seconds ~/ 60;
    int remainingSeconds = seconds % 60;
    return '${minutes.toString().padLeft(1, '0')}:${remainingSeconds.toString().padLeft(2, '0')}';
  }

  void _shakeFields() {
    // Clear the OTP fields on error
    otpController.clear();
    setState(() {
      otpValue = "";
    });
  }

  @override
  Widget build(BuildContext context) {
    var email = widget.previousRouteInfo['email'];
    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          child: BlocListener<AuthenticationBloc, AuthenticationState>(
            listener: (context, state) {
              if (state is VerifyEmailOtpState &&
                  state.status == AuthStatus.loaded) {
                if (state.response!.statusCode == 201) {
                  showCustomToast(
                    context: context,
                    toastMessage:
                        AppLocalizations.of(context)!.welcomeMessageText,
                    toastType: ToastType.success,
                    showIcon: false,
                  );
                } else if (state.response!.statusCode == 200) {
                  showCustomToast(
                    context: context,
                    toastMessage:
                        AppLocalizations.of(context)!.welcomeBackMessageText,
                    toastType: ToastType.success,
                    showIcon: false,
                  );
                }
                GoRouter.of(context).refresh();
                if (widget.previousRouteInfo.containsKey("routeName")) {
                  switch (widget.previousRouteInfo['routeName']) {
                    case AppRoutes.candidateRestaurantPage:
                      context.pushReplacementNamed(
                          AppRoutes.candidateRestaurantPage);
                      break;
                    case AppRoutes.addItemReview:
                      final item = widget.previousRouteInfo['item'];
                      context.pushReplacementNamed(AppRoutes.addItemReview,
                          pathParameters: {
                            'itemId': item!.itemId
                          },
                          extra: {
                            "item": item,
                            "loginRedirection": "loginRedirection",
                          });
                      break;
                    case AppRoutes.addRestaurantReview:
                      final restaurant = widget.previousRouteInfo['restaurant'];
                      context.pushReplacementNamed(
                          AppRoutes.addRestaurantReview,
                          pathParameters: {
                            'restaurantId': restaurant!.id!
                          },
                          extra: {
                            "restaurant":
                                widget.previousRouteInfo['restaurant'],
                            "loginRedirection": "loginRedirection",
                          });
                      break;
                    case AppRoutes.itemDetail:
                      var item = widget.previousRouteInfo['item'];
                      context.pushReplacementNamed(AppRoutes.itemDetail,
                          pathParameters: {
                            'itemId': item.itemId,
                          },
                          extra: {
                            "item": item,
                            "loginRedirection": "loginRedirection",
                          });
                    case AppRoutes.restaurantDetail:
                      var restaurant = widget.previousRouteInfo['restaurant'];
                      context.pushReplacementNamed(AppRoutes.restaurantDetail,
                          pathParameters: {
                            'restaurantId': restaurant.id,
                          },
                          extra: {
                            "restaurant": restaurant,
                            "loginRedirection": "loginRedirection",
                          });
                    case AppRoutes.restaurantReviews:
                      var restaurant = widget.previousRouteInfo['restaurant'];

                      context.pushReplacementNamed(
                        AppRoutes.restaurantReviews,
                        pathParameters: {'restaurantId': restaurant.id!},
                        extra: {
                          'restaurant': restaurant,
                          "loginRedirection": "loginRedirection",
                        },
                      );
                    case AppRoutes.itemReviews:
                      var item = widget.previousRouteInfo['item'];

                      context.pushReplacementNamed(
                        AppRoutes.itemReviews,
                        pathParameters: {'itemId': item.itemId},
                        extra: {
                          'item': item,
                          "loginRedirection": "loginRedirection",
                        },
                      );
                    case AppRoutes.quickAddReviewFileSelect:
                      context.read<SimpleReviewStepperBloc>().add(
                            const SimpleReviewStepperUpdate(
                              images: [],
                              videos: [],
                            ),
                          );
                      context.pop();
                      context.pushReplacementNamed(
                          AppRoutes.quickAddReviewFileSelect);
                    case AppRoutes.qrMenuPage:
                      String restaurantId =
                          widget.previousRouteInfo['restaurantId'];

                      context.pushReplacementNamed(AppRoutes.qrMenuPage,
                          pathParameters: {
                            'restaurantId': restaurantId,
                          },
                          extra: {
                            "loginRedirection": "loginRedirection",
                          });
                    default:
                      context.goNamed(AppRoutes.home);
                  }
                } else {
                  context.goNamed(AppRoutes.home);
                }
              } else if (state is VerifyEmailOtpState &&
                  state.status == AuthStatus.error) {
                _shakeFields();
                setState(() {
                  errorMessage = state.errorMessage;
                });
                showCustomToast(
                  context: context,
                  toastMessage: state.errorMessage!,
                  toastType: ToastType.error,
                );
              }
              if (state is ResendEmailOtpState &&
                  state.status == AuthStatus.loaded) {
                showCustomToast(
                  context: context,
                  toastMessage: AppLocalizations.of(context)!.otpSentToText,
                  toastType: ToastType.success,
                );
                setState(() {
                  secondsRemaining = 300;
                  enableResend = false;
                });
              } else if (state is ResendEmailOtpState &&
                  state.status == AuthStatus.error) {
                showCustomToast(
                  context: context,
                  toastMessage: state.errorMessage!,
                  toastType: ToastType.error,
                );
              }
            },
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 7.6.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(height: 2.h),

                  // Image - reduced height from 35.h to 28.h
                  Center(
                    child: SizedBox(
                      height: 28.h,
                      child: Image.asset('assets/images/amico.png'),
                    ),
                  ),

                  SizedBox(height: 2.h),

                  // Title
                  Text(
                    AppLocalizations.of(context)!.otpText,
                    style: GoogleFonts.poppins(
                      fontSize: 4.3.h,
                      fontWeight: FontWeight.bold,
                    ),
                  ),

                  SizedBox(height: 1.h),

                  // Subtitle and email - tighter spacing
                  RichText(
                    text: TextSpan(
                      style: GoogleFonts.poppins(
                        fontSize: 1.9.h,
                        color: const Color(0xFFCDCDCD),
                      ),
                      children: [
                        TextSpan(
                          text: AppLocalizations.of(context)!.otpSentToText,
                        ),
                        TextSpan(
                          text: ' $email',
                          style: GoogleFonts.poppins(
                            fontSize: 1.9.h,
                            color: Colors.black,
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                      ],
                    ),
                  ),

                  SizedBox(height: 3.h),

                  // OTP input
                  Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        OTPTextField(
                          controller: otpController,
                          length: 6,
                          width: MediaQuery.of(context).size.width,
                          textFieldAlignment: MainAxisAlignment.spaceAround,
                          fieldWidth: 13.w, // Made responsive
                          fieldStyle: FieldStyle.box,
                          outlineBorderRadius: 12,
                          style: GoogleFonts.poppins(
                            fontSize: 2.2.h,
                            fontWeight: FontWeight.w600,
                          ),
                          keyboardType: TextInputType.number,
                          inputFormatter: [
                            FilteringTextInputFormatter.digitsOnly,
                          ],
                          onChanged: (pin) {
                            setState(() {
                              otpValue = pin;
                              if (errorMessage != null) {
                                errorMessage = null;
                              }
                            });
                          },
                          onCompleted: (pin) {
                            setState(() {
                              otpValue = pin;
                            });
                          },
                        ),

                        // Inline error message
                        if (errorMessage != null) ...[
                          SizedBox(height: 1.h),
                          Text(
                            errorMessage!,
                            style: GoogleFonts.poppins(
                              fontSize: 1.6.h,
                              color: Colors.red,
                            ),
                          ),
                        ],

                        SizedBox(height: 3.h),

                        // Resend OTP section with improved styling
                        Row(
                          children: [
                            Text(
                              AppLocalizations.of(context)!.notOtpSentText,
                              style: GoogleFonts.poppins(
                                fontSize: 1.8.h,
                                color: const Color(0xFFCDCDCD),
                              ),
                            ),
                            SizedBox(width: 1.w),
                            BlocBuilder<AuthenticationBloc,
                                AuthenticationState>(
                              builder: (context, state) {
                                return TextButton(
                                  style: TextButton.styleFrom(
                                    backgroundColor: Colors.transparent,
                                    padding:
                                        EdgeInsets.symmetric(horizontal: 2.w),
                                    minimumSize: Size.zero,
                                    tapTargetSize:
                                        MaterialTapTargetSize.shrinkWrap,
                                  ),
                                  onPressed: ((state is ResendEmailOtpState &&
                                              state.status ==
                                                  AuthStatus.loading) ||
                                          !enableResend)
                                      ? null
                                      : () async {
                                          context
                                              .read<AuthenticationBloc>()
                                              .add(
                                                ResendEmailOtpEvent(
                                                  email: email,
                                                ),
                                              );
                                          otpValue = "";
                                        },
                                  child: Text(
                                    AppLocalizations.of(context)!.resendText,
                                    style: GoogleFonts.poppins(
                                      fontSize: 1.8.h,
                                      color: enableResend
                                          ? const Color(0xFFFF3008)
                                          : Colors.grey,
                                      fontWeight: FontWeight.w600,
                                    ),
                                  ),
                                );
                              },
                            ),
                          ],
                        ),

                        // Timer display
                        if (!enableResend)
                          Padding(
                            padding: EdgeInsets.only(left: 0),
                            child: Text(
                              'Resend in ${_formatTime(secondsRemaining)}',
                              style: GoogleFonts.poppins(
                                color: const Color(0xFF888888),
                                fontSize: 1.6.h,
                              ),
                            ),
                          ),

                        SizedBox(height: 8.h),

                        // Confirm button
                        BlocBuilder<AuthenticationBloc, AuthenticationState>(
                          builder: (context, state) {
                            return SizedBox(
                              width: double.infinity,
                              height: 6.4.h,
                              child: ElevatedButton(
                                onPressed: (state is VerifyEmailOtpState &&
                                        state.status == AuthStatus.loading)
                                    ? null
                                    : () {
                                        if (otpValue.length < 6) {
                                          setState(() {
                                            errorMessage =
                                                AppLocalizations.of(context)!
                                                    .validOtpText;
                                          });
                                          return;
                                        }
                                        _formKey.currentState!.save();
                                        context.read<AuthenticationBloc>().add(
                                              VerifyEmailOtpEvent(
                                                email: email,
                                                code: otpValue,
                                              ),
                                            );
                                      },
                                style: ElevatedButton.styleFrom(
                                  foregroundColor: Colors.white,
                                  backgroundColor: const Color(0xFFFF3008),
                                  disabledBackgroundColor:
                                      const Color(0xFFFFCCC4),
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(12.0),
                                  ),
                                  elevation: 0,
                                ),
                                child: (state is VerifyEmailOtpState &&
                                        state.status == AuthStatus.loading)
                                    ? SizedBox(
                                        height: 2.5.h,
                                        width: 2.5.h,
                                        child: const CircularProgressIndicator(
                                          strokeWidth: 2.5,
                                          valueColor:
                                              AlwaysStoppedAnimation<Color>(
                                            Colors.white,
                                          ),
                                        ),
                                      )
                                    : Text(
                                        AppLocalizations.of(context)!
                                            .confirmText,
                                        style: GoogleFonts.poppins(
                                          color: Colors.white,
                                          fontSize: 2.h,
                                          fontWeight: FontWeight.w600,
                                        ),
                                      ),
                              ),
                            );
                          },
                        ),

                        SizedBox(height: 2.h),
                      ],
                    ),
                  )
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}
