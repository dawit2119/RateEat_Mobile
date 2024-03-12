import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_event.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_state.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/bloc/restaurants_filter_search_result/restaurants_filter_results_bloc.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/categories.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class SearchPage extends StatefulWidget {
  const SearchPage({super.key});

  @override
  State<SearchPage> createState() => _SearchPageState();
}

class _SearchPageState extends State<SearchPage> {
  final TextEditingController controller = TextEditingController();

  @override
  Widget build(BuildContext context) {
    var locationState = BlocProvider.of<UserLocationBloc>(context).state;
    return BlocBuilder<RestaurantsFilterSearchResultsBloc,
        RestaurantsFilterSearchResultsState>(
      builder: (context, state) {
        final bloc =
            BlocProvider.of<RestaurantsFilterSearchResultsBloc>(context);
        return Scaffold(
          appBar: AppBar(
            leading: InkWell(
              onTap: () => Navigator.pop(context),
              child: SizedBox(
                height: 22.sp,
                width: 22.sp,
                child: Padding(
                  padding: EdgeInsets.all(16.sp),
                  child: SvgPicture.asset(
                    "assets/icons/arrow_left.svg",
                  ),
                ),
              ),
            ),
            title: TextFormField(
              controller: controller,
              onChanged: (searchQuery) => {
                if (locationState is UserLocationLoaded)
                  bloc.add(GetFilteredRestaurantEvent(
                    searchQuery: searchQuery,
                    selection: state.selection,
                    isFasting: state.isFasting,
                    location: Location(
                      latitude: locationState.location.latitude,
                      longitude: locationState.location.longitude,
                    ),
                    category: state.category,
                    rating: state.rating,
                    maximumPrice: state.maximumPrice,
                  )),
              },
              onFieldSubmitted: (searchQuery) {
                if (locationState is UserLocationLoaded) {
                  context.read<RestaurantsFilterSearchResultsBloc>().add(
                        GetFilteredRestaurantEvent(
                          isFasting: context.read<FastingToggleBloc>().state,
                          selection: state.selection,
                          searchQuery: searchQuery,
                          location: locationState.location,
                          category: state.category,
                          rating: state.rating,
                          maximumPrice: state.maximumPrice,
                        ),
                      );
                }
                Navigator.pop(context);
              },
              decoration: InputDecoration(
                hintText: "Search",
                hintStyle: TextStyle(
                  color: Colors.grey,
                  fontSize: 16.sp,
                ),
                border: InputBorder.none,
              ),
            ),
            actions: [
              Padding(
                padding: EdgeInsets.fromLTRB(0, 0, 15.sp, 0),
                child: InkWell(
                  splashColor: AppColors.primaryColor.withOpacity(.2),
                  borderRadius: BorderRadius.circular(12.sp),
                  onTap: () {
                    controller.clear();
                  },
                  child: Container(
                    height: 22.sp,
                    width: 22.sp,
                    decoration: BoxDecoration(
                      color: AppColors.grey200.withOpacity(.6),
                      borderRadius: BorderRadius.circular(12.sp),
                    ),
                    child: Padding(
                      padding: EdgeInsets.all(10.sp),
                      child: SvgPicture.asset(
                        "assets/icons/x.svg",
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
          body: SingleChildScrollView(
            child: Column(
              children: [
                const Divider(
                  color: AppColors.grey100,
                  thickness: 2,
                ),
                ListView.builder(
                  shrinkWrap: true,
                  itemCount: 10,
                  itemBuilder: (BuildContext context, int index) {
                    return SearchResultTile(
                      isLast: index == 9,
                      title: "Recent search $index",
                      subTitle: index.isEven ? "Subtitle" : null,
                    );
                  },
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

class SearchResultTile extends StatelessWidget {
  const SearchResultTile({
    super.key,
    this.isLast = false,
    required this.title,
    this.subTitle,
  });

  final String title;
  final String? subTitle;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 2.sp),
      child: Column(
        children: [
          SizedBox(
            height: 29.sp,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.start,
              children: [
                Padding(
                  padding: EdgeInsets.only(right: 12.sp),
                  child: SizedBox(
                    height: 24.sp,
                    width: 24.sp,
                    child: Padding(
                      padding: EdgeInsets.symmetric(horizontal: 6.sp),
                      child: SvgPicture.asset("assets/icons/search.svg",
                          colorFilter: const ColorFilter.mode(
                              AppColors.grey600, BlendMode.srcIn)),
                    ),
                  ),
                ),
                Padding(
                  padding: EdgeInsets.only(left: 8.sp),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      SizedBox(
                        width: 50.w,
                        child: Text(
                          title,
                          maxLines: 2,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w500,
                              color: AppColors.grey600),
                        ),
                      ),
                      if (subTitle != null)
                        Padding(
                          padding: EdgeInsets.only(top: 8.sp, right: 8.sp),
                          child: Text(
                            subTitle!,
                            style: TextStyle(
                              fontSize: 14.sp,
                              color: AppColors.grey600,
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
                const Spacer(),
                GestureDetector(
                  child: Padding(
                    padding: EdgeInsets.only(left: 22.sp),
                    child: SizedBox(
                      height: 24.sp,
                      width: 24.sp,
                      child: Padding(
                        padding: EdgeInsets.symmetric(horizontal: 6.sp),
                        child: SvgPicture.asset("assets/icons/redirect.svg",
                            colorFilter: const ColorFilter.mode(
                                AppColors.grey600, BlendMode.srcIn)),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
          // if (!isLast) Divider(color: AppColors.grey200.withOpacity(.6)),
        ],
      ),
    );
  }
}
