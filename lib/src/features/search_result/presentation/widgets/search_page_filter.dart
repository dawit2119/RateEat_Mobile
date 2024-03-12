import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/local_history/local_search_history_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/local_history/local_search_history_event.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/popular_searches/popular_search_bloc.dart';
import 'package:rateeat_mobile/src/features/live_search/presentation/bloc/popular_searches/popular_search_event.dart';
import 'package:rateeat_mobile/src/features/location_search/presentation/bloc/location_description/location_description_bloc.dart';
import '../../../live_search/presentation/pages/live_search_page.dart';

import '../pages/search_result_page.dart';

class SearchAndDiscoverPagesFilter extends StatelessWidget {
  const SearchAndDiscoverPagesFilter({
    super.key,
    required this.onFilterPressed,
  });
  final GestureTapCallback onFilterPressed;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(right: SizeConfig.screenWidth * 0.06),
      child: GestureDetector(
        onTap: () {
          context.read<LocationDescriptionBloc>().add(
                UpdateLocationDescription(
                  location: Location(
                    latitude: (context.read<UserLocationBloc>().state
                            as UserLocationLoaded)
                        .location
                        .latitude,
                    longitude: (context.read<UserLocationBloc>().state
                            as UserLocationLoaded)
                        .location
                        .longitude,
                  ),
                ),
              );
        },
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                padding: EdgeInsets.only(
                  left: SizeConfig.screenWidth * 0.04,
                  right: SizeConfig.screenWidth * 0.08,
                  top: SizeConfig.screenHeight * 0.01,
                  bottom: SizeConfig.screenHeight * 0.01,
                ),
                child: BlocBuilder<LiveSearchCubit, String>(
                  builder: (context, state) {
                    var query = state;
                    return BlocBuilder<CategoriesToggleBloc, int>(
                      builder: (context, categoriesState) {
                        return CustomTextInputField(
                          hintText: query.isEmpty || categoriesState == 0
                              ? AppLocalizations.of(context)!.searchText
                              : query,
                          fillColor: Colors.white,
                          labelColor: AppColors.grey600,
                          controller: TextEditingController(),
                          onTap: () {
                            context.read<LocalSearchHistoryBloc>().add(
                                  GetLocalSearchHistory(),
                                );
                            context.read<PopularSearchesBloc>().add(
                                  GetPopularSearches(
                                    page: 1,
                                    limit: 6,
                                  ),
                                );
                            context.pushNamed(AppRoutes.liveSearchPage);
                          },
                          validator: (value) {
                            return null;
                          },
                        );
                      },
                    );
                  },
                ),
              ),
            ),
            Container(
              height: SizeConfig.screenHeight * 0.055,
              width: SizeConfig.screenHeight * 0.059,
              decoration: BoxDecoration(
                  color: Colors.white,
                  boxShadow: [...elevation_4],
                  borderRadius: BorderRadius.circular(10)),
              child: Material(
                borderRadius: BorderRadius.circular(10),
                child: InkWell(
                  key: const Key('discover_result_page_search_filter'),
                  borderRadius: BorderRadius.circular(10),
                  onTap: onFilterPressed,
                  child: Padding(
                    padding: const EdgeInsets.all(14),
                    child: SvgPicture.asset(
                      "assets/icons/filter.svg",
                      height: 2.4.h, // responsive height
                      width: 2.4.h, // keep square proportion
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
