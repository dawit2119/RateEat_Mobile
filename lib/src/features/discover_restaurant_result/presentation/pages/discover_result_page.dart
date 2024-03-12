import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/features/discover/presentation/bloc/discoverySteps/discovery_steps.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/widgets/categories.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/widgets/dropdown.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/presentation/widgets/search_result.dart';
import 'package:rateeat_mobile/src/features/filter_restaurants/presentation/pages/discover_restaurant_bottom_sheet.dart';

import '../../../../core/core.dart';
import '../../../../core/widgets/custom_persistent_bottom_navbar.dart';
import '../../../discover/presentation/bloc/discoverySteps/discover_restaurants_event.dart';
import '../../../search_result/presentation/widgets/search_page_filter.dart';
import '../bloc/restaurant_bloc/discover_result_bloc.dart';
import '../bloc/restaurant_bloc/discover_result_event.dart';
import '../bloc/restaurant_bloc/discover_result_state.dart';

class DiscoverResultPage extends StatefulWidget {
  const DiscoverResultPage({super.key});

  @override
  State<DiscoverResultPage> createState() => _DiscoverResultPageState();
}

class _DiscoverResultPageState extends State<DiscoverResultPage> {
  final _discoveryPageController = ScrollController();

  void _onItemScroll() {
    final state = context.read<FetchDiscoverRestaurantResultBloc>().state;
    final discoverStepsBloc = context.read<DiscoveryStepsBloc>();
    if (state is DiscoverRestaurantLoaded &&
        state.hasReachedMax &&
        _isBottomReached) {
      return;
    } else if (state is DiscoverRestaurantLoaded &&
        !state.hasReachedMax &&
        _isBottomReached) {
      final page = discoverStepsBloc.state.discoverRestaurantProps.page;
      discoverStepsBloc.add(
        DiscoveryFilterUpdate(
          page: page + 1,
        ),
      );
      context.read<FetchDiscoverRestaurantResultBloc>().add(
            LoadMoreDiscoverRestaurantResultEvent(
              discoveryStepsBloc: discoverStepsBloc,
            ),
          );
    }
  }

  bool get _isBottomReached {
    if (!_discoveryPageController.hasClients) return false;
    return _discoveryPageController.position.maxScrollExtent ==
        _discoveryPageController.position.pixels;
  }

  @override
  void initState() {
    super.initState();
    _discoveryPageController.addListener(_onItemScroll);
  }

  @override
  void dispose() {
    super.dispose();
    _discoveryPageController
      ..removeListener(_onItemScroll)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.read<DiscoverSelectedScreenCubit>().toDiscoverOptionsPage();
          context.goNamed(
            AppRoutes.home,
          );
        }
      },
      child: Scaffold(
        appBar: PreferredSize(
          preferredSize: Size(double.infinity, SizeConfig.screenHeight * 0.08),
          child: AppBar(
            automaticallyImplyLeading: false,
            scrolledUnderElevation: 0,
            flexibleSpace: SearchAndDiscoverPagesFilter(
              onFilterPressed: () {
                showModalBottomSheet(
                  elevation: 1,
                  context: context,
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  shape: const RoundedRectangleBorder(
                    borderRadius: BorderRadius.vertical(
                      top: Radius.circular(20),
                    ),
                  ),
                  clipBehavior: Clip.hardEdge,
                  builder: (context) {
                    return const DiscoverRestaurantFilterBottomSheet();
                  },
                );
              },
            ),
          ),
        ),
        body: Scrollbar(
          radius: const Radius.circular(10),
          child: SingleChildScrollView(
            controller: _discoveryPageController,
            // add key for testing scroll next page
            key: const Key('discover_result_page_scroll_view'),
            child: Column(
              children: [
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 0.04),
                  child: const DiscoveryCategories(),
                ),
                SizedBox(height: SizeConfig.screenHeight * 0.02),
                Padding(
                  padding: EdgeInsets.symmetric(
                      horizontal: SizeConfig.screenWidth * 0.04),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      Text(
                        AppLocalizations.of(context)!.resultText,
                        style: titleTextStyle,
                      ),
                      const DropdownFilter(),
                    ],
                  ),
                ),
                const SearchResult(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
