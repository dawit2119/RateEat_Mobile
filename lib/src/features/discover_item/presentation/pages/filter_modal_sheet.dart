import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/features/discover_item/presentation/pages/item_result_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../widgets/item_price_chips.dart';
import '../bloc/filter/filter_items_bloc.dart';
import '../bloc/filter/filter_items_event.dart';

void showFilterModalSheet({
  required BuildContext context,
  required NavigatorState navigator,
  required String restaurantId,
  required bool isFasting,
  required String sortingValue,
  required String searchQuery,
  required String currencyCode,
  required String dropdownValue,
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
      return FilterBottomSheetContent(
        navigator: navigator,
        isFasting: isFasting,
        restaurantId: restaurantId,
        sortingValue: sortingValue,
        searchQuery: searchQuery,
        dropdownValue: dropdownValue,
        currencyCode: currencyCode,
      );
    },
  );
}

class FilterBottomSheetContent extends StatefulWidget {
  final String restaurantId;
  final bool isFasting;
  final String sortingValue;
  final String searchQuery;
  final NavigatorState navigator;
  final String currencyCode;
  final String dropdownValue;
  const FilterBottomSheetContent({
    super.key,
    required this.restaurantId,
    required this.isFasting,
    required this.sortingValue,
    required this.searchQuery,
    required this.navigator,
    required this.dropdownValue,
    required this.currencyCode,
  });

  @override
  State<FilterBottomSheetContent> createState() =>
      _FilterBottomSheetContentState();
}

