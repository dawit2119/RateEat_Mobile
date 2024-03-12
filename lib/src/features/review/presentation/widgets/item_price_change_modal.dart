import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';

import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/homepage/homepage.dart';
import 'package:rateeat_mobile/src/features/map_section/map_section.dart';
import 'package:rateeat_mobile/src/features/review/data/models/price_item_review_request_model.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/item_price_update/item_price_update_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/item_price_update/item_price_update_event.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/price_update/item_price_update/item_price_update_state.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/loading_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/price_description_field.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/price_input_field.dart';

import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';

import 'package:responsive_sizer/responsive_sizer.dart';

void showItemPriceUpdateModalSheet({
  required BuildContext context,
  required NavigatorState navigator,
  RestaurantModel? restaurant,
  ItemModel? item,
}) {
  showModalBottomSheet(
    clipBehavior: Clip.hardEdge,
    isDismissible: true,
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
      return ItemPriceChangeModal(
        navigator: navigator,
        restaurantModel: restaurant,
        item: item,
      );
    },
  );
}

class ItemPriceChangeModal extends StatefulWidget {
  final NavigatorState navigator;
  final RestaurantModel? restaurantModel;
  final ItemModel? item;

  const ItemPriceChangeModal(
      {super.key, required this.navigator, this.item, this.restaurantModel});

  @override
  State<ItemPriceChangeModal> createState() => _ItemPriceChangeModalState();
}

class _ItemPriceChangeModalState extends State<ItemPriceChangeModal> {
  final TextEditingController description = TextEditingController();
  final TextEditingController price = TextEditingController();

  bool isButtonEnabled = false;

  @override
  void initState() {
    super.initState();
    price.addListener(_enableButton);
  }

  void _enableButton() {
    setState(() {
      isButtonEnabled = price.text.isNotEmpty;
    });
  }

  @override
  void dispose() {
    price.removeListener(_enableButton);
    price.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
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
            AppLocalizations.of(context)!.suggestPriceText,
            style: GoogleFonts.poppins(
              fontWeight: FontWeight.w600,
              fontSize: SizeConfig.screenHeight * 0.023,
            ),
          ),
          SizedBox(height: screenHeight * 0.018),
          const SizedBox(
            height: 10,
          ),
          PriceTextField(
            hintText: AppLocalizations.of(context)!.newPriceText,
            fillColor: const Color(0xFFFBFCFF),
            labelColor: const Color(0xFFCDCDCD),
            inputType: TextInputType.number,
            controller: price,
          ),
          const SizedBox(
            height: 10,
          ),
          PriceDescription(
            title: AppLocalizations.of(context)!.commentsText,
            textEditingController: description,
          ),
          const SizedBox(
            height: 10,
          ),
          BlocListener<PriceItemUpdateBloc, ItemPriceChangeState>(
            listener: (context, state) {
              if (state is ItemPriceChangeSuccess) {
                showCustomToast(
                  context: context,
                  toastMessage: "Item price ${state.message}",
                  toastType: ToastType.success,
                );

                //* Call to load the current Review

                //* Clear The comment area

                setState(() {
                  price.clear();
                  description.clear();
                });
                context.pop();
              } else if (state is ItemPriceChangeError) {
                showCustomToast(
                  context: context,
                  toastMessage: "restaurant ${state.error}",
                  toastType: ToastType.error,
                );
              } else {}
            },
            child: Padding(
              padding: EdgeInsets.symmetric(vertical: 1.5.h),
              child: BlocBuilder<PriceItemUpdateBloc, ItemPriceChangeState>(
                builder: (context, state) {
                  if (state is ItemPriceChangeLoading) {
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
                        onClick: isButtonEnabled
                            ? () {
                                context.read<PriceItemUpdateBloc>().add(
                                    ItemPriceChangeRequestEvent(
                                        priceItemReviewRequestModel:
                                            PriceItemReviewRequestModel(
                                                itemId: widget.item!.itemId
                                                    .toString(),
                                                price: double.parse(price.text),
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
