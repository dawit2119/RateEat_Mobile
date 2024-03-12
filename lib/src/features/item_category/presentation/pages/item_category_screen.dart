import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/item_category/presentation/widgets/selected_item_category_tile.dart';
import 'package:rateeat_mobile/src/features/item_category/presentation/widgets/tag_shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../../core/widgets/custom_persistent_bottom_navbar.dart';
import '../../../discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import '../../../discover_restaurant_result/presentation/bloc/restaurant_bloc/discover_result_bloc.dart';
import '../../../discover_restaurant_result/presentation/bloc/restaurant_bloc/discover_result_event.dart';
import '../../../features.dart';

class SelectFoodCategoryScreen extends StatefulWidget {
  const SelectFoodCategoryScreen({super.key});

  @override
  SelectFoodCategoryScreenState createState() =>
      SelectFoodCategoryScreenState();
}

class SelectFoodCategoryScreenState extends State<SelectFoodCategoryScreen> {
  TextEditingController searchController = TextEditingController();
  final Debouncer _debouncer =
      Debouncer(delay: const Duration(milliseconds: 300));
  @override
  void initState() {
    context.read<SearchFoodCategoryBloc>().add(GetCategorySuggestion());
    super.initState();
  }

  final items = List.generate(15, (index) => const TagShimmer());

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      body: SafeArea(
        child: CustomScrollView(
          slivers: <Widget>[
            SliverAppBar(
                elevation: 0,
                scrolledUnderElevation: 0,
                toolbarHeight: SizeConfig.screenHeight * 0.07,
                automaticallyImplyLeading: false,
                title: Container(
                  margin: EdgeInsets.only(top: SizeConfig.screenHeight * 0.01),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Container(
                        height: SizeConfig.screenHeight * 0.05,
                        width: SizeConfig.screenHeight * 0.05,
                        decoration: BoxDecoration(
                            color: Colors.white,
                            boxShadow: [...elevation_4],
                            borderRadius: BorderRadius.circular(10)),
                        child: InkWell(
                          borderRadius: BorderRadius.circular(10),
                          onTap: () {
                            context.pop();
                          },
                          child: const Center(
                            child: Icon(
                              Icons.arrow_back,
                              color: Colors.black,
                              size: 20,
                              semanticLabel: "Back",
                            ),
                          ),
                        ),
                      ),
                      const SizedBox(
                        width: 16,
                      ),
                      //* Edit Title
                      Expanded(
                        child: Center(
                            child: Text(
                          AppLocalizations.of(context)!.selectCategoriesText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: titleTextStyle.copyWith(
                            fontSize: 16,
                          ),
                        )),
                      ),
                    ],
                  ),
                )),
            SliverPadding(padding: EdgeInsets.symmetric(vertical: 6.sp)),
            SliverFillRemaining(
              child: Stack(
                alignment: Alignment.center,
                children: [
                  Padding(
                    padding: EdgeInsets.symmetric(
                        vertical: 10.sp, horizontal: 20.sp),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: <Widget>[
                        verticalPadding(height: 2),
                        Text(
                          AppLocalizations.of(context)!.doYouKnowText,
                          style: titleTextStyle.copyWith(fontSize: 18),
                        ),
                        verticalPadding(height: 3),

                        //* Search Area for Categories
                        CustomTextInputField(
                          controller: searchController,
                          canRequestFocus: true,
                          hintText:
                              AppLocalizations.of(context)!.searchFoodTypeText,
                          onChanged: (query) {
                            _debouncer.run(() {
                              if (query.isEmpty) {
                                context
                                    .read<SearchFoodCategoryBloc>()
                                    .add(GetCategorySuggestion());
                              } else {
                                context.read<SearchFoodCategoryBloc>().add(
                                      SearchSubmitted(
                                        query: query,
                                        pageNumber: 1,
                                      ),
                                    );
                              }
                            });
                          },
                        ),
                        verticalPadding(height: 2),
                        Expanded(
                          child: ListView(
                            children: [
                              BlocBuilder<SearchFoodCategoryBloc,
                                  SearchFoodCategoryState>(
                                builder: (context, state) {
                                  if (state is SearchLoading) {
                                    return Wrap(
                                        spacing:
                                            5.0, // spacing between each item horizontally
                                        runSpacing:
                                            5.0, // spacing between each row vertically
                                        children: items.map((item) {
                                          return item;
                                        }).toList());
                                  } else if (state is SearchError) {
                                    return ErrorAndInfoDisplayWidget(
                                      assetImage: 'assets/icons/no_content.svg',
                                      title: AppLocalizations.of(context)!
                                          .noResultText,
                                      description: AppLocalizations.of(context)!
                                          .tryAgainOnlyText,
                                      onPressed: () {
                                        context
                                            .read<SearchFoodCategoryBloc>()
                                            .add(
                                              GetCategorySuggestion(),
                                            );
                                      },
                                    );
                                  } else if (state is SearchSuccess) {
                                    var itemCategories = state.itemCategories;
                                    if (itemCategories.isNotEmpty) {
                                      return Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Text(
                                            AppLocalizations.of(context)!
                                                .selectTagsText,
                                            style: GoogleFonts.poppins(
                                              fontWeight: FontWeight.w500,
                                              fontSize:
                                                  SizeConfig.screenHeight *
                                                      0.016,
                                            ),
                                          ),
                                          verticalPadding(height: 1),
                                          Wrap(
                                            spacing: 12.sp,
                                            runSpacing: 12.sp,
                                            children: [
                                              ...List.generate(
                                                itemCategories.length,
                                                (index) => ItemCategoryTile(
                                                  categoryName:
                                                      itemCategories[index]
                                                          .name!,
                                                ),
                                              ),
                                            ],
                                          ),
                                        ],
                                      );
                                    } else {
                                      return ErrorAndInfoDisplayWidget(
                                        assetImage:
                                            'assets/icons/no_content.svg',
                                        title: AppLocalizations.of(context)!
                                            .noResultText,
                                        description:
                                            AppLocalizations.of(context)!
                                                .searchNoText,
                                        buttonText: '',
                                        onPressed: () {
                                          context
                                              .read<SearchFoodCategoryBloc>()
                                              .add(
                                                GetCategorySuggestion(),
                                              );
                                        },
                                      );
                                    }
                                  }
                                  // * Default state
                                  return const ErrorAndInfoDisplayWidget(
                                    assetImage: 'assets/icons/no_content.svg',
                                    title: "Start Searching...",
                                    description:
                                        "Search and find your favorite restaurants.",
                                    onPressed: null,
                                  );
                                },
                              ),

                              verticalPadding(height: 3),
                              //* Display selected Tags
                              BlocBuilder<SelectFoodCategoryBloc,
                                  SelectedFoodCategoryState>(
                                builder: (context, state) {
                                  if (state.selectedCategories.isNotEmpty) {
                                    return Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Text(
                                          AppLocalizations.of(context)!
                                              .selectedTagsText,
                                          style: GoogleFonts.poppins(
                                            fontWeight: FontWeight.w500,
                                            fontSize:
                                                SizeConfig.screenHeight * 0.016,
                                          ),
                                        ),
                                        verticalPadding(height: 1),
                                        Wrap(
                                          spacing: 12.sp,
                                          runSpacing: 12.sp,
                                          children: [
                                            ...state.selectedCategories.map(
                                              (category) =>
                                                  SelectedItemCategoryTile(
                                                categoryName: category,
                                                onTap: () {
                                                  context
                                                      .read<
                                                          SelectFoodCategoryBloc>()
                                                      .add(
                                                        UnselectFoodCategory(
                                                            foodCategory:
                                                                category),
                                                      );
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                      ],
                                    );
                                  } else {
                                    return Container();
                                  }
                                },
                              ),
                              const SizedBox(
                                height: 80,
                              ),
                            ],
                          ),
                        ),
                        //* Display Searched Categories
                      ],
                    ),
                  ),
                  BlocBuilder<SelectFoodCategoryBloc,
                      SelectedFoodCategoryState>(
                    builder: (context, state) {
                      if (state.selectedCategories.isNotEmpty) {
                        return Positioned(
                          bottom: 10.sp,
                          child: SizedBox(
                            width: 96.w,
                            child: Padding(
                              padding: const EdgeInsets.all(20.0),
                              child: CustomMainButton(
                                title:
                                    AppLocalizations.of(context)!.continueText,
                                onTap: () {
                                  context.read<DiscoveryStepsBloc>().add(
                                        DiscoveryFilterUpdate(
                                          tags: state.selectedCategories,
                                        ),
                                      );
                                  //?! Check this line with care
                                  context
                                      .read<DiscoverSelectedScreenCubit>()
                                      .toDiscoverRestaurantResult();
                                  context
                                      .read<FetchDiscoverRestaurantResultBloc>()
                                      .add(
                                        FetchNewDiscoverRestaurantResultEvent(
                                          discoveryStepsBloc: context
                                              .read<DiscoveryStepsBloc>(),
                                        ),
                                      );
                                  // ? Giving initial index to home
                                  context.pushNamed(AppRoutes.home, extra: {
                                    'fromOtherPages': 'yes',
                                    'id': 1,
                                  });
                                },
                              ),
                            ),
                          ),
                        );
                      } else {
                        return Positioned(
                          bottom: 10.sp,
                          right: 10.sp,
                          child: SizedBox(
                            width: 200,
                            child: Padding(
                              padding: const EdgeInsets.all(16.0),
                              child: TextButton(
                                style: ButtonStyle(
                                  backgroundColor: WidgetStateProperty.all(
                                    AppColors.grey400,
                                  ),
                                ),
                                onPressed: () {
                                  context.read<DiscoveryStepsBloc>().add(
                                        const DiscoveryFilterUpdate(
                                          tags: [],
                                        ),
                                      );
                                  context
                                      .read<DiscoverSelectedScreenCubit>()
                                      .toDiscoverRestaurantResult();
                                  final discoveryStepsBloc =
                                      context.read<DiscoveryStepsBloc>();
                                  context
                                      .read<FetchDiscoverRestaurantResultBloc>()
                                      .add(
                                        FetchNewDiscoverRestaurantResultEvent(
                                          discoveryStepsBloc:
                                              discoveryStepsBloc,
                                        ),
                                      );
                                  // ? Giving initial index to home
                                  context.pushNamed(AppRoutes.home,
                                      extra: {'fromOtherPages': 'yes'});
                                },
                                child: Text(
                                  AppLocalizations.of(context)!.skipText,
                                  style: const TextStyle(color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        );
                      }
                    },
                  )
                ],
              ),
            )
          ],
        ),
      ),
    );
  }
}

class SearchFoodCategoryQueryCubit extends Cubit<String> {
  SearchFoodCategoryQueryCubit() : super("");

  void changeQuery(query) => emit(query);
}

class Debouncer {
  final Duration delay;
  VoidCallback? action;
  Timer? _timer;

  Debouncer({required this.delay});

  void run(VoidCallback action) {
    if (_timer != null) {
      _timer!.cancel();
    }
    _timer = Timer(delay, action);
  }
}
