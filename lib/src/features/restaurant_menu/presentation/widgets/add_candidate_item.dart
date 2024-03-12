import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';

import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../review/presentation/widgets/selected_image_display.dart';
import '../bloc/candidate_item/candidate_item_bloc.dart';
import '../bloc/candidate_item/candidate_item_event.dart';
import '../bloc/candidate_item/candidate_item_state.dart';
import 'custom_text_form_field.dart';
import "./candidate_item.dart";

class AddCandidateItem extends StatefulWidget {
  final Restaurant restaurant;
  final List<String> categories;
  final String menuId;
  const AddCandidateItem({
    super.key,
    required this.restaurant,
    required this.categories,
    required this.menuId,
  });

  @override
  AddCandidateItemState createState() => AddCandidateItemState();
}

class AddCandidateItemState extends State<AddCandidateItem> {
  late String selectedCategory;
  final picker = ImagePicker();
  final formKey = GlobalKey<FormState>();
  final candidateItemNameController = TextEditingController();
  final priceController = TextEditingController();
  final otherCategoryController = TextEditingController();
  SelecteImagesCubit selecteImagesCubit = dpLocator.get<SelecteImagesCubit>();

  @override
  void initState() {
    selectedCategory = widget.categories[0];
    super.initState();
  }

  @override
  void dispose() {
    otherCategoryController.dispose();
    priceController.dispose();
    super.dispose();
  }

