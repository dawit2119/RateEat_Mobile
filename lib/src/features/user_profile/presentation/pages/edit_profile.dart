import 'package:cached_network_image/cached_network_image.dart';
import 'package:dotted_border/dotted_border.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/authentication/presentation/widgets/gender_selection.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/username_availability/username_availability_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../core/utils/image_uploader.dart';
import '../../../user_profile/user_profile.dart';

// ignore: must_be_immutable
class EditProfilePage extends StatefulWidget {
  final UserModel userModel;
  const EditProfilePage({
    super.key,
    required this.userModel,
  });

  @override
  State<EditProfilePage> createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  final formKey = GlobalKey<FormState>();
  final TextEditingController userName = TextEditingController();
  final TextEditingController firstName = TextEditingController();
  final TextEditingController lastName = TextEditingController();
  final TextEditingController email = TextEditingController();
  final TextEditingController phone = TextEditingController();
  Map<String, dynamic> updateData = {};
  String countryCode = "+251";
  String? imageUrl;
  String? birthDate;
  String? gender;

  @override
  void initState() {
    context.read<EditProfileBloc>().add(ResetToInitialEvent());
    userName.text = widget.userModel.userName ?? "";
    firstName.text = widget.userModel.firstName ?? "";
    lastName.text = widget.userModel.lastName ?? "";
    email.text = widget.userModel.email ?? "";
    gender = widget.userModel.gender;
    phone.text = widget.userModel.phoneNumber != null &&
            widget.userModel.phoneNumber != ""
        ? getPhoneNumber(widget.userModel.phoneNumber!)
        : "";
    birthDate = widget.userModel.dateOfBirth;
    super.initState();
  }

  String getPhoneNumber(String phoneNumber) {
    if (phoneNumber.startsWith("+251")) {
      return phoneNumber.substring(4);
    }
    return phoneNumber.substring(1);
  }

