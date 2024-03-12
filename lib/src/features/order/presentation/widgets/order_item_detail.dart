import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/item_detail/item_detail.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/item_detail/item_detail_event.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/bloc/popular_item_reviews/popular_item_reviews_event.dart';
import 'package:rateeat_mobile/src/features/item_detail/presentation/pages/widgets/item_description.dart';
import 'package:rateeat_mobile/src/features/order/presentation/bloc/total_price/total_price_bloc.dart';
import 'package:rateeat_mobile/src/features/order/presentation/pages/select_orders_page.dart';
import 'package:rateeat_mobile/src/features/order/presentation/widgets/widgets.dart';

import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../item_detail/presentation/bloc/popular_item_reviews/popular_item_reviews_state.dart';
import '../../../review/domain/entities/item_reviews_response.dart';
import '../../../review/presentation/bloc/get_item_reviews/get_item_reviews_bloc.dart';
import '../../../review/presentation/widgets/item_review_card.dart';
import '../../../review/presentation/widgets/shimmer/item_review_shimmer_display.dart';

class OrderItemDetail extends StatefulWidget {
  final Item item;
  final Restaurant restaurant;
  final String currencyCode;

  const OrderItemDetail({
    super.key,
    required this.item,
    required this.restaurant,
    required this.currencyCode,
  });

  @override
  State<OrderItemDetail> createState() => _OrderItemDetailState();
}

