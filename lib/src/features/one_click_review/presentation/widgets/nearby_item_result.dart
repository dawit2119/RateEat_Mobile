import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/widgets/error_and_info_widget.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/nearby_items/nearby_item_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/item_and_restaurant_results_shimmer.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/nearby_item_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class NearByItemResult extends StatefulWidget {
  const NearByItemResult({super.key});

  @override
  State<NearByItemResult> createState() => _NearByItemResultState();
}

class _NearByItemResultState extends State<NearByItemResult> {
  final _itemScrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _itemScrollController.addListener(_onItemScroll);

    //* Get Restaurant Items
    final restaurant = context
        .read<SimpleReviewStepperBloc>()
        .state
        .simpleAddReviewStepperProps
        .restaurant;
    context.read<NearbyItemBloc>().add(
          GetNearbyItemsEvent(
            restaurantId: restaurant!.id!,
            itemName: '',
            page: 1,
          ),
        );

    context.read<NearByItemPageCubit>().changePage(1);
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return BlocBuilder<NearbyItemBloc, NearbyItemState>(
      builder: (context, state) {
        if (state is NearbyItemNextLoaded) {
          final items = state.nearbyItems;
          return SingleChildScrollView(
            controller: _itemScrollController,
            child: Column(
              children: [
                ...mapItems(items).toList(),
                Column(
                  children: [
                    SizedBox(height: screenHeight * 0.01),
                    const ItemAndRestaurantResultsShimmer(shimmerCount: 10),
                    SizedBox(height: screenHeight * 0.01),
                  ],
                )
              ],
            ),
          );
        } else if (state is NearbyItemLoaded) {
          if (state.status == false) {
            var prevPage = context.read<NearByItemPageCubit>().state;
            context.read<NearByItemPageCubit>().changePage(prevPage - 1);
          }
          if (state.nearbyItems.isEmpty) {
            return const EmptyResultWidget();
          }
          final items = state.nearbyItems;
          return SingleChildScrollView(
            controller: _itemScrollController,
            child: Column(
              children: [
                ...mapItems(items).toList(),
                if (state.hasReachedMax)
                  // A text widget that say's That's All
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "${AppLocalizations.of(context)!.noMoreItemsText} :(",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                SizedBox(
                  height: 10.h,
                ),
              ],
            ),
          );
        } else if (state is NearbyItemLoading) {
          return const ItemAndRestaurantResultsShimmer(shimmerCount: 10);
        } else if (state is NearbyItemFailure) {
          return ErrorAndInfoDisplayWidget(
            assetImage: "assets/icons/no_internet.svg",
            title: AppLocalizations.of(context)!.unableToLoadItemsText,
            description:
                "${AppLocalizations.of(context)!.loadingResultsFailedText}. ${AppLocalizations.of(context)!.tryAgainOnlyText}",
            onPressed: () {
              //* Get Restaurant Items
              final restaurant = context
                  .read<SimpleReviewStepperBloc>()
                  .state
                  .simpleAddReviewStepperProps
                  .restaurant;
              context.read<NearbyItemBloc>().add(
                    GetNearbyItemsEvent(
                      restaurantId: restaurant!.id!,
                      itemName: state.itemName,
                      page: 1,
                    ),
                  );
            },
          );
        }
        return Container();
      },
    );
  }

  mapItems(items) {
    if (items != null) {
      return items!.map<NearByItemCard>(
        (item) {
          return NearByItemCard(item: item);
        },
      ).toList();
    }
    return [];
  }

  @override
  void dispose() {
    _itemScrollController
      ..removeListener(_onItemScroll)
      ..dispose();
    super.dispose();
  }

  void _onItemScroll() {
    final state = context.read<NearbyItemBloc>().state;
    if ((state is NearbyItemLoaded) && state.hasReachedMax && _isItemBottom) {
      return;
    }
    if (_isItemBottom && (state is NearbyItemLoaded) && !state.hasReachedMax) {
      var prevPage = context.read<NearByItemPageCubit>().state;
      context.read<NearByItemPageCubit>().changePage(prevPage + 1);

      final restaurant = context
          .read<SimpleReviewStepperBloc>()
          .state
          .simpleAddReviewStepperProps
          .restaurant;
      context.read<NearbyItemBloc>().add(
            GetNearbyItemsEvent(
              restaurantId: restaurant!.id!,
              itemName: state.itemName,
              page: prevPage + 1,
            ),
          );
    }
  }

  bool get _isItemBottom {
    if (!_itemScrollController.hasClients) return false;
    return _itemScrollController.position.maxScrollExtent ==
        _itemScrollController.position.pixels;
  }
}

class NearByItemPageCubit extends Cubit<int> {
  NearByItemPageCubit() : super(1);
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
            AppLocalizations.of(context)!.searchedItemNotFoundText,
            style: const TextStyle(fontSize: 12),
          )
        ],
      ),
    );
  }
}
