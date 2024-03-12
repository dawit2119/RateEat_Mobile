import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discover_restaurants_state.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/widgets/add_categories_widget.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_category/presentation/widgets/selected_item_category_tile.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';
import '../bloc/restaurant_bloc/discover_result_bloc.dart';
import '../bloc/restaurant_bloc/discover_result_event.dart';

class DiscoveryCategories extends StatefulWidget {
  const DiscoveryCategories({super.key});

  @override
  State<DiscoveryCategories> createState() => _DiscoveryCategoriesState();
}

class _DiscoveryCategoriesState extends State<DiscoveryCategories> {
  late bool isFasting;
  @override
  void initState() {
    super.initState();
    isFasting = context
            .read<DiscoveryStepsBloc>()
            .state
            .discoverRestaurantProps
            .fasting ??
        false;
  }

  int categoryLines = 1;
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            //* Display selected Tags
            BlocBuilder<DiscoveryStepsBloc, DiscoverRestaurantState>(
              builder: (context, state) {
                if (state.discoverRestaurantProps.tags != null &&
                    state.discoverRestaurantProps.tags!.isNotEmpty) {
                  return Text(
                    AppLocalizations.of(context)!.selectedTagsText,
                    style: GoogleFonts.poppins(
                      fontSize: 18,
                      fontWeight: FontWeight.w500,
                    ),
                  );
                }
                return Text(
                  AppLocalizations.of(context)!.addTagsText,
                  style: GoogleFonts.poppins(
                    fontSize: 18,
                    fontWeight: FontWeight.w500,
                  ),
                );
              },
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Text(
                  AppLocalizations.of(context)!.fastingText,
                  style: const TextStyle(fontSize: 16),
                ),
                Switch(
                  value: isFasting,
                  activeColor: AppColors.primaryColor,
                  activeTrackColor: Colors.deepOrange[50],
                  inactiveThumbColor: Colors.white,
                  inactiveTrackColor: Colors.grey[300],
                  trackOutlineColor: const WidgetStatePropertyAll(Colors.white),
                  onChanged: (bool value) {
                    setState(() {
                      isFasting = value;
                    });
                    //* Update the page counter
                    context.read<DiscoveryStepsBloc>().add(
                        DiscoveryFilterUpdate(page: 1, fasting: isFasting));
                    //* Fetch new result
                    context.read<FetchDiscoverRestaurantResultBloc>().add(
                          FetchNewDiscoverRestaurantResultEvent(
                            discoveryStepsBloc:
                                context.read<DiscoveryStepsBloc>(),
                          ),
                        );
                  },
                )
              ],
            )
          ],
        ),
        BlocBuilder<DiscoveryStepsBloc, DiscoverRestaurantState>(
          builder: (context, state) {
            final tagsLength = (state.discoverRestaurantProps.tags != null &&
                    state.discoverRestaurantProps.tags!.isNotEmpty)
                ? state.discoverRestaurantProps.tags!.length
                : 0;
            return SizedBox(
              height: SizeConfig.screenHeight * 0.045,
              child: ListView.builder(
                shrinkWrap: true,
                physics: const BouncingScrollPhysics(),
                scrollDirection: Axis.horizontal,
                itemCount: tagsLength + 1,
                itemBuilder: (context, index) {
                  if (index > tagsLength - 1) {
                    return const AddCategories();
                  }
                  return SelectedItemCategoryTile(
                    categoryName: state.discoverRestaurantProps.tags![index],
                    onTap: () {
                      //* Remove Element from the list
                      context.read<SelectFoodCategoryBloc>().add(
                            UnselectFoodCategory(
                                foodCategory:
                                    state.discoverRestaurantProps.tags![index]),
                          );
                      var newCategoryList = [
                        ...state.discoverRestaurantProps.tags!
                      ];
                      newCategoryList
                          .remove(state.discoverRestaurantProps.tags![index]);

                      //*  Update Selected List
                      context.read<DiscoveryStepsBloc>().add(
                            DiscoveryFilterUpdate(
                              tags: newCategoryList,
                            ),
                          );
                      //* Update the page counter
                      context
                          .read<DiscoveryStepsBloc>()
                          .add(const DiscoveryFilterUpdate(page: 1));
                      //* Refetch the Elements

                      context.read<FetchDiscoverRestaurantResultBloc>().add(
                            FetchNewDiscoverRestaurantResultEvent(
                              discoveryStepsBloc:
                                  context.read<DiscoveryStepsBloc>(),
                            ),
                          );
                    },
                  );
                },
              ),
            );
          },
        ),
      ],
    );
  }
}