  Future _changeProfileImage() async {
    await showModalBottomSheet(
      context: context,
      builder: (context) {
        return SizedBox(
          height: MediaQuery.of(context).size.height * 0.2,
          child: Column(
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt),
                title: Text(AppLocalizations.of(context)!.cameraText),
                onTap: () async {
                  final pickedFile = await ImageUploader.getImage(
                    source: ImageSource.camera,
                  );
                  setState(() {
                    imageUrl = pickedFile!.path;
                  });
                  if (context.mounted) {
                    context.pop();
                  }
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library),
                title: Text(AppLocalizations.of(context)!.galleryText),
                onTap: () async {
                  final pickedFile = await ImageUploader.getImage(
                    source: ImageSource.gallery,
                  );
                  setState(() {
                    imageUrl = pickedFile!.path;
                  });
                  if (context.mounted) {
                    context.pop();
                  }
                },
              ),
            ],
          ),
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Text(
          AppLocalizations.of(context)!.editProfileText,
          style: semiBold18,
        ),
        centerTitle: true,
        toolbarHeight: 7.h,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 1.5.h, left: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 5.h,
                width: 5.h,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [...elevation_4],
                    shape: BoxShape.circle),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.pop();
                  },
                  child: Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 2.4.h,
                      semanticLabel: "Back",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocConsumer<EditProfileBloc, EditProfileState>(
        listener: (context, state) {},
        builder: (context, state) {
          return SingleChildScrollView(
            child: Container(
              padding: EdgeInsets.symmetric(
                horizontal: 7.6.w,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    height: 2.h,
                  ),
                  //* Image Upload
                  widget.userModel.image != null && imageUrl == null
                      ? Row(
                          children: [
                            Stack(
                              //fit: StackFit.loose,
                              clipBehavior: Clip.none,
                              alignment: Alignment.bottomCenter,
                              children: [
                                DottedBorder(
                                  options: CircularDottedBorderOptions(
                                    color: AppColors.primaryColor,
                                    strokeWidth:
                                        2, // a bit thicker looks premium
                                    dashPattern: const [
                                      3,
                                      4
                                    ], // small dash + small gap (cleaner)
                                    padding: const EdgeInsets.all(6),
                                    // If your version supports it, prefer rounded caps:
                                    // strokeCap: StrokeCap.round,
                                  ),
                                  child: Container(
                                    height: 9.4.h,
                                    width: 9.4.h,
                                    decoration: const BoxDecoration(
                                      shape: BoxShape.circle,
                                    ),
                                    child: ClipRRect(
                                      borderRadius: BorderRadius.circular(100),
                                      child: CachedNetworkImage(
                                        imageUrl: widget.userModel.image!,
                                        fit: BoxFit.cover,
                                        placeholder: (context, url) =>
                                            Shimmer.fromColors(
                                          baseColor: Colors.grey[300]!,
                                          highlightColor: Colors.grey[100]!,
                                          child: Container(
                                            color: Colors.white,
                                          ),
                                        ),
                                        errorWidget: (context, url, error) =>
                                            const Icon(
                                          Icons.person,
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                Positioned(
                                  bottom: -20,
                                  child: TextButton(
                                    onPressed: _changeProfileImage,
                                    child: Container(
                                      height: 35,
                                      width: 35,
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: AppColors.secondaryColor,
                                        border: Border.all(
                                          color: Colors.white,
                                          width: 4,
                                        ),
                                      ),
                                      child: Center(
                                        child: SvgPicture.asset(
                                          "assets/icons/edit_icon.svg",
                                          height: 18.sp,
                                          width: 18.sp,
                                          colorFilter: const ColorFilter.mode(
                                            Colors.white,
                                            BlendMode.srcIn,
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(width: 5.w),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF959DA5),
                                        fontSize: 1.5.h,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .uploadPPtext,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .optionalText,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: .5.h),
                                  Text(
                                    AppLocalizations.of(context)!.proText,
                                    style: GoogleFonts.poppins(
                                      color: const Color(0xFF959DA5),
                                      fontSize: 1.5.h,
                                    ),
                                  ),
                                ],
                              ),
                            )
                          ],
                        )
                      : Row(
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            SizedBox(
                              height: 12.h,
                              width: 28.w,
                              child: ProfileImage(
                                imageUrl: imageUrl,
                                selectedImage: (selected) {
                                  imageUrl = selected;
                                },
                              ),
                            ),
                            Expanded(
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                mainAxisAlignment: MainAxisAlignment.start,
                                children: [
                                  RichText(
                                    text: TextSpan(
                                      style: GoogleFonts.poppins(
                                        color: const Color(0xFF959DA5),
                                        fontSize: 1.5.h,
                                      ),
                                      children: [
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .uploadPPtext,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.bold,
                                            color: Colors.black,
                                          ),
                                        ),
                                        TextSpan(
                                          text: AppLocalizations.of(context)!
                                              .optionalText,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w600,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                  SizedBox(height: 5.h),
                                  Text(
                                    AppLocalizations.of(context)!.proText,
                                    style: TextStyle(
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
                  //* Input Form fields
                  Form(
                    key: formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        //* User Name
                        textInputField(
                          screenHeight: 100.h,
                          screenWidth: 100.w,
                          hintText:
                              userName.text != "" ? userName.text : 'user name',
                          icon: Icons.person_outlined,
                          fillColor: const Color(0xFFFBFCFF),
                          labelColor: const Color(0xFFCDCDCD),
                          controller: userName,
                          onChanged: (query) {
                            final name = query.trim();
                            if (name.length < 4) {
                              context
                                  .read<UsernameAvailabilityBloc>()
                                  .add(ResetUserNameToInitial());
                              return;
                            }
                            if (name == widget.userModel.userName) {
                              context
                                  .read<UsernameAvailabilityBloc>()
                                  .add(ResetUserNameToInitial());
                              return;
                            }
                            context
                                .read<UsernameAvailabilityBloc>()
                                .add(CheckUserNameAvailability(userName: name));
                          },
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .userNameErrorText;
                            } else if (value.trim().length < 4) {
                              return AppLocalizations.of(context)!
                                  .invalidUserNameText;
                            }
                            return null;
                          },
                        ),
                        // SizedBox(
                        //   height: 1.h,
                        // ),
                        BlocBuilder<UsernameAvailabilityBloc,
                            UsernameAvailabilityState>(
                          builder: (context, state) {
                            if (userName.text.length >= 4) {
                              return Text(
                                '${(state is UsernameAvailabilitySuccess) ? userName.text : ''} ${state.status}.',
                                style: GoogleFonts.poppins(
                                  color: (state is UsernameAvailabilitySuccess)
                                      ? Colors.green
                                      : const Color(0xFFFF3008),
                                  fontSize: 1.4.h,
                                  fontWeight: FontWeight.w600,
                                ),
                              );
                            }
                            return Container();
                          },
                        ),

                        SizedBox(
                          height: 1.h,
                        ),

                        //* First Name
                        textInputField(
                          screenHeight: 100.h,
                          screenWidth: 100.w,
                          hintText: AppLocalizations.of(context)!.firstText,
                          icon: Icons.person_outlined,
                          fillColor: const Color(0xFFFBFCFF),
                          labelColor: const Color(0xFFCDCDCD),
                          controller: firstName,
                          validator: (value) {
                            if (value == null || value.isEmpty) {
                              return AppLocalizations.of(context)!
                                  .nameErrorText;
                            } else if (value.length < 3) {
                              return AppLocalizations.of(context)!
                                  .shortNameText;
                            }
                            return null;
                          },
                        ),
                        SizedBox(
                          height: 3.h,
                        ),

                        //* LastName
                        textInputField(
                          screenHeight: 100.h,
                          screenWidth: 100.w,
                          hintText: AppLocalizations.of(context)!.lastText,
                          icon: Icons.person_outlined,
                          fillColor: const Color(0xFFFBFCFF),
                          labelColor: const Color(0xFFCDCDCD),
                          controller: lastName,
                          validator: null,
                        ),
                        SizedBox(
                          height: 3.h,
                        ),
                        //* Email
                        textInputField(
                            key: const Key("Edit Profile Email Field"),
                            screenHeight: 100.h,
                            screenWidth: 100.w,
                            hintText: AppLocalizations.of(context)!.emailText,
                            icon: Icons.email_outlined,
                            fillColor: const Color(0xFFFBFCFF),
                            labelColor: const Color(0xFFCDCDCD),
                            controller: email,
                            readOnly: widget.userModel.email != "",
                            enabled: widget.userModel.email == "",
                            validator: (value) {
                              final check = value != null && value != "";
                              if (check) {
                                final invalid = !value.trim().startsWith(RegExp(
                                    r'^[a-zA-Z0-9+_.-]+@[a-zA-Z0-9.-]+$'));
                                if (invalid) {
                                  return AppLocalizations.of(context)!
                                      .emailError;
                                }
                              }
                              return null;
                            },
                            inputType: TextInputType.emailAddress),
                        // SizedBox(
                        //   height: 3.h,
                        // ),
                        //* Phone Number
                        // PhoneNumberField(
                        //   controller: phone,
                        //   autoValidate: true,
                        //   readOnly: widget.userModel.phoneNumber != "",
                        //   enabled: widget.userModel.phoneNumber == "",
                        //   onCountryChanged: (country) {
                        //     countryCode = country!.dialCode;
                        //   },
                        // ),
                        SizedBox(
                          height: 2.h,
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
                        GenderSelection(
                          getGender: gender,
                          onGenderSelected: (selected) {
                            gender = selected;
                          },
                        ),
                        SizedBox(
                          height: 2.h,
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
                        BirthDateInput(
                          birthDay: widget.userModel.dateOfBirth != null
                              ? DateFormat('yyyy-MM-dd').format(
                                  DateTime.parse(widget.userModel.dateOfBirth!),
                                )
                              : '',
                          selectedDate: (selected) {
                            setState(() {
                              birthDate = selected;
                            });
                          },
                        ),

                        SizedBox(
                          height: 2.h,
                        ),
                        //* Continue Button
                        BlocConsumer<AuthenticationBloc, AuthenticationState>(
                          listener: (context, otPState) {
                            if (otPState is SendEditPhoneOtpState &&
                                otPState.status == AuthStatus.loaded) {
                              context.pushNamed(
                                AppRoutes.verifyPhone,
                                extra: {'user': updateData},
                              );
                            } else if (otPState is SendEditPhoneOtpState &&
                                otPState.status == AuthStatus.error) {
                              showCustomToast(
                                context: context,
                                toastMessage: otPState.errorMessage ??
                                    AppLocalizations.of(context)!
                                        .phoneOtpNotSentText,
                                toastType: ToastType.error,
                              );
                            } else if (otPState is SendEditEmailOtpState &&
                                otPState.status == AuthStatus.loaded) {
                              context.pushNamed(
                                AppRoutes.verifyEmail,
                                extra: {'user': updateData},
                              );
                            } else if (otPState is SendEditEmailOtpState &&
                                otPState.status == AuthStatus.error) {
                              showCustomToast(
                                context: context,
                                toastMessage: otPState.errorMessage ??
                                    AppLocalizations.of(context)!
                                        .emailOtpNotSentText,
                                toastType: ToastType.error,
                              );
                            }
                          },
                          builder: (context, otPState) {
                            return BlocConsumer<EditProfileBloc,
                                EditProfileState>(
                              listener: (context, state) {
                                if (state is EditProfileLoaded) {
                                  showCustomToast(
                                    context: context,
                                    toastMessage: AppLocalizations.of(context)!
                                        .profileUpdatedText,
                                    toastType: ToastType.success,
                                  );
                                  context.read<GetUserProfileBloc>().add(
                                        GetUserProfileEvent(
                                          userId: widget.userModel.id!,
                                        ),
                                      );
                                  context.pop();
                                } else if (state is EditProfileError) {
                                  showCustomToast(
                                    context: context,
                                    toastMessage: AppLocalizations.of(context)!
                                        .profileUpdateFailed,
                                    toastType: ToastType.error,
                                  );
                                  context.pop();
                                }
                              },
                              builder: (context, state) {
                                return SizedBox(
                                  width: double.infinity,
                                  height: 6.4.h,
                                  child: ElevatedButton(
                                    onPressed: ((state is EditProfileLoading) ||
                                            (otPState
                                                    is SendEditEmailOtpState &&
                                                otPState.status ==
                                                    AuthStatus.loading) ||
                                            (otPState is SendPhoneOtpState &&
                                                otPState.status ==
                                                    AuthStatus.loading))
                                        ? null
                                        : () {
                                            if (formKey.currentState!
                                                .validate()) {
                                              if (!validateAndShowToast(
                                                  context: context,
                                                  gender: gender)) {
                                                return;
                                              }
                                              final check = context
                                                  .read<
                                                      UsernameAvailabilityBloc>()
                                                  .state;

                                              if (widget.userModel.userName !=
                                                      userName.text &&
                                                  check
                                                      is! UsernameAvailabilitySuccess) {
                                                showCustomToast(
                                                  context: context,
                                                  toastMessage:
                                                      "User name is already taken. Try another one",
                                                  toastType: ToastType.warning,
                                                );
                                                return;
                                              }
                                              formKey.currentState!.save();
                                              var user = widget.userModel;

                                              if (user.userName !=
                                                  userName.text) {
                                                updateData['username'] =
                                                    userName.text.trim();
                                              }

                                              if (user.firstName !=
                                                  firstName.text) {
                                                updateData['first_name'] =
                                                    firstName.text;
                                              }
                                              if (user.lastName !=
                                                  lastName.text) {
                                                updateData['last_name'] =
                                                    lastName.text;
                                              }
                                              if (user.email != email.text) {
                                                updateData['email'] =
                                                    email.text;
                                              }
                                              if (user.phoneNumber !=
                                                      '$countryCode${phone.text}' &&
                                                  phone.text.length == 9) {
                                                updateData['phone_number'] =
                                                    '$countryCode${phone.text.trim()}';
                                              }
                                              if (user.image != imageUrl &&
                                                  imageUrl != null) {
                                                updateData['image'] = imageUrl;
                                              }

                                              if (user.dateOfBirth !=
                                                  birthDate) {
                                                updateData['date_of_birth'] =
                                                    birthDate;
                                              }
                                              if (user.gender != gender) {
                                                updateData['gender'] = gender;
                                              }

                                              //* Update data based on User
                                              if (updateData['email'] != null) {
                                                context
                                                    .read<AuthenticationBloc>()
                                                    .add(
                                                      SendEditEmailOtpEvent(
                                                        email:
                                                            updateData['email'],
                                                      ),
                                                    );
                                              } else if (updateData[
                                                      'phone_number'] !=
                                                  null) {
                                                context
                                                    .read<AuthenticationBloc>()
                                                    .add(
                                                      SendEditPhoneOtpEvent(
                                                        phoneNumber:
                                                            "${updateData['phone_number']}",
                                                      ),
                                                    );
                                              } else if (updateData
                                                  .isNotEmpty) {
                                                context
                                                    .read<EditProfileBloc>()
                                                    .add(
                                                      SubmitEditProfileEvent(
                                                        user: widget.userModel,
                                                        updateData: updateData,
                                                      ),
                                                    );
                                              }
                                            }
                                          },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor:
                                          Colors.white, // Text color
                                      backgroundColor:
                                          const Color(0xFFFF3008), // Text color
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    child: ((state is EditProfileLoading) ||
                                            (otPState
                                                    is SendEditEmailOtpState &&
                                                otPState.status ==
                                                    AuthStatus.loading) ||
                                            (otPState
                                                    is SendEditPhoneOtpState &&
                                                otPState.status ==
                                                    AuthStatus.loading))
                                        ? LoadingAnimationWidget.dotsTriangle(
                                            color: Colors.white,
                                            size: 4.h,
                                          )
                                        : Text(
                                            AppLocalizations.of(context)!
                                                .updateText,
                                            style: GoogleFonts.poppins(
                                                color: Colors.white,
                                                fontSize: 2.h),
                                          ),
                                  ),
                                );
                              },
                            );
                          },
                        ),
                      ],
                    ),
                  ),
                  SizedBox(
                    height: 2.h,
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  Widget textInputField(
      {required double screenHeight,
      required double screenWidth,
      required String hintText,
      required IconData icon,
      Key? key,
      required Color fillColor,
      required Color labelColor,
      required TextEditingController controller,
      required String? Function(String?)? validator,
      Function(String)? onChanged,
      bool readOnly = false,
      bool enabled = true,
      TextInputType? inputType}) {
    return TextFormField(
      key: key,
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
      onChanged: onChanged,
    );
  }

  bool validateAndShowToast({
    required BuildContext context,
    String? gender,
  }) {
    if (gender == null || gender.isEmpty) {
      showCustomToast(
        context: context,
        toastMessage: "Please select gender",
        toastType: ToastType.warning,
      );
      return false;
    }
    return true;
  }
}
