import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';

import '../bloc/restaurant_bloc/discover_result_bloc.dart';
import '../bloc/restaurant_bloc/discover_result_event.dart';

class DropdownFilter extends StatefulWidget {
  const DropdownFilter({super.key});
  @override
  State<DropdownFilter> createState() => _DropdownFilterState();
}

List<String> dropdownItems = <String>[
  'Most Popular',
  'Highest Rated',
  'Price(From Lowest)',
  'Distance',
];
Map<String, String> dropdownItemsSortingMap = {
  "Most Popular": "popularity",
  "Highest Rated": "rating",
  "Price(From Lowest)": "price",
  "Distance": "distance"
};

class _DropdownFilterState extends State<DropdownFilter> {
  @override
  Widget build(BuildContext context) {
    Map<String, String> localizedMap = {
      "Most Popular": AppLocalizations.of(context)!.mostPopularText,
      "Highest Rated": AppLocalizations.of(context)!.ratedText,
      "Price(From Lowest)": AppLocalizations.of(context)!.priceText,
      "Distance": AppLocalizations.of(context)!.distText
    };
    return BlocProvider(
      create: (context) => SelectedDropDownItemCubit(),
      child: BlocBuilder<SelectedDropDownItemCubit, String>(
        builder: (context, dropDownState) {
          return DropdownButton<String>(
            value: dropDownState,
            iconSize: 16,
            isExpanded: false,
            isDense: true,
            padding: const EdgeInsets.symmetric(horizontal: 4),
            icon: const Icon(Icons.sort),
            borderRadius: BorderRadius.circular(6),
            elevation: 4,
            dropdownColor: Colors.white,
            focusColor: AppColors.grey200,
            style: const TextStyle(color: Colors.black),
            underline: Container(height: 0),
            onChanged: (String? value) {
              // This is called when the user selects an item.
              context
                  .read<SelectedDropDownItemCubit>()
                  .changeSelectedItem(value);
              var discoveryStepsBloc = context.read<DiscoveryStepsBloc>()
                ..add(DiscoveryFilterUpdate(
                    sorting: dropdownItemsSortingMap[value]));
              //* Update the page counter
              context
                  .read<DiscoveryStepsBloc>()
                  .add(const DiscoveryFilterUpdate(page: 1));
              //* Fetch new result
              context.read<FetchDiscoverRestaurantResultBloc>().add(
                    FetchNewDiscoverRestaurantResultEvent(
                      discoveryStepsBloc: discoveryStepsBloc,
                    ),
                  );
            },
            items: dropdownItems.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(
                  localizedMap[value].toString(),
                  style: GoogleFonts.poppins(
                    color: AppColors.textDark,
                  ),
                ),
              );
            }).toList(),
          );
        },
      ),
    );
  }
}

class SelectedDropDownItemCubit extends Cubit<String> {
  SelectedDropDownItemCubit() : super(dropdownItems[1]);

  void changeSelectedItem(selectedItem) => emit(selectedItem);
}
