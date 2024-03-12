import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/pages/search_result_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class GroupedPriceChips extends StatelessWidget {
  const GroupedPriceChips({
    super.key,
    required this.prices,
    required this.currencyCode,
  });
  final List<int> prices;
  final String currencyCode;

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<MultiChipsCubit, int>(
      builder: (BuildContext blocContext, int selectedChip) {
        return Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            children: List.generate(
              7,
              (index) => Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 10.sp, horizontal: 8.sp),
                child: SingleChip(
                  selected: index == selectedChip,
                  title: '${prices[index]} ',
                  onTap: () {
                    blocContext.read<MultiChipsCubit>().changeState(index);
                  },
                ),
              ),
            ),
          ),
        );
      },
    );
  }
}

class SingleChip extends StatelessWidget {
  const SingleChip({
    super.key,
    required this.selected,
    required this.title,
    required this.onTap,
  });
  final bool selected;
  final String title;
  final GestureTapCallback onTap;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(12.sp),
          color: selected ? AppColors.primaryColor : AppColors.grey100,
        ),
        child: Padding(
          padding: EdgeInsets.symmetric(horizontal: 15.sp, vertical: 10.sp),
          child: Text(
            title,
            style: TextStyle(
              fontFamily: GoogleFonts.montserrat().fontFamily,
              color: selected ? Colors.white : AppColors.grey700,
            ),
          ),
        ),
      ),
    );
  }
}