class _FilterBottomSheetContentState extends State<FilterBottomSheetContent> {
  final List<String> prices = [r'$', r'$$', r'$$$', r'$$$$'];

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Column(
        children: [
          verticalPadding(height: 1),
          Container(
            height: 3,
            width: 36,
            decoration: BoxDecoration(
              color: AppColors.grey200,
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          verticalPadding(height: 2),
          Text(
            AppLocalizations.of(context)!.filterText.toUpperCase(),
            style: bold18,
          ),
          verticalPadding(height: 1),
          Padding(
            padding: EdgeInsets.only(left: 20.sp),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisAlignment: MainAxisAlignment.center,
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  padding: const EdgeInsets.only(
                    left: 10,
                    right: 15,
                  ),
                  margin: EdgeInsets.only(top: 10.sp),
                  width: 42.sw,
                  decoration: BoxDecoration(
                    color: Colors.grey[100],
                    borderRadius: BorderRadius.circular(10),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.fastingText,
                        style: GoogleFonts.poppins(fontSize: 16),
                      ),
                      BlocBuilder<DiscoverMenuFastingSelectorCubit, bool>(
                        builder: (context, selectedValue) {
                          return Switch(
                            value: selectedValue,
                            activeColor: AppColors.primaryColor,
                            activeTrackColor: Colors.deepOrange[50],
                            inactiveThumbColor: Colors.white,
                            inactiveTrackColor: Colors.grey[300],
                            trackOutlineColor:
                                const WidgetStatePropertyAll(Colors.white),
                            onChanged: (bool value) {
                              context
                                  .read<DiscoverMenuFastingSelectorCubit>()
                                  .changeFasting(value);
                            },
                          );
                        },
                      ),
                    ],
                  ),
                ),
                verticalPadding(height: 2),
                Text(AppLocalizations.of(context)!.minimumRatingText,
                    style: bold18),
                BlocBuilder<DiscoverMenuRatingSelectorCubit, double>(
                  builder: (context, selectedRate) {
                    return Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [
                        RatingBar.builder(
                          initialRating: selectedRate,
                          minRating: 0,
                          glowColor: AppColors.grey100,
                          glowRadius: 0.1,
                          itemSize: 35,
                          direction: Axis.horizontal,
                          allowHalfRating: true,
                          itemCount: 5,
                          unratedColor: AppColors.grey200,
                          updateOnDrag: true,
                          itemPadding: EdgeInsets.symmetric(horizontal: 0.5.sp),
                          itemBuilder: (context, _) => const Icon(
                            Icons.star_rounded,
                            color: AppColors.primaryColor,
                          ),
                          onRatingUpdate: (rating) {
                            context
                                .read<DiscoverMenuRatingSelectorCubit>()
                                .changeRating(rating);
                          },
                        ),
                        Padding(
                          padding: const EdgeInsets.fromLTRB(15, 5, 5, 5),
                          child: (selectedRate == 5)
                              ? Text(
                                  "$selectedRate ${AppLocalizations.of(context)!.starsText}",
                                  style: TextStyle(
                                    fontSize: 15.sp,
                                    fontWeight: FontWeight.w600,
                                    color: AppColors.grey500,
                                  ),
                                )
                              : Text(
                                  "$selectedRate ${AppLocalizations.of(context)!.starsAndUpText}",
                                  style: TextStyle(
                                    fontSize: 14.sp,
                                    fontWeight: FontWeight.bold,
                                    color: AppColors.grey500,
                                  ),
                                ),
                        ),
                      ],
                    );
                  },
                ),
                verticalPadding(height: 2),
                Text(
                  AppLocalizations.of(context)!.priceCatagoryText,
                  style: bold18,
                ),
                verticalPadding(height: 2),
                BlocBuilder<DiscoverMenuPriceSelectorCubit, String>(
                  builder: (context, selectedChip) {
                    return Wrap(
                      crossAxisAlignment: WrapCrossAlignment.center,
                      runAlignment: WrapAlignment.center,
                      children: List.generate(
                        4,
                        (index) {
                          return Padding(
                            padding: EdgeInsets.symmetric(
                              vertical: 10.sp,
                              horizontal: 8.sp,
                            ),
                            child: SingleItemChip(
                              selected: prices[index] == selectedChip,
                              title: prices[index],
                              onTap: () {
                                context
                                    .read<DiscoverMenuPriceSelectorCubit>()
                                    .changePrice(prices[index]);
                              },
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
              vertical: 10,
            ),
            width: double.infinity,
            child: ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: AppColors.primaryButtonColor,
              ),
              onPressed: () {
                context.read<DiscoveryItemPageCubit>().changePage(1);
                context.read<FilterItemsBloc>().add(ResetFilterItemsEvent());
                widget.navigator.pop();

                context.read<FilterItemsBloc>().add(
                      GetFilteredItemsEvent(
                        restaurantId: widget.restaurantId,
                        maxPrice: context
                            .read<DiscoverMenuPriceSelectorCubit>()
                            .state,
                        fasting: context
                            .read<DiscoverMenuFastingSelectorCubit>()
                            .state,
                        sortingQuery: widget.sortingValue.toString(),
                        searchQuery: widget.searchQuery,
                        categoryId: context
                            .read<DiscoverMenuSelectedCategoryCubit>()
                            .state['categoryId'],
                      ),
                    );
              },
              child: Text(
                AppLocalizations.of(context)!.updateFiltreText,
                style: TextStyle(
                  fontSize: 16.sp,
                  color: Colors.white,
                  fontWeight: FontWeight.bold,
                ),
              ),
            ),
          ),
          verticalPadding(height: 2),
        ],
      ),
    );
  }
}

class DiscoverMenuPriceSelectorCubit extends Cubit<String> {
  DiscoverMenuPriceSelectorCubit() : super(r'$$$$');
  void changePrice(String value) => emit(value);
}

class DiscoverMenuRatingSelectorCubit extends Cubit<double> {
  DiscoverMenuRatingSelectorCubit() : super(0.0);
  void changeRating(double value) => emit(value);
}

class DiscoverMenuFastingSelectorCubit extends Cubit<bool> {
  DiscoverMenuFastingSelectorCubit() : super(false);
  void changeFasting(bool value) => emit(value);
}

class DiscoverMenuCategoryIdCubit extends Cubit<String> {
  DiscoverMenuCategoryIdCubit() : super('');
  void changeSelectCategoryId(String value) => emit(value);
}

class DiscoverMenuSelectedCategoryCubit extends Cubit<Map<String, dynamic>> {
  DiscoverMenuSelectedCategoryCubit()
      : super({
          'categoryId': '',
          'isSelected': false,
        });

  // Update method to accept named parameters
  void changeSelectedCategory({required String categoryId, bool? isSelected}) {
    emit({
      'categoryId': categoryId,
      'isSelected': isSelected ?? false,
    });
  }
}