class _OrderItemDetailState extends State<OrderItemDetail> {
  int reviewRetryCount = 0;
  int recommendationRetryCount = 0;
  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
  @override
  void initState() {
    context
        .read<GetItemReviewsBloc>()
        .add(GetItemReviewsRequestEvent(itemId: widget.item.itemId));

    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();

    return MultiBlocProvider(
      providers: [
        BlocProvider<ItemDetailBloc>(
          create: (context) => dpLocator<ItemDetailBloc>()
            ..add(GetItemDetailEvent(itemId: widget.item.itemId)),
        ),
        BlocProvider<PopularItemReviewsBloc>(
          create: (context) => dpLocator<PopularItemReviewsBloc>()
            ..add(GetPopularItemReviewsEvent(itemId: widget.item.itemId)),
        ),
      ],
      child: Scaffold(
          appBar: CustomAppBar(
            onTap: () {
              context.pop();
            },
            title: widget.item.itemName,
          ),
          body: CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: buildItemInfo(
                  widget.item,
                  context,
                ),
              ),
            ],
          ),
          bottomSheet:
              BlocBuilder<CartCubit, Map<Item, int>>(builder: (_, state) {
            return IntrinsicHeight(
              child: Container(
                width: 100.w,
                padding: EdgeInsets.symmetric(
                  horizontal: 5.w,
                  vertical: 2.h,
                ),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.only(
                    topLeft: Radius.circular(25),
                    topRight: Radius.circular(25),
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.grey200,
                      offset: Offset(1, -5),
                      blurRadius: 9,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Text(
                          "${widget.item.price.toString()} ${widget.currencyCode}",
                          style: GoogleFonts.poppins(
                            fontWeight: FontWeight.w700,
                            fontSize: 19.sp,
                          ),
                        ),
                        Flexible(
                          child: Container(
                            padding: EdgeInsets.symmetric(
                              vertical: .8.h,
                              horizontal: 3.w,
                            ),
                            decoration: const BoxDecoration(
                              color: AppColors.grey100,
                              borderRadius: BorderRadius.all(
                                Radius.circular(
                                  10,
                                ),
                              ),
                            ),
                            child: Row(
                              mainAxisSize: MainAxisSize.min,
                              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                              children: [
                                InkWell(
                                  onTap: () {
                                    context
                                        .read<CartCubit>()
                                        .removeFromCart(widget.item);
                                    context.read<TotalPriceBloc>().add(
                                          GetOrderTotalPriceEvent(
                                            cart: cartCubit.state,
                                          ),
                                        );
                                  },
                                  child: CircleAvatar(
                                    radius: 13,
                                    backgroundColor: context
                                            .read<CartCubit>()
                                            .isItemInCart(widget.item)
                                        ? const Color(0xffFF3008)
                                        : Colors.white,
                                    child: SvgPicture.asset(
                                      "assets/icons/minus.svg",
                                      fit: BoxFit.scaleDown,
                                      height: 28.sp,
                                      width: 28.sp,
                                      colorFilter: ColorFilter.mode(
                                        !context
                                                .read<CartCubit>()
                                                .isItemInCart(widget.item)
                                            ? const Color(0xffFF3008)
                                            : Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  cartCubit
                                      .getItemCount(widget.item)
                                      .toString(),
                                  style: GoogleFonts.sen(
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                InkWell(
                                  onTap: () {
                                    context
                                        .read<CartCubit>()
                                        .addToCart(widget.item);
                                    context.read<TotalPriceBloc>().add(
                                          GetOrderTotalPriceEvent(
                                            cart: cartCubit.state,
                                          ),
                                        );
                                  },
                                  child: CircleAvatar(
                                    radius: 13,
                                    backgroundColor: const Color(0xffFF3008),
                                    child: SvgPicture.asset(
                                      "assets/icons/plus_2.svg",
                                      fit: BoxFit.scaleDown,
                                      height: 28.sp,
                                      width: 28.sp,
                                      colorFilter: const ColorFilter.mode(
                                        Colors.white,
                                        BlendMode.srcIn,
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ],
                    ),
                    SizedBox(
                      height: 1.6.h,
                    ),

                    // Button
                    InkWell(
                      onTap: () {
                        if (state.isNotEmpty) {
                          context.read<TotalPriceBloc>().add(
                                GetOrderTotalPriceEvent(
                                  cart: state,
                                ),
                              );
                          context.pushNamed(
                            AppRoutes.cartPage,
                            extra: widget.restaurant,
                          );
                        }
                      },
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                          vertical: 16,
                          horizontal: 24,
                        ),
                        decoration: BoxDecoration(
                          color: (state.isEmpty)
                              ? AppColors.grey400
                              : AppColors.primaryColor,
                          borderRadius: BorderRadius.circular(20),
                          boxShadow: [
                            BoxShadow(
                              color: (state.isEmpty)
                                  ? AppColors.grey400
                                  : AppColors.primaryColor.withOpacity(0.7),
                              blurRadius: 5,
                              spreadRadius: 1,
                            ),
                          ],
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Row(
                              children: [
                                Icon(
                                  Iconsax.reserve5,
                                  color: Colors.white,
                                  size: 18.sp,
                                ),
                                SizedBox(
                                  width: 2.w,
                                ),
                                Text(
                                  "${cartCubit.getTotalItemCount()} Items",
                                  style: GoogleFonts.poppins(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 18.sp,
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(
                              width: 3.w,
                            ),
                            Text(
                              "${cartCubit.calculateTotalPrice()} ${widget.currencyCode}",
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 18.sp,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            );
          })),
    );
  }

  Widget buildItemInfo(item, context) {
    return Column(
      key: const Key('item_detail_info'),
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Container(
          margin: EdgeInsets.symmetric(
            horizontal: 2.5.w,
            vertical: 1.h,
          ),
          width: 95.w,
          height: 20.h,
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(
                color: Color(0x146a737d),
              ),
            ],
          ),
          child: ClipRRect(
            borderRadius: BorderRadius.circular(10.0),
            child: CachedNetworkImage(
              imageUrl: item.imageUrl ??
                  "https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJ1cmdlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80",
              fit: BoxFit.cover,
              errorWidget: (context, url, error) {
                return const Center(
                  child: Icon(
                    Icons.error,
                    color: Colors.red,
                  ),
                );
              },
              progressIndicatorBuilder: (context, url, progress) =>
                  Shimmer.fromColors(
                baseColor: AppColors.shimmerBaseColor,
                highlightColor: AppColors.grey100,
                child: Container(
                  color: Colors.white,
                ),
              ),
            ),
          ),
        ),
        Padding(
          padding: EdgeInsets.symmetric(horizontal: 5.w),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(height: 1.h),
              OrderItemTitle(
                item: item,
                currencyCode: widget.currencyCode,
              ),
              ItemDescription(
                desc: item.description!,
                ingredients: item.ingredients!,
              ),
              SizedBox(height: 2.h),

              BlocBuilder<GetItemReviewsBloc, GetItemReviewsState>(
                builder: (context, state) {
                  ItemReviewsResponse? response;
                  if (state is GetItemReviewsLoaded) {
                    response = state.reviews;
                  }
                  if ((response != null && response.numberOfReviews != 0) &&
                      (state is! GetItemReviewsLoading)) {
                    return Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          AppLocalizations.of(context)!.userReviewsText,
                          style: TextStyle(
                            fontSize: 16.2.sp,
                            fontWeight: FontWeight.bold,
                            color: const Color(0xff434343),
                          ),
                        ),
                        Container(
                          margin: const EdgeInsets.symmetric(
                            vertical: 4,
                          ),
                          child: RatingDisplayBars(
                            averageRating: response.averageRating,
                            data: response.ratingsCount,
                            numberOfReviews: response.numberOfReviews,
                            isOrdering: true,
                            onTap: () {
                              context.pushNamed(
                                AppRoutes.itemReviews,
                                pathParameters: {'itemId': item.itemId},
                                extra: {
                                  'item': item,
                                },
                              );
                            },
                          ),
                        ),
                        SizedBox(height: 100.h * 0.005),
                      ],
                    );
                  }
                  return Container();
                },
              ),
              Text(
                AppLocalizations.of(context)!.popularReviewText,
                style: GoogleFonts.poppins(
                  fontSize: 16.2.sp,
                  fontWeight: FontWeight.bold,
                  color: const Color(0xff434343),
                ),
              ),
              SizedBox(height: 1.h),

              //* Popular Reviews
              BlocBuilder<PopularItemReviewsBloc, PopularItemReviewsState>(
                builder: (context, state) {
                  if (state is PopularItemReviewLoading) {
                    return const ReviewItemShimmerDisplay();
                  } else if (state is PopularItemReviewsLoaded) {
                    final reviews = state.popularReviews.reviews;
                    if (reviews.isEmpty) {
                      return Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Center(
                            child: Text(
                              AppLocalizations.of(context)!.noReviewsText,
                              style: GoogleFonts.poppins(
                                fontSize: 16.sp,
                              ),
                            ),
                          ),
                          SizedBox(height: 2.h),
                        ],
                      );
                    }
                    return Column(
                      children: [
                        ListView.builder(
                            physics: const NeverScrollableScrollPhysics(),
                            shrinkWrap: true,
                            itemCount: reviews.length,
                            scrollDirection: Axis.vertical,
                            itemBuilder: (context, index) {
                              final currentReview = reviews[index];
                              return ItemReviewsCard(
                                item: widget.item as ItemModel,
                                userReview: currentReview,
                              );
                            }),
                        if (item.numberOfReviews > reviews.length)
                          Row(
                            mainAxisAlignment: MainAxisAlignment.spaceBetween,
                            children: [
                              Container(),
                              SingleChip(
                                selected: true,
                                title: AppLocalizations.of(context)!.seeText,
                                onTap: () {
                                  context.pushNamed(
                                    AppRoutes.itemReviews,
                                    pathParameters: {'itemId': item.itemId},
                                    extra: {
                                      'item': item,
                                    },
                                  );
                                },
                              ),
                            ],
                          ),
                        const SizedBox(
                          height: 10,
                        ),
                      ],
                    );
                  } else if (state is PopularItemReviewsFailure) {
                    if (reviewRetryCount < 3) {
                      reviewRetryCount++;
                      context.read<PopularItemReviewsBloc>().add(
                          GetPopularItemReviewsEvent(
                              itemId: widget.item.itemId));
                      return Container();
                    } else {
                      reviewRetryCount = 0;
                      return Center(
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: <Widget>[
                            Text(
                              AppLocalizations.of(context)!.noRevText,
                              style: const TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.w400,
                              ),
                            ),
                            SizedBox(height: 1.h),
                            ElevatedButton(
                              onPressed: () {
                                context.read<PopularItemReviewsBloc>().add(
                                      GetPopularItemReviewsEvent(
                                        itemId: widget.item.itemId,
                                      ),
                                    );
                              },
                              style: ButtonStyle(
                                backgroundColor:
                                    WidgetStateProperty.all<Color>(Colors.red),
                              ),
                              child: Text(
                                AppLocalizations.of(context)!.retryText,
                                style: GoogleFonts.poppins(
                                  color: Colors.white,
                                ),
                              ),
                            ),
                          ],
                        ),
                      );
                    }
                  } else {
                    return Container();
                  }
                },
              ),
            ],
          ),
        ),
      ],
    );
  }
}
