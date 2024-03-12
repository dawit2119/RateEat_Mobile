import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:url_launcher/url_launcher.dart';

import '../../../one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';

class LoginPage extends StatefulWidget {
  const LoginPage({super.key, this.previousRouteInfo = const {}});
  final Map<String, dynamic> previousRouteInfo;

  @override
  State<LoginPage> createState() => _LoginPageState();
}

class _LoginPageState extends State<LoginPage> {
  final _formKey = GlobalKey<FormState>();
  final TextEditingController _email = TextEditingController();
  String countryCode = "251";

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: BlocListener<AuthenticationBloc, AuthenticationState>(
        listener: (context, state) {
          if (state is SendEmailOtpState && state.status == AuthStatus.loaded) {
            context.pushNamed(AppRoutes.otpPage, extra: {
              "email": state.email,
              ...widget.previousRouteInfo,
            });
          } else if (state is SendEmailOtpState &&
              state.status == AuthStatus.error) {
            showCustomToast(
              context: context,
              toastMessage: "Could Not Send OTP, Please Try Again",
              toastType: ToastType.error,
            );
          }
          if (state is SignInWithGoogleState &&
              state.status == AuthStatus.loaded) {
            if (state.response!.statusCode == 201) {
              showCustomToast(
                context: context,
                toastMessage: AppLocalizations.of(context)!.welcomeMessageText,
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
            final userId = state.response!.user.id!;
            context.read<GetUserProfileBloc>().add(
                  GetUserProfileEvent(
                    userId: userId,
                  ),
                );
            if (widget.previousRouteInfo.containsKey("routeName")) {
              switch (widget.previousRouteInfo['routeName']) {
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
                  context.pushReplacementNamed(AppRoutes.addRestaurantReview,
                      pathParameters: {
                        'restaurantId': restaurant!.id!
                      },
                      extra: {
                        "restaurant": widget.previousRouteInfo['restaurant'],
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
                  context
                      .pushReplacementNamed(AppRoutes.quickAddReviewFileSelect);
                case AppRoutes.othersProfilePage:
                  context.pushReplacementNamed(AppRoutes.othersProfilePage,
                      pathParameters: {
                        "userId": widget.previousRouteInfo["userId"]
                      });
              }
            } else {
              context.goNamed(AppRoutes.home);
            }
          } else if (state is SignInWithGoogleState &&
              state.status == AuthStatus.error) {
            if (state.errorMessage != "") {
              showCustomToast(
                context: context,
                toastMessage: state.errorMessage!,
                toastType: ToastType.error,
              );
            }
          } else if (state is SignInWithFacebookState &&
              state.status == AuthStatus.error) {
            showCustomToast(
              context: context,
              toastMessage: state.errorMessage!,
              toastType: ToastType.error,
            );
          } else if (state is SignInWithFacebookState &&
              state.status == AuthStatus.error) {
            showCustomToast(
              context: context,
              toastMessage: state.errorMessage!,
              toastType: ToastType.error,
            );
          } else if (state is SignInWithAppleState &&
              state.status == AuthStatus.loaded) {
            if (state.response!.statusCode == 201) {
              showCustomToast(
                context: context,
                toastMessage: AppLocalizations.of(context)!.welcomeMessageText,
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
            final userId = state.response!.user.id!;
            context.read<GetUserProfileBloc>().add(
                  GetUserProfileEvent(
                    userId: userId,
                  ),
                );
            if (widget.previousRouteInfo.containsKey("routeName")) {
              switch (widget.previousRouteInfo['routeName']) {
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
                  context.pushReplacementNamed(AppRoutes.addRestaurantReview,
                      pathParameters: {
                        'restaurantId': restaurant!.id!
                      },
                      extra: {
                        "restaurant": widget.previousRouteInfo['restaurant'],
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
                  break;
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
                  break;
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
                  break;
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
                  break;
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
                  break;
                case AppRoutes.quickAddReviewFileSelect:
                  context.read<SimpleReviewStepperBloc>().add(
                        const SimpleReviewStepperUpdate(
                          images: [],
                          videos: [],
                        ),
                      );
                  context
                      .pushReplacementNamed(AppRoutes.quickAddReviewFileSelect);
                  break;
                case AppRoutes.othersProfilePage:
                  context.pushReplacementNamed(AppRoutes.othersProfilePage,
                      pathParameters: {
                        "userId": widget.previousRouteInfo["userId"]
                      });
                  break;
              }
            } else {
              context.goNamed(AppRoutes.home);
            }
          } else if (state is SignInWithAppleState &&
              state.status == AuthStatus.error) {
            if (state.errorMessage != "") {
              showCustomToast(
                context: context,
                toastMessage: state.errorMessage!,
                toastType: ToastType.error,
              );
            }
          }
        },
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.076),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 12.h,
              ),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    AppLocalizations.of(context)!.startText,
                    style: GoogleFonts.poppins(
                      fontSize: screenHeight * 0.046,
                      fontWeight: FontWeight.w700,
                      color: AppColors.secondaryColor,
                      height: 1.2,
                    ),
                  ),
                  TextButton(
                    style: ButtonStyle(
                      textStyle: WidgetStateProperty.resolveWith(
                          (Set<WidgetState> states) {
                        if (states.contains(WidgetState.pressed)) {
                          return GoogleFonts.poppins(color: Colors.white);
                        }
                        return GoogleFonts.poppins(color: AppColors.grey600);
                      }),
                      overlayColor: const WidgetStatePropertyAll(
                        AppColors.primaryLightColor,
                      ),
                      shape: WidgetStatePropertyAll(
                        RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                      ),
                    ),
                    onPressed: () {
                      context.pushNamed(
                        AppRoutes.home,
                      );
                    },
                    child: Text(
                      AppLocalizations.of(context)!.skipText,
                      textAlign: TextAlign.right,
                      style: GoogleFonts.poppins(
                        letterSpacing: .6,
                        fontWeight: FontWeight.w400,
                        fontSize: 15,
                        color: AppColors.secondaryColor,
                      ),
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: 6.h,
              ),
              _loginForm(screenHeight, screenWidth, context),
              SizedBox(
                height: 2.h,
              ),
              RichText(
                maxLines: 2,
                text: TextSpan(
                  style: GoogleFonts.poppins(
                    color: AppColors.grey400,
                    fontWeight: FontWeight.w400, // Gray color for regular text
                    fontSize: 16,
                    height: 1.4,
                  ),
                  children: [
                    const TextSpan(
                      text: 'By signing up you agree to our ',
                    ),
                    TextSpan(
                      text: 'terms and conditions',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.appColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchTermAndConditions();
                        },
                    ),
                    const TextSpan(
                      text: ' and ',
                    ),
                    TextSpan(
                      text: 'Privacy Policy',
                      style: const TextStyle(
                        fontWeight: FontWeight.w600,
                        color: AppColors.appColor,
                      ),
                      recognizer: TapGestureRecognizer()
                        ..onTap = () {
                          _launchPrivacyPolicy();
                        },
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              Center(
                child: Text(
                  AppLocalizations.of(context)!.orText,
                  style: TextStyle(
                    fontSize: screenHeight * 0.02,
                    color: const Color(0XFF959DA5),
                  ),
                ),
              ),
              SizedBox(
                height: 5.h,
              ),
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                if (state is SignInWithGoogleState &&
                    state.status == AuthStatus.loading) {
                  return Center(
                    key: const Key("Google-Sign-in:LoadingAnimationWidget"),
                    child: LoadingAnimationWidget.dotsTriangle(
                      color: AppColors.primaryColor,
                      size: screenHeight * 0.04,
                    ),
                  );
                }
                return SignInWithButton(
                  buttonText: AppLocalizations.of(context)!.googleText,
                  buttonImage: 'assets/images/google_logo.png',
                  onPressed: () {
                    context
                        .read<AuthenticationBloc>()
                        .add(SignInWithGoogleEvent());
                  },
                );
              }),
              // Sign up with Google button

              SizedBox(
                height: screenHeight * 0.02,
              ),
              // Apple Sign-In button
              BlocBuilder<AuthenticationBloc, AuthenticationState>(
                  builder: (context, state) {
                if (state is SignInWithAppleState &&
                    state.status == AuthStatus.loading) {
                  return Center(
                    key: const Key("Apple-Sign-in:LoadingAnimationWidget"),
                    child: LoadingAnimationWidget.dotsTriangle(
                      color: AppColors.primaryColor,
                      size: screenHeight * 0.04,
                    ),
                  );
                }
                return SignInWithButton(
                  buttonText: AppLocalizations.of(context)!.appleText,
                  buttonImage: 'assets/images/apple-touch-icon.png',
                  onPressed: () {
                    context
                        .read<AuthenticationBloc>()
                        .add(SignInWithAppleEvent());
                  },
                );
              }),

              SizedBox(
                height: screenHeight * 0.02,
              ),
              // Sign up with Facebook button
              // BlocBuilder<AuthenticationBloc, AuthenticationState>(
              //   builder: (context, state) {
              //     if (state is SignInWithFacebookState &&
              //         state.status == AuthStatus.loading) {
              //       return Center(
              //         child: LoadingAnimationWidget.dotsTriangle(
              //           color: AppColors.primaryColor,
              //           size: screenHeight * 0.04,
              //         ),
              //       );
              //     }
              //     return SignInWithButton(
              //       buttonText: AppLocalizations.of(context)!.facebookText,
              //       buttonImage: 'assets/images/facebook_logo.png',
              //       onPressed: () {
              //         context
              //             .read<AuthenticationBloc>()
              //             .add(SignInWithFacebookEvent());
              //       },
              //     );
              //   },
              // ),

              SizedBox(
                height: screenHeight * 0.05,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Form _loginForm(
      double screenHeight, double screenWidth, BuildContext context) {
    return Form(
      key: _formKey,
      child: Column(
        children: [
          TextInputField(
              controller: _email,
              icon: Icons.email_outlined,
              hintText: AppLocalizations.of(context)!.emailText,
              fillColor: const Color(0xFFFBFCFF),
              labelColor: const Color(0xFFCDCDCD),
              validator: (value) {
                final check = value != null && value != "";
                if (check) {
                  final invalid = !value
                      .trim()
                      .startsWith(RegExp(r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$'));
                  if (invalid) {
                    return AppLocalizations.of(context)!.emailError;
                  }
                }
                return null;
              },
              inputType: TextInputType.emailAddress),
          SizedBox(
            height: 3.h,
          ),
          BlocBuilder<AuthenticationBloc, AuthenticationState>(
              builder: (context, state) {
            return SizedBox(
              width: double.infinity,
              height: screenHeight * 0.064,
              child: ElevatedButton(
                onPressed: (state is SendEmailOtpState &&
                        state.status == AuthStatus.loading)
                    ? null
                    : () {
                        // //Do Validation
                        // final check = validateEmail(email: _email.text,);
                        // if (!check) return;
                        if (_formKey.currentState!.validate()) {
                          _formKey.currentState!.save();
                          context.read<AuthenticationBloc>().add(
                                SendEmailOtpEvent(
                                  email: _email.text,
                                ),
                              );
                        }
                      },
                style: ElevatedButton.styleFrom(
                  foregroundColor: Colors.white, // Text color
                  backgroundColor: AppColors.primaryColor, // Text color
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12.0),
                  ),
                ),
                child: (state is SendEmailOtpState &&
                        state.status == AuthStatus.loading)
                    ? LoadingAnimationWidget.dotsTriangle(
                        key: const Key(
                            "SendPhoneOtpState:LoadingAnimationWidget"),
                        color: AppColors.primaryColor,
                        size: screenHeight * 0.04,
                      )
                    : Text(
                        AppLocalizations.of(context)!.continueText,
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: screenHeight * 0.02 // Text color
                            ),
                      ),
              ),
            );
          }),
        ],
      ),
    );
  }

  Future<void> _launchPrivacyPolicy() async {
    const url =
        'https://www.freeprivacypolicy.com/live/e9b3fccf-54a3-4080-b778-6c0ddd550bc4';

    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }

  Future<void> _launchTermAndConditions() async {
    const url =
        'https://www.freeprivacypolicy.com/live/e9b3fccf-54a3-4080-b778-6c0ddd550bc4';
    if (await canLaunchUrl(Uri.parse(url))) {
      await launchUrl(Uri.parse(url));
    } else {
      throw 'Could not launch $url';
    }
  }
}
