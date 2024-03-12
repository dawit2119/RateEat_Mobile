import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';
import '../bloc/live_search/search_bloc.dart';
import '../bloc/live_search/search_event.dart';
import '../bloc/popular_searches/popular_search_bloc.dart';
import '../bloc/popular_searches/popular_search_state.dart';
import '../pages/live_search_page.dart';

class PopularSearches extends StatelessWidget {
  const PopularSearches({
    super.key,
    required this.dropDownValue,
    required this.controller,
    required this.latitude,
    required this.longitude,
  });
  final String dropDownValue;
  final TextEditingController controller;
  final double latitude;
  final double longitude;
  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<PopularSearchesBloc, PopularSearchesState>(
      builder: (context, state) {
        if (state is PopularSearchActionsLoading) {
          return Center(
            child: LoadingAnimationWidget.dotsTriangle(
              color: AppColors.primaryColor,
              size: 4.h,
            ),
          );
        }
        if (state is PopularSearchesLoaded) {
          var popularSearches = dropDownValue == "Items"
              ? state.popularSearchItems.items
              : state.popularSearchItems.restaurants;
          if (popularSearches.isNotEmpty) {
            return ListView(
              shrinkWrap: true,
              physics: const NeverScrollableScrollPhysics(),
              children: [
                Text(
                  AppLocalizations.of(context)!.popularSearchesText,
                  style: GoogleFonts.poppins(
                    color: const Color(0xff3e3e3e),
                    fontSize: screenHeight * 0.021,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                SizedBox(
                  height: screenHeight * 0.01,
                ),
                Wrap(
                  crossAxisAlignment: WrapCrossAlignment.center,
                  runAlignment: WrapAlignment.center,
                  children: List.generate(
                    popularSearches.length,
                    (index) {
                      var popularSearch = popularSearches[index];
                      return Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 5),
                        child: InkWell(
                          onTap: () {
                            controller.text = popularSearch;
                            context.read<SearchBloc>().add(
                                  dropDownValue != "Items"
                                      ? RestaurantSearchEvent(
                                          query: popularSearch)
                                      : ItemSearchEvent(
                                          query: popularSearch,
                                          latitude: latitude,
                                          longitude: longitude,
                                        ),
                                );
                            context.read<LiveSearchCubit>().changeQuery(
                                  popularSearch,
                                );
                          },
                          child: Container(
                            padding: const EdgeInsets.all(8.0),
                            decoration: BoxDecoration(
                              borderRadius:
                                  BorderRadius.circular(screenHeight * 0.012),
                              color: Colors.grey.withOpacity(0.2),
                            ),
                            child: Text(
                              popularSearch,
                              style: GoogleFonts.poppins(
                                color: Colors.black54,
                                fontWeight: FontWeight.w300,
                                fontSize: SizeConfig.screenHeight * 0.015,
                              ),
                            ),
                          ),
                        ),
                      );
                    },
                  ),
                ),
                const SizedBox(
                  height: 4,
                ),
              ],
            );
          }
        }
        return Container();
      },
    );
  }
}
