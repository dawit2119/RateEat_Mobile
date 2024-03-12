import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_item_reviews/get_item_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/item_reviews_page.dart';

class ItemReviewSortingDropdown extends StatefulWidget {
  final String itemId;
  const ItemReviewSortingDropdown({super.key, required this.itemId});
  @override
  State<ItemReviewSortingDropdown> createState() =>
      _ReviewSortingDropdownFilterState();
}

List<String> list = <String>['Most Recent', 'Most Popular'];

class _ReviewSortingDropdownFilterState
    extends State<ItemReviewSortingDropdown> {
  String dropdownValue = list.first;
  @override
  Widget build(BuildContext context) {
    return BlocBuilder<GetItemReviewsBloc, GetItemReviewsState>(
      builder: (context, state) {
        return Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Padding(
              padding: EdgeInsets.only(right: 7),
              child: Icon(Icons.sort),
            ),
            DropdownButton<String>(
              value: state.sortType == ItemReviewsSortTypesState.mostRecent
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

                ItemReviewsSortTypesState sortType =
                    ItemReviewsSortTypesState.mostPopular;
                if (dropdownValue == "Most Recent") {
                  sortType = ItemReviewsSortTypesState.mostRecent;
                }
                context.read<ItemReviewsPageControllerCubit>().changePage(1);
                final reviewBloc = context.read<GetItemReviewsBloc>();
                reviewBloc.add(ResetGetItemReviewsEvent());
                reviewBloc.add(
                  GetItemReviewsRequestEvent(
                    itemId: widget.itemId,
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
