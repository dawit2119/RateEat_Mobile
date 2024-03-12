import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/widgets/error_and_info_widget.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_restaurant_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/nearby_restaurant/nearby_restaurant_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/item_and_restaurant_results_shimmer.dart';

import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/nearby_restaurant_card.dart';
import 'package:rateeat_mobile/src/features/search_result/presentation/widgets/shimmer/restaurant_search_result_shimmer.dart';

class NearByRestaurants extends StatefulWidget {
  const NearByRestaurants({super.key});

  @override
  State<NearByRestaurants> createState() => _NearByRestaurantsState();
}

class _NearByRestaurantsState extends State<NearByRestaurants> {
  final _restaurantScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _restaurantScrollController.addListener(_onRestaurantScroll);
    var locationState = context.read<UserLocationBloc>().state;
    if (locationState is UserLocationLoaded) {
      context.read<NearByRestaurantBloc>().add(
            GetNearbyRestaurantEvent(
              searchQuery: '',
              latitude: locationState.location.latitude,
              longitude: locationState.location.longitude,
              radius: 2000,
              page: 1,
            ),
          );
    }
    context.read<NearByRestaurantPageCubit>().changePage(1);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    final locationState = BlocProvider.of<UserLocationBloc>(context).state;
    return BlocBuilder<NearByRestaurantBloc, NearByRestaurantState>(
      builder: (context, restaurantState) {
        if (restaurantState is NearbyRestaurantFailure) {
          return Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: <Widget>[
                ErrorAndInfoDisplayWidget(
                  assetImage: "assets/icons/no_internet.svg",
                  title: AppLocalizations.of(context)!.loadingResultsFailedText,
                  description:
                      "${AppLocalizations.of(context)!.loadingResultsFailedText}. ${AppLocalizations.of(context)!.tryAgainOnlyText}",
                  onPressed: () {
                    if (locationState is UserLocationLoaded) {
                      context.read<NearByRestaurantBloc>().add(
                            GetNearbyRestaurantEvent(
                              latitude: locationState.location.latitude,
                              longitude: locationState.location.longitude,
                              searchQuery: restaurantState.searchQuery,
                              radius: 2000,
                              page: 1,
                            ),
                          );
                    }
                  },
                ),
              ],
            ),
          );
        }
        if (restaurantState is NearbyRestaurantNextLoaded) {
          final restaurants = restaurantState.nearbyRestaurants;
          return SingleChildScrollView(
            controller: _restaurantScrollController,
            child: Column(
              children: [
                ...mapRestaurants(restaurants).toList(),
                Column(
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    const RestaurantResultsShimmer(
                      shimmerCount: 1,
                    ),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                )
              ],
            ),
          );
        } else if (restaurantState is NearbyRestaurantLoaded) {
          if (restaurantState.status == false) {
            var prevPage = context.read<NearByRestaurantPageCubit>().state;
            context.read<NearByRestaurantPageCubit>().changePage(prevPage - 1);
          }
          if (restaurantState.nearbyRestaurants.isEmpty) {
            return const EmptyResultWidget();
          }
          final restaurants = restaurantState.nearbyRestaurants;
          return SingleChildScrollView(
            controller: _restaurantScrollController,
            child: Column(
              children: [
                ...mapRestaurants(restaurants).toList(),
                if (restaurantState.hasReachedMax)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "${AppLocalizations.of(context)!.noMoreRestaurantsText} :(",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        } else if (restaurantState is NearbyRestaurantLoading) {
          return const ItemAndRestaurantResultsShimmer(shimmerCount: 10);
        }
        return Container();
      },
    );
  }

  mapRestaurants(List<NearByRestaurantResponse> restaurants) {
    return restaurants.map(
      (restaurant) => NearByRestaurantCard(restaurant: restaurant),
    );
  }

  @override
  void dispose() {
    _restaurantScrollController
      ..removeListener(_onRestaurantScroll)
      ..dispose();
    super.dispose();
  }

  void _onRestaurantScroll() {
    final state = context.read<NearByRestaurantBloc>().state;
    final locationState = context.read<UserLocationBloc>().state;
    if ((state is NearbyRestaurantLoaded) &&
        state.hasReachedMax &&
        _isRestaurantBottom) {
      return;
    }
    if (_isRestaurantBottom &&
        (state is NearbyRestaurantLoaded) &&
        !state.hasReachedMax) {
      var prevPage = context.read<NearByRestaurantPageCubit>().state;
      context.read<NearByRestaurantPageCubit>().changePage(prevPage + 1);
      if (locationState is UserLocationLoaded) {
        context.read<NearByRestaurantBloc>().add(
              GetNearbyRestaurantEvent(
                page: prevPage + 1,
                searchQuery: state.searchQuery,
                latitude: locationState.location.latitude,
                longitude: locationState.location.longitude,
                radius: 2000,
              ),
            );
      }
    }
  }

  bool get _isRestaurantBottom {
    if (!_restaurantScrollController.hasClients) return false;
    return _restaurantScrollController.position.maxScrollExtent ==
        _restaurantScrollController.position.pixels;
  }
}

class NearByRestaurantPageCubit extends Cubit<int> {
  NearByRestaurantPageCubit() : super(1);
  void changePage(page) => emit(page);
}

class EmptyResultWidget extends StatelessWidget {
  const EmptyResultWidget({super.key});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        children: [
          Center(
            child: SvgPicture.asset(
              "assets/icons/no_content.svg",
            ),
          ),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              AppLocalizations.of(context)!.noResultText,
              style: const TextStyle(color: Colors.red, fontSize: 16),
            ),
          ),
          Text(
            AppLocalizations.of(context)!.couldNotFindNearbyRestaurants,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
