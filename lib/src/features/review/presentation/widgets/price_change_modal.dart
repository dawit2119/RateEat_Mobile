import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/homepage.dart';
import 'package:rateeat_mobile/src/features/map_section/map_section.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/restaurant_price_update/restaurant_price_update_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/restaurant_price_update/restaurant_price_update_event.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/restaurant_price_update/restaurant_price_update_state.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/loading_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/price_description_field.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_image_display.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

void showPriceUpdateModalSheet({
  required BuildContext context,
  required NavigatorState navigator,
  RestaurantModel? restaurant,
  ItemModel? item,
}) {
  showModalBottomSheet(
    clipBehavior: Clip.hardEdge,
    context: context,
    backgroundColor: Colors.white,
    shape: const RoundedRectangleBorder(
      borderRadius: BorderRadius.only(
        topLeft: Radius.circular(16),
        topRight: Radius.circular(16),
      ),
    ),
    isScrollControlled: true,
    builder: (BuildContext context) {
      return PriceChangeModal(
        navigator: navigator,
        restaurantModel: restaurant,
        item: item,
      );
    },
  );
}

class PriceChangeModal extends StatefulWidget {
  final NavigatorState navigator;
  final RestaurantModel? restaurantModel;
  final ItemModel? item;

  const PriceChangeModal(
      {super.key, required this.navigator, this.item, this.restaurantModel});

  @override
  State<PriceChangeModal> createState() => _PriceChangeModalState();
}

class _PriceChangeModalState extends State<PriceChangeModal> {
  final TextEditingController description = TextEditingController();
  final picker = ImagePicker();
  List<File> selectedImages = [];
  bool areImagesUploaded = false;

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

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double screenHeight = MediaQuery.of(context).size.height;
    return Container(
      color: Colors.white,
      padding: EdgeInsets.only(
          top: 20,
          bottom: MediaQuery.of(context).viewInsets.bottom,
          left: 15,
          right: 15),
      child: SingleChildScrollView(
        child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
          Text(
            AppLocalizations.of(context)!.menuSuggestText,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig.screenHeight * 0.023,
            ),
          ),
          SizedBox(height: screenHeight * 0.018),
          Text(
            AppLocalizations.of(context)!.uploadMenuImagesText,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w500,
              fontSize: SizeConfig.screenHeight * 0.023,
            ),
          ),
          SizedBox(height: screenHeight * 0.018),
          Center(
            child: InkWell(
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
                      AppLocalizations.of(context)!.uploadImagesText,
                      style:
                          GoogleFonts.poppins(color: const Color(0xFF586069)),
                    )
                  ],
                ),
              ),
            ),
          ),
          SizedBox(height: screenHeight * 0.018),

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
                                areImagesUploaded = selectedImages.isNotEmpty;
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
          PriceDescription(
            title: 'Comment',
            textEditingController: description,
          ),
          const SizedBox(
            height: 10,
          ),
          BlocListener<PriceUpdateBloc, PriceChangeState>(
            listener: (context, state) {
              if (state is PriceChangeSuccess) {
                showCustomToast(
                  context: context,
                  toastMessage: "Restaurant Menu ${state.message}",
                  toastType: ToastType.success,
                );

                //* Call to load the current Review

                //* Clear The comment area

                setState(() {
                  description.clear();
                });
                context.pop();
              } else if (state is PriceChangeError) {
                showCustomToast(
                  context: context,
                  toastMessage: "restaurant ${state.error}",
                  toastType: ToastType.error,
                );
              } else {}
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              child: BlocBuilder<PriceUpdateBloc, PriceChangeState>(
                builder: (context, state) {
                  if (state is PriceChangeLoading) {
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
                        onClick: selectedImages.isNotEmpty
                            ? () {
                                context.read<PriceUpdateBloc>().add(
                                    PriceChangeRequestEvent(
                                        priceReviewRequestModel:
                                            PriceReviewRequestModel(
                                                images: selectedImages,
                                                restaurantId: widget
                                                    .restaurantModel!.id
                                                    .toString(),
                                                description:
                                                    description.text)));
                              }
                            : null);
                  }
                },
              ),
            ),
          ),
        ]),
      ),
    );
  }
}
