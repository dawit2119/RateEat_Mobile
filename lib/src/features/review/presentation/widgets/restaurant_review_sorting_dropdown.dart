import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_restaurant_reviews/get_restaurant_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/restaurant_reviews_page.dart';

class RestaurantReviewSortingDropdown extends StatefulWidget {
  final String restaurantId;
  const RestaurantReviewSortingDropdown(
      {super.key, required this.restaurantId});
  @override
  State<RestaurantReviewSortingDropdown> createState() =>
      _ReviewSortingDropdownFilterState();
}

List<String> list = <String>['Most Recent', 'Most Popular'];

class _ReviewSortingDropdownFilterState
    extends State<RestaurantReviewSortingDropdown> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetRestaurantReviewsBloc, GetRestaurantReviewsState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 7),
              child: Icon(Icons.sort),
            ),
            DropdownButton<String>(
              value:
                  (state.sortType == RestaurantReviewsSortTypesState.mostRecent)
                      ? list.first
                      : list.last,
              elevation: 10,
              iconSize: 0.0,
              borderRadius: BorderRadius.circular(6),
              style: const TextStyle(color: Colors.black),
              underline: Container(height: 0),
              onChanged: (String? value) {
                setState(() {
                  dropdownValue = value!;
                });

                RestaurantReviewsSortTypesState sortType =
                    RestaurantReviewsSortTypesState.mostPopular;
                if (dropdownValue == "Most Recent") {
                  sortType = RestaurantReviewsSortTypesState.mostRecent;
                }

                context
                    .read<RestaurantReviewsPageControllerCubit>()
                    .changePage(1);
                final reviewBloc = context.read<GetRestaurantReviewsBloc>();
                reviewBloc.add(ResetRestaurantReviewsRequestEvent());
                reviewBloc.add(
                  GetRestaurantReviewsRequestEvent(
                    restaurantId: widget.restaurantId,
                    sortType: sortType,
                  ),
                );
              },
              items: list.map<DropdownMenuItem<String>>((String value) {
                return DropdownMenuItem<String>(
                  value: value,
                  child: Text(
                    value,
                    style: GoogleFonts.poppins(
                        fontSize: SizeConfig.screenHeight * 0.017,
                        color: const Color(0xFF586069)),
                  ),
                );
              }).toList(),
            ),
          ],
        );
      },
    );
  }
}
