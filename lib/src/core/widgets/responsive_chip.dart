import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../core.dart';

class ResponsiveChip extends StatelessWidget {
  const ResponsiveChip({
    super.key,
    required this.title,
  });
  final String title;

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (BuildContext context) => ChipBlock(),
      child: BlocBuilder<ChipBlock, bool>(
        builder: (BuildContext buildContext, bool selected) => InkWell(
          onTap: () {
            buildContext.read<ChipBlock>().changeState();
          },
          child: Container(
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12.sp),
              color: selected ? AppColors.primaryColor : AppColors.grey100,
            ),
            child: Padding(
              padding: EdgeInsets.symmetric(horizontal: 20.sp, vertical: 12.sp),
              child: Text(
                title,
                style: TextStyle(
                  color: selected ? Colors.white : AppColors.grey500,
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}

class ChipBlock extends Cubit<bool> {
  ChipBlock() : super(false);
  void changeState() => emit(!state);
}
