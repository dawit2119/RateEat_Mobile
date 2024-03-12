import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/restaurant_detail/presentation/bloc/restaurant_popular_reviews/restaurant_popular_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_restaurant_review/delete_restaurant_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_restaurant_reviews/get_restaurant_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/add_review_widget.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/restaurant_reviews_list.dart';

import '../widgets/review_floating_button.dart';
import '../widgets/start_middle_float.dart';

class RestaurantReviewsPage extends StatefulWidget {
  final RestaurantModel? restaurant;
  final String? loginRedirection;
  const RestaurantReviewsPage({
    super.key,
    this.restaurant,
    this.loginRedirection,
  });

  @override
  State<RestaurantReviewsPage> createState() => _RestaurantReviewsPageState();
}

class _RestaurantReviewsPageState extends State<RestaurantReviewsPage> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    context.read<RestaurantReviewsPageControllerCubit>().changePage(1);
    final restaurantReviewsBloc = context.read<GetRestaurantReviewsBloc>();
    restaurantReviewsBloc.add(
        GetRestaurantReviewsRequestEvent(restaurantId: widget.restaurant!.id!));
  }

  @override
  Widget build(BuildContext context) {
    var screenHeight = MediaQuery.of(context).size.height;

    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.pop();
          if (widget.loginRedirection != null) {
            context.pop();
            context.pop();
          }
        }
      },
      child: Scaffold(
        appBar: CustomAppBar(
          onTap: () {
            context.pop();
          },
          title: widget.restaurant!.name!,
          isBack: true,
        ),
        backgroundColor: Colors.white,
        body: Padding(
          padding: EdgeInsets.symmetric(
            vertical: 5,
            horizontal: SizeConfig.screenWidth * 0.05,
          ),
          child: SingleChildScrollView(
            controller: _scrollController,
            child: BlocConsumer<DeleteRestaurantReviewBloc,
                DeleteRestaurantReviewState>(
              listener: (context, state) {
                if (state is DeleteRestaurantReviewSuccess) {
                  //* Call to load the current Review
                  context
                      .read<RestaurantReviewsPageControllerCubit>()
                      .changePage(1);
                  context.read<GetRestaurantReviewsBloc>().add(
                        GetRestaurantReviewsRequestEvent(
                            restaurantId: widget.restaurant!.id!),
                      );
                  context.read<RestaurantPopularReviewsBloc>().add(
                        GetRestaurantPopularReviewsEvent(
                            restaurantId: widget.restaurant!.id!),
                      );
                }
              },
              builder: (context, state) {
                return Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //* Add Review Button
                    // AddReview(
                    //   restaurant: widget.restaurant,
                    //   isItem: false,
                    // ),
                    SizedBox(height: screenHeight * 0.02),
                    //* User Reviews Text
                    Text(
                      AppLocalizations.of(context)!.userReviewsText,
                      style: GoogleFonts.poppins(
                        fontSize: screenHeight * 0.021,
                        fontWeight: FontWeight.w600,
                        color: const Color(0xFF586069),
                      ),
                    ),
                    RestaurantReviewsContent(
                      restaurant: widget.restaurant!,
                    ),
                  ],
                );
              },
            ),
          ),
        ),
        floatingActionButton: ReviewFloatingButton(
          restaurant: widget.restaurant,
          isItem: false,
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.endFloat,
      ),
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<GetRestaurantReviewsBloc>().state;
    if ((state is GetRestaurantReviewsLoaded) &&
        state.hasReachedMax &&
        _isBottom) {
      return;
    }
    if (_isBottom &&
        (state is GetRestaurantReviewsLoaded) &&
        !state.hasReachedMax) {
      //* Get Previous Page
      var prevPage = context.read<RestaurantReviewsPageControllerCubit>().state;
      //* Add 1 to It
      context
          .read<RestaurantReviewsPageControllerCubit>()
          .changePage(prevPage + 1);

      context.read<GetRestaurantReviewsBloc>().add(
            GetRestaurantReviewsRequestEvent(
              restaurantId: widget.restaurant!.id!,
              page: prevPage + 1,
              sortType: state.sortType,
            ),
          );
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll == maxScroll;
  }
}

class RestaurantReviewsPageControllerCubit extends Cubit<int> {
  RestaurantReviewsPageControllerCubit() : super(1);
  void changePage(page) => emit(page);
}
