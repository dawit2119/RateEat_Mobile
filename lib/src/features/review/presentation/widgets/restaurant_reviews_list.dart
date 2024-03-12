import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/review/domain/entities/restaurant_reviews_response.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_restaurant_reviews/get_restaurant_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/restaurant_reviews_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/restaurant_review_card.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/restaurant_review_sorting_dropdown.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/shimmer/restaurant_review_shimmer.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class RestaurantReviewsContent extends StatefulWidget {
  final RestaurantModel restaurant;
  const RestaurantReviewsContent({
    required this.restaurant,
    super.key,
  });

  @override
  State<RestaurantReviewsContent> createState() =>
      _RestaurantReviewsContentState();
}

class _RestaurantReviewsContentState extends State<RestaurantReviewsContent> {
  RestaurantReviewsResponse? response;
  mapReviews(reviews) {
    if (reviews != null) {
      return reviews!.map((currentReview) {
        return RestaurantReviewsCard(
          restaurant: widget.restaurant,
          userReview: currentReview,
          redirectionRoute: AppRoutes.restaurantReviews,
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
        BlocBuilder<GetRestaurantReviewsBloc, GetRestaurantReviewsState>(
          builder: (context, state) {
            if (state is GetRestaurantReviewsLoaded) {
              response = state.reviews;
            }
            return ((response != null && response!.numberOfReviews != 0) &&
                    (state is! GetRestaurantReviewsLoading))
                ? Column(
                    children: [
                      //* Average Rating display
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
                          RestaurantReviewSortingDropdown(
                              restaurantId: widget.restaurant.id!),
                        ],
                      ),
                    ],
                  )
                : Container();
          },
        ),

        //*  List of reviews
        BlocBuilder<GetRestaurantReviewsBloc, GetRestaurantReviewsState>(
          builder: (context, state) {
            if (state is GetRestaurantReviewsFailure) {
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
                        context.read<GetRestaurantReviewsBloc>().add(
                              GetRestaurantReviewsRequestEvent(
                                restaurantId: widget.restaurant.id!,
                              ),
                            );
                      },
                      style: ButtonStyle(
                        backgroundColor:
                            WidgetStateProperty.all<Color>(Colors.red),
                      ),
                      child: Text(
                        AppLocalizations.of(context)!.retryText,
                        style: const TextStyle(color: Colors.white),
                      ),
                    ),
                    verticalPadding(height: 3),
                  ],
                ),
              );
            } else if (state is GetRestaurantReviewsLoading) {
              return const RestaurantShimmerDisplay();
            } else if (state is GetRestaurantReviewsNextLoading) {
              return _buildReviewList(
                restaurantReviews: state.reviews,
                nextLoading: true,
                state: state,
              );
            } else if (state is GetRestaurantReviewsLoaded) {
              if (state.status == false) {
                var prevPage =
                    context.read<RestaurantReviewsPageControllerCubit>().state;
                context
                    .read<RestaurantReviewsPageControllerCubit>()
                    .changePage(prevPage - 1);
              }
              final restaurantReviews = state.reviews;
              if (restaurantReviews.reviews.isEmpty) {
                return Center(
                  child: Column(
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
                  ),
                );
              }
              return _buildReviewList(
                restaurantReviews: restaurantReviews,
                nextLoading: false,
                state: state,
              );
            } else {
              return Container();
            }
          },
        )
      ],
    );
  }

  Widget _buildReviewList(
      {required RestaurantReviewsResponse restaurantReviews,
      required bool nextLoading,
      required GetRestaurantReviewsState state}) {
    return Column(
      children: [
        ...mapReviews(restaurantReviews.reviews).toList(),
        nextLoading
            ? Column(
                children: [
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                  const RestaurantShimmerDisplay(
                    shimmerCount: 1,
                  ),
                  SizedBox(height: SizeConfig.screenHeight * 0.01),
                ],
              )
            : Container(),
        if ((state is GetRestaurantReviewsLoaded) && state.hasReachedMax)
          // A text widget that say's That's All
          Padding(
            padding: const EdgeInsets.all(16.0),
            child: Center(
              child: Text(
                "This are all the reviews for this restaurant :( ",
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
