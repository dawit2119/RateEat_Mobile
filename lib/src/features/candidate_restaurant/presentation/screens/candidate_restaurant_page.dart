import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/models/candid_rest.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/bloc/candidatae_event.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/bloc/candidate_bloc.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/presentation/bloc/candidate_state.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/loading_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/price_input_field.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_image_display.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';

class CandidateRestaurantPage extends StatefulWidget {
  final ImagePicker picker;
  CandidateRestaurantPage({super.key, ImagePicker? picker})
      : picker = picker ?? ImagePicker();

  @override
  State<CandidateRestaurantPage> createState() =>
      _CandidateRestaurantPageState();
}

class _CandidateRestaurantPageState extends State<CandidateRestaurantPage> {
  TextEditingController name = TextEditingController();
  TextEditingController location = TextEditingController();
  late final ImagePicker picker;
  List<File> selectedImages = [];
  bool areImagesUploaded = false;
  List<File> restaurantImages = [];
  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    name.addListener(_enableButton);
    picker = widget.picker;
  }

  void _enableButton() {
    setState(() {
      isButtonEnabled = name.text.isNotEmpty;
    });
  }

  Future<void> pickMultipleImages() async {
    final pickedFile = await picker.pickMultiImage(
      imageQuality: 20,
    );
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            selectedImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nothing is selected'),
            ),
          );
        }
      },
    );
    if (selectedImages.isNotEmpty) {
      setState(() {
        areImagesUploaded = true;
      });
    }
  }

  Future<void> pickRestaurantImages() async {
    final pickedFile = await picker.pickMultiImage(
      imageQuality: 20,
    );
    List<XFile> xfilePick = pickedFile;

    setState(
      () {
        if (xfilePick.isNotEmpty) {
          for (var i = 0; i < xfilePick.length; i++) {
            restaurantImages.add(File(xfilePick[i].path));
          }
        } else {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(
              content: Text('Nothing is selected'),
            ),
          );
        }
      },
    );
  }

  @override
  void dispose() {
    name.dispose();
    location.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      appBar: CustomAppBar(
          onTap: () {
            context.pop();
          },
          title: AppLocalizations.of(context)!.suggestRestText),
      body: SingleChildScrollView(
        child: Padding(
          padding: EdgeInsets.symmetric(
            horizontal: screenWidth * 0.06,
            vertical: screenHeight * 0.01,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              verticalPadding(height: 8),
              PriceTextField(
                hintText: AppLocalizations.of(context)!.restName,
                fillColor: const Color(0xFFFBFCFF),
                labelColor: const Color(0xFFCDCDCD),
                inputType: TextInputType.name,
                controller: name,
              ),
              verticalPadding(height: 2),
              PriceTextField(
                hintText: AppLocalizations.of(context)!.restLocation,
                fillColor: const Color(0xFFFBFCFF),
                labelColor: const Color(0xFFCDCDCD),
                inputType: TextInputType.text,
                controller: location,
              ),
              verticalPadding(height: 3),
              Text(
                AppLocalizations.of(context)!.uploadMenuImagesText,
                style: resultStyle,
              ),
              verticalPadding(height: 1),
              Center(
                child: InkWell(
                  key: CandidateRestaurantPageWidgetKeys.menuImageSelectKey,
                  onTap: () {
                    pickMultipleImages();
                  },
                  child: Container(
                    width: screenWidth * 0.94,
                    height: screenHeight * 0.13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: screenHeight * 0.002,
                          blurRadius: screenHeight * 0.007,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload,
                          color: const Color(0xFF586069),
                          size: screenHeight * 0.039,
                        ),
                        Text(
                          AppLocalizations.of(context)!.clickUploadText,
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF586069)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              verticalPadding(height: 2),
              //* Preview Selected Images
              selectedImages.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.selectedImagesText,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: SizeConfig.screenHeight * 0.018,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        SizedBox(
                          height: screenHeight *
                              0.1, // You can adjust the height as needed
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true, // Display images horizontally
                            itemCount: selectedImages.length,
                            itemBuilder: (context, index) {
                              // Create a custom widget for each selected image
                              return SelectedImageDisplay(
                                imagePath: selectedImages[index].path,
                                remoteSource: false,
                                onRemove: () {
                                  setState(() {
                                    selectedImages.removeAt(index);
                                    areImagesUploaded =
                                        selectedImages.isNotEmpty;
                                  });
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: screenWidth * 0.02,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Container(),
              verticalPadding(height: 1),
              Text(
                AppLocalizations.of(context)!.uploadRestImage,
                style: resultStyle,
              ),
              verticalPadding(height: 1),
              Center(
                child: InkWell(
                  key: CandidateRestaurantPageWidgetKeys
                      .restaurantImageSelectKey,
                  onTap: () {
                    pickRestaurantImages();
                  },
                  child: Container(
                    width: screenWidth * 0.94,
                    height: screenHeight * 0.13,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(10),
                      color: Colors.white,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          spreadRadius: screenHeight * 0.002,
                          blurRadius: screenHeight * 0.007,
                        ),
                      ],
                    ),
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(
                          Icons.cloud_upload,
                          color: const Color(0xFF586069),
                          size: screenHeight * 0.039,
                        ),
                        Text(
                          AppLocalizations.of(context)!.clickUploadText,
                          style: GoogleFonts.poppins(
                              color: const Color(0xFF586069)),
                        )
                      ],
                    ),
                  ),
                ),
              ),
              verticalPadding(height: 4),
              //* Preview Selected Images
              restaurantImages.isNotEmpty
                  ? Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.selectedImagesText,
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w500,
                            fontSize: SizeConfig.screenHeight * 0.018,
                          ),
                        ),
                        SizedBox(height: screenHeight * 0.015),
                        SizedBox(
                          height: screenHeight *
                              0.1, // You can adjust the height as needed
                          child: ListView.separated(
                            scrollDirection: Axis.horizontal,
                            shrinkWrap: true, // Display images horizontally
                            itemCount: restaurantImages.length,
                            itemBuilder: (context, index) {
                              // Create a custom widget for each selected image
                              return SelectedImageDisplay(
                                imagePath: restaurantImages[index].path,
                                remoteSource: false,
                                onRemove: () {
                                  setState(() {
                                    restaurantImages.removeAt(index);
                                  });
                                },
                              );
                            },
                            separatorBuilder: (context, index) {
                              return SizedBox(
                                width: screenWidth * 0.02,
                              );
                            },
                          ),
                        ),
                      ],
                    )
                  : Container(),
              const SizedBox(
                height: 10,
              ),
              BlocListener<CandidateBloc, CandidateState>(
                listener: (context, state) {
                  if (state is CandidateSuccess) {
                    showCustomToast(
                      context: context,
                      toastMessage: state.message,
                      toastType: ToastType.success,
                    );
                    name.clear();
                    location.clear();
                    setState(() {
                      selectedImages = [];
                      restaurantImages = [];
                    });
                    context.pop();
                  } else if (state is CandidateFailure) {
                    showCustomToast(
                      context: context,
                      toastMessage: state.error,
                      toastType: ToastType.error,
                    );
                  } else {}
                },
                child: BlocBuilder<CandidateBloc, CandidateState>(
                  builder: (context, state) {
                    if (state is CandidateLoading) {
                      return LoadingButton(
                        title: AppLocalizations.of(context)!.submittingText,
                        color: AppColors.primaryButtonColor,
                        onClick: () {},
                        loadingState: true,
                      );
                    } else {
                      return SubmitButton(
                        title: AppLocalizations.of(context)!.submitText,
                        color: AppColors.primaryButtonColor,
                        onClick: selectedImages.isNotEmpty && isButtonEnabled
                            ? () {
                                context.read<CandidateBloc>().add(
                                      SubmitCandidate(
                                        candidRest: CandidRest(
                                          name: name.text,
                                          menuImages: selectedImages,
                                          description: location.text,
                                          restImages: restaurantImages,
                                        ),
                                      ),
                                    );
                              }
                            : null,
                      );
                    }
                  },
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class CandidateRestaurantPageWidgetKeys {
  static const Key restaurantImageSelectKey =
      Key('restaurant_image_selection_button');
  static const Key menuImageSelectKey = Key('menu_image_selection_button');
}
