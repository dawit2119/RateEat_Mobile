import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/pages/live_search_page.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';
import '../../data/data_sources/local_search_history_data_source.dart';
import '../bloc/live_search/search_bloc.dart';
import '../bloc/live_search/search_event.dart';
import '../bloc/local_history/local_search_history_bloc.dart';
import '../bloc/local_history/local_search_history_event.dart';
import '../bloc/local_history/local_search_history_state.dart';

class LocalSearches extends StatelessWidget {
  const LocalSearches({
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
    context.read<LocalSearchHistoryBloc>().add(
          GetLocalSearchHistory(
            localSearchType: dropDownValue == "Items"
                ? LocalSearchType.items
                : LocalSearchType.restaurants,
          ),
        );
    return BlocConsumer<LocalSearchHistoryBloc, LocalSearchHistoryState>(
      listener: (_, state) {
        if (state is LocalSearchHistoryActionsSuccess ||
            state is LocalSearchHistoryActionsFailed) {
          context.read<LocalSearchHistoryBloc>().add(
                GetLocalSearchHistory(
                  localSearchType: dropDownValue == "Items"
                      ? LocalSearchType.items
                      : LocalSearchType.restaurants,
                ),
              );
        }
      },
      builder: (context, state) {
        if (state is LocalSearchHistoryActionLoading) {
          return Center(
            child: LoadingAnimationWidget.dotsTriangle(
              color: AppColors.primaryColor,
              size: 4.h,
            ),
          );
        }
        if (state is LocalSearchHistoryLoaded) {
          var histories = state.histories;
          if (histories.isNotEmpty) {
            return Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      AppLocalizations.of(context)!.recentSearchesText,
                      style: GoogleFonts.poppins(
                        color: const Color(0xff3e3e3e),
                        fontSize: screenHeight * 0.021,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        _showClearHistoryDialog(context);
                      },
                      child: Container(
                        height: SizeConfig.screenHeight * 0.04,
                        width: SizeConfig.screenWidth * 0.3,
                        decoration: BoxDecoration(
                          borderRadius:
                              BorderRadius.circular(screenHeight * 0.012),
                          color: AppColors.primaryColor,
                        ),
                        child: Center(
                          child: Text(
                            AppLocalizations.of(context)!.clearAllText,
                            style: GoogleFonts.poppins(
                                color: Colors.white,
                                fontSize: SizeConfig.screenHeight * 0.015,
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
                //* Local Search display
                SizedBox(height: SizeConfig.screenHeight * 0.012),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: List.generate(
                      histories.length,
                      (index) => Container(
                            key: Key("history_$index"),
                            margin: EdgeInsets.symmetric(
                                vertical: screenHeight * 0.008,
                                horizontal: SizeConfig.screenWidth * 0.03),
                            child: Column(
                              children: [
                                InkWell(
                                  onTap: () {
                                    var recentSearch = histories[index].title;
                                    context.read<SearchBloc>().add(
                                          dropDownValue != "Items"
                                              ? RestaurantSearchEvent(
                                                  query: recentSearch)
                                              : ItemSearchEvent(
                                                  query: recentSearch,
                                                  latitude: latitude,
                                                  longitude: longitude,
                                                ),
                                        );
                                    controller.text = recentSearch;
                                  },
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                      bottom: screenHeight * 0.01,
                                    ),
                                    child: Row(
                                      children: [
                                        Expanded(
                                          child: Text(
                                            histories[index].title,
                                            style: GoogleFonts.poppins(
                                              color: Colors.grey,
                                              fontSize:
                                                  SizeConfig.screenHeight *
                                                      0.018,
                                              fontWeight: FontWeight.w300,
                                            ),
                                          ),
                                        ),
                                        InkWell(
                                          splashColor: AppColors.primaryColor
                                              .withOpacity(.2),
                                          borderRadius:
                                              BorderRadius.circular(12.sp),
                                          onTap: () {
                                            context
                                                .read<LocalSearchHistoryBloc>()
                                                .add(
                                                  DeleteLocalSearchHistory(
                                                    localSearchType:
                                                        dropDownValue == "Items"
                                                            ? LocalSearchType
                                                                .items
                                                            : LocalSearchType
                                                                .restaurants,
                                                    id: histories[index].id,
                                                  ),
                                                );
                                          },
                                          child: Container(
                                            height: screenHeight * 0.027,
                                            width: screenHeight * 0.027,
                                            decoration: BoxDecoration(
                                              color: AppColors.grey200
                                                  .withOpacity(.4),
                                              borderRadius:
                                                  BorderRadius.circular(
                                                      screenHeight * 0.010),
                                            ),
                                            child: Padding(
                                              padding: EdgeInsets.all(
                                                  screenHeight * 0.005),
                                              child: SvgPicture.asset(
                                                "assets/icons/x.svg",
                                              ),
                                            ),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                const Opacity(
                                  opacity: 0.5,
                                  child: Divider(
                                    height: 1,
                                  ),
                                ),
                              ],
                            ),
                          )),
                ),
              ],
            );
          }
        }
        return Container();
      },
    );
  }

  void _showClearHistoryDialog(BuildContext context) {
    final appLocalizations = AppLocalizations.of(context);
    if (appLocalizations != null) {
      showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text(
              appLocalizations.clearHistoryText,
            ),
            actions: <Widget>[
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                },
                child: Text(appLocalizations.cancelText),
              ),
              TextButton(
                onPressed: () {
                  Navigator.of(context).pop();
                  controller.text = "";
                  context.read<LiveSearchCubit>().changeQuery("");
                  context.read<LocalSearchHistoryBloc>().add(
                        ClearLocalSearchHistory(
                          localSearchType: dropDownValue == "Items"
                              ? LocalSearchType.items
                              : LocalSearchType.restaurants,
                        ),
                      );
                },
                child: Text(appLocalizations.yesText),
              ),
            ],
          );
        },
      );
    }
  }
}
