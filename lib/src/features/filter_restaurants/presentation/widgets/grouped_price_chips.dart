import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/core.dart';
import '../../../discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';

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
    return BlocBuilder<PriceMultiChipsBlock, int>(
      builder: (BuildContext blocContext, int selectedChip) {
        return Center(
          child: Wrap(
            crossAxisAlignment: WrapCrossAlignment.center,
            runAlignment: WrapAlignment.center,
            children: List.generate(
              prices.length,
              (index) => Padding(
                padding:
                    EdgeInsets.symmetric(vertical: 10.sp, horizontal: 8.sp),
                child: PriceSingleChip(
                  selected: index == selectedChip,
                  title: '${prices[index]} $currencyCode',
                  onTap: () {
                    blocContext.read<PriceMultiChipsBlock>().changeState(index);
                    context.read<DiscoveryStepsBloc>().add(
                          DiscoveryFilterUpdate(
                            minPrice: prices[index].toDouble(),
                          ),
                        );

                    context.read<DiscoveryStepsBloc>().add(
                        DiscoveryFilterUpdate(
                            maxPrice: prices[index].toDouble()));
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

class PriceSingleChip extends StatelessWidget {
  const PriceSingleChip({
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
            style: GoogleFonts.poppins(
              color: selected ? Colors.white : AppColors.grey700,
            ),
          ),
        ),
      ),
    );
  }
}

class PriceMultiChipsBlock extends Cubit<int> {
  PriceMultiChipsBlock() : super(6);
  void changeState(value) => emit(value);
}
