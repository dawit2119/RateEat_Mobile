import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../user_profile/user_profile.dart';
import '../widgets/gender_selection.dart';

// ignore: must_be_immutable
class ProfileCreatePage extends StatefulWidget {
  ProfileCreatePage({super.key, this.previousRouteInfo = const {}});

  Map<String, dynamic> previousRouteInfo;

  @override
  State<ProfileCreatePage> createState() => _ProfileCreatePageState();
}

class _ProfileCreatePageState extends State<ProfileCreatePage> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController _firstName = TextEditingController();

  final TextEditingController _lastName = TextEditingController();

  final TextEditingController _email = TextEditingController();

  final TextEditingController _phone = TextEditingController();

  String countryCode = "251";

  String? imageUrl;

  String? birthDate;

  String? gender;

  @override
  void initState() {
    final user = context.read<UserDataCubit>().state;
    setUser(user);
    super.initState();
  }

  void setUser(UserModel user) {
    if (user.firstName != null) {
      _firstName.text = user.firstName!;
    }
    if (user.lastName != null) {
      _lastName.text = user.lastName!;
    }
    if (user.email != null) {
      _email.text = user.email!;
    }
    if (user.phoneNumber != null) {
      _phone.text = user.phoneNumber!.substring(4);
    }
  }

  @override
  Widget build(BuildContext context) {
    final user = context.read<UserDataCubit>().state;

    return Scaffold(
      body: SingleChildScrollView(
        child: BlocConsumer<AuthenticationBloc, AuthenticationState>(
          listener: (context, state) {
            if (state is SignUpState && state.status == AuthStatus.loaded) {
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
                    // context.pop();
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
                    // context.pop();
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
                }
              } else {
                context.goNamed(AppRoutes.home);
              }
            } else if (state is SignUpState &&
                state.status == AuthStatus.error) {
              showCustomToast(
                context: context,
                toastMessage: state.errorMessage!,
                toastType: ToastType.error,
              );
            }
          },
          builder: (context, state) {
            return Padding(
                padding: EdgeInsets.symmetric(horizontal: 7.6.w),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    SizedBox(
                      height: 4.6.h,
                    ),
                    Text(
                      AppLocalizations.of(context)!.createProfileText,
                      style: GoogleFonts.poppins(
                        fontSize: 4.h,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    SizedBox(
                      height: 2.2.h,
                    ),
                    //* Image Upload
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        //* Profile image selector
                        SizedBox(
                          width: 28.w,
                          child: ProfileImage(selectedImage: (selected) {
                            imageUrl = selected;
                          }),
                        ),
                        Expanded(
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            mainAxisAlignment: MainAxisAlignment.start,
                            children: [
                              RichText(
                                text: TextSpan(
                                  style: GoogleFonts.poppins(
                                    color: const Color(
                                        0xFF959DA5), // Gray color for regular text
                                    fontSize: 1.5.h,
                                  ),
                                  children: [
                                    TextSpan(
                                      text: AppLocalizations.of(context)!
                                          .uploadPhotoText,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.bold,
                                        color: Colors.black,
                                      ),
                                    ),
                                    TextSpan(
                                      text:
                                          "(${AppLocalizations.of(context)!.optionalText})",
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                              SizedBox(height: .5.h),
                              Text(
                                AppLocalizations.of(context)!
                                    .createProfileMessageText,
                                style: GoogleFonts.poppins(
                                  color: const Color(0xFF959DA5),
                                  fontSize: 1.5.h,
                                ),
                              ),
                            ],
                          ),
                        )
                      ],
                    ),

                    SizedBox(
                      height: 3.5.h,
                    ),
                    //* Input Form Field
                    Form(
                      key: _formKey,
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          //* First Name
                          textInputField(
                            screenHeight: 100.h,
                            screenWidth: 100.w,
                            hintText:
                                AppLocalizations.of(context)!.firstNameText,
                            icon: Icons.person_outlined,
                            fillColor: const Color(0xFFFBFCFF),
                            labelColor: const Color(0xFFCDCDCD),
                            controller: _firstName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .emptyNameText;
                              } else if (value.length < 3) {
                                return AppLocalizations.of(context)!
                                    .invalidNameText;
                              }
                              return null; // Validation passed
                            },
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          //* LastName
                          textInputField(
                            screenHeight: 100.h,
                            screenWidth: 100.w,
                            hintText:
                                AppLocalizations.of(context)!.lastNameText,
                            icon: Icons.person_outlined,
                            fillColor: const Color(0xFFFBFCFF),
                            labelColor: const Color(0xFFCDCDCD),
                            controller: _lastName,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return AppLocalizations.of(context)!
                                    .emptyNameText;
                              } else if (value.length < 3) {
                                return AppLocalizations.of(context)!
                                    .invalidNameText;
                              }
                              return null; // Validation passed
                            },
                          ),
                          SizedBox(
                            height: 3.h,
                          ),
                          //* Email
                          textInputField(
                              screenHeight: 100.h,
                              screenWidth: 100.w,
                              hintText: AppLocalizations.of(context)!.emailText,
                              icon: Icons.email_outlined,
                              readOnly: user.email != null && user.email != "",
                              enabled: user.email == null || user.email == "",
                              fillColor: const Color(0xFFFBFCFF),
                              labelColor: const Color(0xFFCDCDCD),
                              controller: _email,
                              validator: (value) {
                                final check = value != null && value != "";
                                if (check) {
                                  final invalid = !value.startsWith(RegExp(
                                      r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$'));
                                  if (invalid) {
                                    return AppLocalizations.of(context)!
                                        .invalidEmailText;
                                  }
                                }
                                return null; // Validation passed
                              },
                              inputType: TextInputType.emailAddress),
                          SizedBox(
                            height: 3.h,
                          ),
                          //* Phone Number
                          PhoneNumberField(
                            controller: _phone,
                            autoValidate: true,
                            enabled: user.phoneNumber == null ||
                                user.phoneNumber == "",
                            readOnly: user.phoneNumber != null &&
                                user.phoneNumber != "",
                            onCountryChanged: (country) {
                              countryCode = country!.dialCode;
                            },
                          ),
                          //*  Gender
                          Text(
                            AppLocalizations.of(context)!.genderText,
                            style: GoogleFonts.poppins(
                              fontSize: 2.h,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          //* Select Gender
                          GenderSelection(onGenderSelected: (selected) {
                            gender = selected;
                          }),
                          SizedBox(
                            height: 1.h,
                          ),
                          //*  Date of Birth
                          Text(
                            AppLocalizations.of(context)!.dateOfBirthText,
                            style: GoogleFonts.poppins(
                              fontSize: 2.h,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                          SizedBox(
                            height: 2.h,
                          ),
                          //* Birth Date
                          BirthDateInput(selectedDate: (selected) {
                            birthDate = selected;
                          }),

                          SizedBox(
                            height: 3.h,
                          ),
                          //* Continue Button
                          BlocBuilder<AuthenticationBloc, AuthenticationState>(
                            builder: (context, state) {
                              return SizedBox(
                                width: double.infinity,
                                height: 6.4.h,
                                child: ElevatedButton(
                                  onPressed: (state is SignUpState &&
                                          state.status == AuthStatus.loading)
                                      ? null
                                      : () {
                                          //Do Validation
                                          final check = validateAndShowToast(
                                            context: context,
                                            phone: _phone.text,
                                            gender: gender,
                                          );
                                          if (!check) return;

                                          if (_formKey.currentState!
                                              .validate()) {
                                            _formKey.currentState!.save();
                                            final signUpData = UserModel(
                                              id: user.id ?? "",
                                              firstName: _firstName.text,
                                              lastName: _lastName.text,
                                              image: imageUrl,
                                              phoneNumber: _phone.text != ""
                                                  ? "+$countryCode${_phone.text.trim()}"
                                                  : "",
                                              email: _email.text,
                                              gender: gender,
                                              dateOfBirth: birthDate,
                                            );

                                            context
                                                .read<AuthenticationBloc>()
                                                .add(
                                                  SignUpEvent(user: signUpData),
                                                );
                                          }
                                        },
                                  style: ElevatedButton.styleFrom(
                                    foregroundColor: Colors.white, // Text color
                                    backgroundColor:
                                        const Color(0xFFFF3008), // Text color
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12.0),
                                    ),
                                  ),
                                  child: (state is SignUpState &&
                                          state.status == AuthStatus.loading)
                                      ? LoadingAnimationWidget.dotsTriangle(
                                          color: AppColors.primaryColor,
                                          size: 4.h,
                                        )
                                      : Text(
                                          AppLocalizations.of(context)!
                                              .continueText,
                                          style: GoogleFonts.poppins(
                                              color: Colors.white,
                                              fontSize: 2.h),
                                        ),
                                ),
                              );
                            },
                          ),
                        ],
                      ),
                    )
                  ],
                ));
          },
        ),
      ),
    );
  }

  Widget textInputField(
      {required double screenHeight,
      required double screenWidth,
      required String hintText,
      required IconData icon,
      required Color fillColor,
      required Color labelColor,
      required TextEditingController controller,
      required String? Function(String?)? validator,
      bool readOnly = false,
      bool enabled = true,
      TextInputType? inputType}) {
    return TextFormField(
      readOnly: readOnly,
      enabled: enabled,
      controller: controller,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      decoration: InputDecoration(
        contentPadding: const EdgeInsets.all(5),
        hintText: hintText,
        filled: true,
        fillColor: fillColor,
        labelStyle: TextStyle(
          color: labelColor,
          fontSize: screenHeight * 0.014,
        ),
        enabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: labelColor,
            width: screenHeight * 0.001,
          ),
        ),
        disabledBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(5.0),
          borderSide: BorderSide(
            color: labelColor,
            width: screenHeight * 0.001,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            color: Colors.black,
            width: screenHeight * 0.001,
          ),
          borderRadius: BorderRadius.circular(8.0),
        ),
        errorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color(0xFFFF3008),
          ),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderRadius: BorderRadius.circular(8.0),
          borderSide: const BorderSide(
            color: Color(0xFFFF3008),
          ),
        ),
        prefixIcon: Padding(
          padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
          child: Icon(
            icon,
            color: const Color(0xFF9F9F9F),
          ),
        ),
      ),
      validator: validator ?? (value) => null,
    );
  }
}

class UserDataCubit extends Cubit<UserModel> {
  UserDataCubit() : super(UserModel());
  void setUserData(UserModel user) {
    emit(user);
  }
}
