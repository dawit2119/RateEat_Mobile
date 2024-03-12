import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/bloc/restaurant_bloc/discover_result_event.dart';

import '../../../../core/core.dart';
import '../../../discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import '../bloc/restaurant_bloc/discover_result_bloc.dart';

class CategoryTypeButton extends StatefulWidget {
  final String itemType;
  const CategoryTypeButton({super.key, required this.itemType});

  @override
  State<CategoryTypeButton> createState() => _CategoryTypeButtonState();
}

class _CategoryTypeButtonState extends State<CategoryTypeButton> {
  bool isSelected = false;
  Color bgColor = AppColors.grey100;
  Color textColor = AppColors.textDark;
  Size maximumSize = const Size(64, 36);
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(5.0),
      child: ElevatedButton(
          onPressed: () {
            setState(() {
              isSelected = !isSelected;
            });
            if (isSelected) {
              var discoverBloc = context.read<DiscoveryStepsBloc>();
              discoverBloc.add(DiscoveryFilterUpdate(
                tags: [widget.itemType],
              ));
              setState(() {
                bgColor = AppColors.primaryColor;
                textColor = AppColors.textWhite;
              });
              //* Update the page counter
              context
                  .read<DiscoveryStepsBloc>()
                  .add(const DiscoveryFilterUpdate(page: 1));
              //* Fetch new result
              context.read<FetchDiscoverRestaurantResultBloc>().add(
                    FetchNewDiscoverRestaurantResultEvent(
                      discoveryStepsBloc: discoverBloc,
                    ),
                  );
            } else {
              var discoverBloc = context.read<DiscoveryStepsBloc>();
              discoverBloc.add(const DiscoveryFilterUpdate(
                tags: [],
              ));
              setState(() {
                bgColor = AppColors.grey100;
                textColor = AppColors.textDark;
              });
              //* Update the page counter
              context
                  .read<DiscoveryStepsBloc>()
                  .add(const DiscoveryFilterUpdate(page: 1));
              //* Fetch new result
              context.read<FetchDiscoverRestaurantResultBloc>().add(
                    FetchNewDiscoverRestaurantResultEvent(
                      discoveryStepsBloc: discoverBloc,
                    ),
                  );
            }
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: bgColor,
            elevation: 0,
            padding: const EdgeInsets.all(7),
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12), // <-- Radius
            ),
          ),
          child: Text(
            widget.itemType,
            style: TextStyle(color: textColor, fontSize: 14),
          )),
    );
  }
}