  Future<void> pickMultipleImages() async {
    try {
      final pickedFile = await picker.pickMultiImage(
        imageQuality: 20,
      );
      List<XFile> xfilePick = pickedFile;
      for (var file in xfilePick) {
        if (context.mounted) {
          selecteImagesCubit.addImage(File(file.path));
        }
      }
    } catch (e) {
      if (mounted) {
        showCustomToast(
          context: context,
          toastMessage: "Image selection failed. Please try again",
          toastType: ToastType.warning,
        );
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<SelecteImagesCubit, List<File>>(
      bloc: selecteImagesCubit,
      listener: (context, selectedImagesState) {},
      builder: (context, selectedImagesState) => Form(
        key: formKey,
        child: Stack(
          fit: StackFit.expand,
          alignment: Alignment.center,
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 12),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                    child: Container(
                      height: 4,
                      width: 32,
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(10),
                        color: AppColors.grey300,
                      ),
                    ),
                  ),
                  verticalPadding(height: 3),
                  Text(
                    AppLocalizations.of(context)!.addingCandidateItemText,
                    style: semiBold18,
                  ),
                  verticalPadding(height: 2),
                  Expanded(
                    child: SingleChildScrollView(
                      physics: const AlwaysScrollableScrollPhysics(
                          parent: BouncingScrollPhysics()),
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          CustomTextFormField(
                            controller: candidateItemNameController,
                            hintText:
                                AppLocalizations.of(context)!.itemNameText,
                            fillColor: const Color(0xFFFBFCFF),
                            labelColor: const Color(0xFFCDCDCD),
                            inputType: TextInputType.text,
                            validator: (value) {
                              if (value == null ||
                                  value.isEmpty ||
                                  value.length < 3) {
                                return "";
                              }
                              return null;
                            },
                          ),
                          verticalPadding(height: 1.6),
                          CustomTextFormField(
                            hintText: AppLocalizations.of(context)!.priceText,
                            fillColor: const Color(0xFFFBFCFF),
                            labelColor: const Color(0xFFCDCDCD),
                            inputType: TextInputType.number,
                            leftIcon: Iconsax.money_24,
                            inputFormatters: [
                              LengthLimitingTextInputFormatter(5),
                              FilteringTextInputFormatter.digitsOnly,
                            ],
                            controller: priceController,
                            validator: (value) {
                              if (value == null || value.isEmpty) {
                                return "";
                              }
                              return null;
                            },
                          ),
                          verticalPadding(height: 3),
                          Text(
                            AppLocalizations.of(context)!.uploadFilesText,
                            style: semiBold16.copyWith(
                              color: AppColors.grey600,
                            ),
                          ),
                          verticalPadding(height: 1.2),
                          GestureDetector(
                            onTap: () {
                              pickMultipleImages();
                            },
                            child: Container(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 16, horizontal: 12),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(12),
                                border: Border.all(
                                  color: AppColors.grey300,
                                ),
                              ),
                              child: Center(
                                child: Column(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Iconsax.cloud,
                                      color: AppColors.grey600,
                                      size: 32,
                                    ),
                                    verticalPadding(height: 1),
                                    Text(
                                      'Upload images',
                                      style: medium16,
                                    )
                                  ],
                                ),
                              ),
                            ),
                          ),
                          verticalPadding(height: 1),
                          selectedImagesState.isNotEmpty
                              ? Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Text(
                                      AppLocalizations.of(context)!
                                          .selectedImagesText,
                                      style: GoogleFonts.poppins(
                                        fontWeight: FontWeight.w500,
                                        fontSize:
                                            SizeConfig.screenHeight * 0.018,
                                      ),
                                    ),
                                    verticalPadding(height: 1.4),
                                    SizedBox(
                                      width: 90.w,
                                      height: 10.h,
                                      child: ListView.separated(
                                        scrollDirection: Axis.horizontal,
                                        shrinkWrap:
                                            true, // Display images horizontally
                                        itemCount: selectedImagesState.length,
                                        itemBuilder: (context, index) {
                                          // Create a custom widget for each selected image
                                          return SelectedImageDisplay(
                                            imagePath:
                                                selectedImagesState[index].path,
                                            remoteSource: false,
                                            onRemove: () {
                                              selecteImagesCubit.removeImage(
                                                  index: index);
                                            },
                                          );
                                        },
                                        separatorBuilder: (context, index) =>
                                            horizontalPadding(width: 1),
                                      ),
                                    ),
                                  ],
                                )
                              : Container(),
                          verticalPadding(height: 2),
                          // Select food category
                          Container(
                            padding: EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: selectedCategory == "Other" ? 5 : 0.0,
                            ),
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(8.0),
                            ),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "Category",
                                      style: regular16,
                                    ),
                                    horizontalPadding(width: 2),
                                    Flexible(
                                      child: // Drop Down
                                          DropdownButton<String>(
                                        key: const Key("Category Drop Down"),
                                        value: selectedCategory,
                                        isExpanded: true,
                                        items: widget.categories
                                            .map((String value) {
                                          debugPrint(
                                              "The categories are ${widget.categories.toString()}");
                                          return DropdownMenuItem<String>(
                                            value: value,
                                            child: Text(
                                              value,
                                              style: medium16,
                                            ),
                                          );
                                        }).toList(),
                                        onChanged: (value) {
                                          if (value != null) {
                                            setState(() {
                                              selectedCategory = value;
                                            });
                                          }
                                        },
                                      ),
                                    ),
                                  ],
                                ),
                                verticalPadding(height: 1),
                                if (selectedCategory ==
                                    AppLocalizations.of(context)!.otherText)
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      CustomTextFormField(
                                        width: 66.w,
                                        hintText: AppLocalizations.of(context)!
                                            .otherText,
                                        fillColor: const Color(0xFFFBFCFF),
                                        labelColor: const Color(0xFFCDCDCD),
                                        controller: otherCategoryController,
                                      ),
                                    ],
                                  )
                              ],
                            ),
                          ),
                          verticalPadding(height: 2),
                          // Form submit button
                        ],
                      ),
                    ),
                  ),
                  verticalPadding(height: 10),
                ],
              ),
            ),
            Positioned(
              bottom: 24,
              child: SizedBox(
                width: 85.w,
                child: BlocConsumer<CandidateItemBloc, CandidateItemState>(
                  listener: (context, state) {
                    if (state is CandidateItemAdded) {
                      showCustomToast(
                        context: context,
                        toastMessage: AppLocalizations.of(context)!
                            .candidateItemSuccessText,
                        toastType: ToastType.success,
                      );
                      //* Call to load the current Review
                      //* Clear The comment area
                      otherCategoryController.clear();
                      context.read<CandidateItemCubit>().changeIndex(1);
                    } else if (state is CandidateItemAddFailed) {
                      showCustomToast(
                        context: context,
                        toastMessage: state.message,
                        toastType: ToastType.error,
                      );
                    } else {}
                  },
                  builder: (context, state) {
                    return SubmitButton(
                      isLoading: state is AddCandidateItemLoading,
                      title: AppLocalizations.of(context)!.submitText,
                      color: AppColors.primaryButtonColor,
                      onClick: () {
                        if (formKey.currentState!.validate()) {
                          final categoryName = selectedCategory == "Other"
                              ? (otherCategoryController.text.isEmpty
                                  ? "Other"
                                  : otherCategoryController.text)
                              : selectedCategory;
                          context.read<CandidateItemBloc>().add(
                                AddCandidateItemEvent(
                                  menuId: widget.menuId,
                                  categoryName: categoryName,
                                  itemName: candidateItemNameController.text,
                                  price: double.parse(priceController.text),
                                  itemImages: selectedImagesState,
                                ),
                              );
                        }
                      },
                    );
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class SelecteImagesCubit extends Cubit<List<File>> {
  SelecteImagesCubit() : super([]);

  void addImage(File image) {
    state.add(image);
    emit(List.from(state));
  }

  void removeImage({required int index}) {
    state.removeAt(index);
    emit(List.from(state));
  }
}
