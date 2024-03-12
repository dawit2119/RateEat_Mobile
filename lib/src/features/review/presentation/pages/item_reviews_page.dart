import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/popular_item_reviews/popular_item_reviews_event.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_item_review/delete_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_item_reviews/get_item_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/add_review_widget.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/item_reviews_list.dart';

class ItemReviewsPage extends StatefulWidget {
  final ItemModel? item;
  final String? loginRedirection;
  const ItemReviewsPage({
    super.key,
    this.item,
    this.loginRedirection,
  });

  @override
  State<ItemReviewsPage> createState() => _ItemReviewsPageState();
}

class _ItemReviewsPageState extends State<ItemReviewsPage> {
  final _scrollController = ScrollController();
  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);

    context.read<ItemReviewsPageControllerCubit>().changePage(1);
    final itemReviewsBloc = context.read<GetItemReviewsBloc>();
    itemReviewsBloc.add(
      GetItemReviewsRequestEvent(itemId: widget.item!.itemId),
    );
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
          title: widget.item!.itemName,
        ),
        backgroundColor: Colors.white,
        body: SingleChildScrollView(
          controller: _scrollController,
          child: BlocConsumer<DeleteItemReviewBloc, DeleteItemReviewState>(
            listener: (context, state) {
              if (state is DeleteItemReviewSuccess) {
                //* Call to load the current Review
                context.read<ItemReviewsPageControllerCubit>().changePage(1);
                context.read<GetItemReviewsBloc>().add(
                    GetItemReviewsRequestEvent(itemId: widget.item!.itemId));
                context.read<PopularItemReviewsBloc>().add(
                    GetPopularItemReviewsEvent(itemId: widget.item!.itemId));
              }
            },
            builder: (context, state) {
              return Container(
                margin: EdgeInsets.symmetric(
                  vertical: 5,
                  horizontal: SizeConfig.screenWidth * 0.05,
                ),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    //* Add Review Button
                    AddReview(
                      item: widget.item,
                      isItem: true,
                    ),
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

                    //* All Item Reviews
                    ItemReviewsContent(
                      item: widget.item!,
                    )
                  ],
                ),
              );
            },
          ),
        ),
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
    final state = context.read<GetItemReviewsBloc>().state;
    if ((state is GetItemReviewsLoaded) && state.hasReachedMax && _isBottom) {
      return;
    }
    if (_isBottom && (state is GetItemReviewsLoaded) && !state.hasReachedMax) {
      //* Get Previous Page
      var prevPage = context.read<ItemReviewsPageControllerCubit>().state;
      //* Add 1 to It
      context.read<ItemReviewsPageControllerCubit>().changePage(prevPage + 1);
      context.read<GetItemReviewsBloc>().add(
            GetItemReviewsRequestEvent(
              itemId: widget.item!.itemId,
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

class ItemReviewsPageControllerCubit extends Cubit<int> {
  ItemReviewsPageControllerCubit() : super(1);
  void changePage(page) => emit(page);
}
