import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/item_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_item_reviews/get_item_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/item_reviews_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/item_review_card.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/item_review_sorting_dropdown.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/shimmer/item_review_shimmer_display.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class ItemReviewsContent extends StatefulWidget {
  final ItemModel item;
  const ItemReviewsContent({
    super.key,
    required this.item,
  });

  @override
  State<ItemReviewsContent> createState() => _ItemReviewsContentState();
}

class _ItemReviewsContentState extends State<ItemReviewsContent> {
  ItemReviewsResponse? response;
  mapReviews(reviews) {
    if (reviews != null) {
      return reviews!.map((currentReview) {
        return ItemReviewsCard(
          item: widget.item,
          userReview: currentReview,
          redirectionRoute: AppRoutes.itemReviews,
        );
      });
    }
    return [];
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return Column(
      children: [
        //* Average Rating display
        BlocBuilder<GetItemReviewsBloc, GetItemReviewsState>(
          builder: (context, state) {
            if (state is GetItemReviewsLoaded) {
              response = state.reviews;
            }
            if ((response != null && response!.numberOfReviews != 0) &&
                (state is! GetItemReviewsLoading)) {
              return Column(
                children: [
                  Container(
                    margin: const EdgeInsets.symmetric(
                      vertical: 6,
                    ),
                    child: RatingDisplayBars(
                      averageRating: response!.averageRating,
                      data: response!.ratingsCount,
                      numberOfReviews: response!.numberOfReviews,
                    ),
                  ),
                  SizedBox(height: screenHeight * 0.005),

                  //* Dropdown selector
                  Row(
                    mainAxisAlignment: MainAxisAlignment.end,
                    children: [
                      ItemReviewSortingDropdown(itemId: widget.item.itemId),
                    ],
                  ),
                ],
              );
            }
            return Container();
          },
        ),

        //*  List of reviews
        BlocBuilder<GetItemReviewsBloc, GetItemReviewsState>(
          builder: (context, state) {
            if (state is GetItemReviewsLoading) {
              return const ReviewItemShimmerDisplay();
            } else if (state is GetItemReviewsNextLoading) {
              return _buildReviewList(
                itemReviews: state.reviews,
                nextLoading: true,
                state: state,
              );
            } else if (state is GetItemReviewsLoaded) {
              if (state.status == false) {
                var prevPage =
                    context.read<ItemReviewsPageControllerCubit>().state;
                context
                    .read<ItemReviewsPageControllerCubit>()
                    .changePage(prevPage - 1);
              }
              final itemReviews = state.reviews;
              if (itemReviews.reviews.isEmpty) {
                return Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    SizedBox(height: screenHeight * 0.04),
                    Center(
                      child: Text(
                        AppLocalizations.of(context)!.firstReviewText,
                        style: GoogleFonts.poppins(
                          fontSize: 16.sp,
                        ),
                      ),
                    ),
                    SizedBox(height: screenHeight * 0.02),
                  ],
                );
              }
              return _buildReviewList(
                  itemReviews: itemReviews, nextLoading: false, state: state);
            } else if (state is GetItemReviewsFailure) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: <Widget>[
                    Text(
                      AppLocalizations.of(context)!.errorReviewText,
                      style: const TextStyle(
                        color: Colors.red,
                        fontWeight: FontWeight.w400,
                      ),
                    ),
                    SizedBox(
                        height: screenHeight *
                            0.01), // Add spacing between text and button
                    ElevatedButton(
                      onPressed: () {
                        context.read<GetItemReviewsBloc>().add(
                              GetItemReviewsRequestEvent(
                                itemId: widget.item.itemId,
                              ),
                            );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.red),
                      ),
                      child: Text(AppLocalizations.of(context)!.retryText,
                          style: const TextStyle(color: Colors.white)),
                    ),
                  ],
                ),
              );
            } else {
              return Container();
            }
          },
        ),
      ],
    );
  }

  Widget _buildReviewList(
      {required ItemReviewsResponse itemReviews,
      required bool nextLoading,
      required GetItemReviewsState state}) {
    return Column(
      children: [
        ...mapReviews(itemReviews.reviews).toList(),
        nextLoading
            ? Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  const ReviewItemShimmerDisplay(
                    shimmerCount: 1,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                ],
              )
            : Container(),
        if ((state is GetItemReviewsLoaded) && state.hasReachedMax)
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "This are all the reviews for this item  :( ",
                style: GoogleFonts.poppins(
                  color: Colors.grey,
                  fontSize: 13,
                ),
              ),
            ),
          ),
      ],
    );
  }
}
