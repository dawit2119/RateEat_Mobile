import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'package:rateeat_mobile/src/features/order/presentation/widgets/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:shimmer/shimmer.dart';

import '../../../../../l10n/gen_l10n/app_localizations.dart';
import '../../../../core/core.dart';

class EditQROrderSummaryPage extends StatefulWidget {
  final Restaurant restaurant;
  const EditQROrderSummaryPage({
    super.key,
    required this.restaurant,
  });
  @override
  EditQROrderSummaryPageState createState() => EditQROrderSummaryPageState();
}

class EditQROrderSummaryPageState extends State<EditQROrderSummaryPage> {
  final TextEditingController note = TextEditingController();
  final FocusNode node = FocusNode();
  final ScrollController _controller = ScrollController();
  String orderType = "DineIn";

  void focusListner() {
    if (node.hasFocus) {
      Future.delayed(const Duration(seconds: 1), () {
        _controller.jumpTo(_controller.position.maxScrollExtent);
      });
    }
  }

  @override
  void initState() {
    super.initState();
    node.addListener(focusListner);
    orderType =
        context.read<EditQROrderBloc>().state.order?.orderType ?? "DineIn";
    note.text = context.read<EditQROrderBloc>().state.order?.orderMessage ?? "";
  }

  @override
  void dispose() {
    node
      ..removeListener(focusListner)
      ..dispose();
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final cartCubit = context.read<CartCubit>();
    return Scaffold(
      appBar: CustomAppBar(
        onTap: () {
          context.pop();
        },
        title: widget.restaurant.name!,
      ),
      body: BlocBuilder<EditQROrderBloc, EditQROrderState>(
        builder: (context, state) {
          return SingleChildScrollView(
            controller: _controller,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                SizedBox(
                  height: 4.h,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                    horizontal: 12,
                  ),
                  child: Text(
                    "Selected Items",
                    style: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 18.sp,
                    ),
                  ),
                ),
                ...context.read<EditQROrderBloc>().getItems().keys.map(
                      (item) => EditOrderCartItemCard(
                        item: item,
                        currencyCode: widget.restaurant.currencyCode,
                        setState: setState,
                      ),
                    ),
                SizedBox(
                  height: 1.h,
                ),
                InkWell(
                  onTap: () {
                    context.pop();
                  },
                  child: Center(
                    child: Container(
                      width: 90.w,
                      padding: EdgeInsets.symmetric(
                        vertical: .8.h,
                        horizontal: 1.w,
                      ),
                      decoration: BoxDecoration(
                        border: Border.all(
                          color: AppColors.primaryColor,
                        ),
                        borderRadius: BorderRadius.circular(
                          15,
                        ),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          SvgPicture.asset(
                            "assets/icons/plus_2.svg",
                            fit: BoxFit.scaleDown,
                            height: 25.sp,
                            width: 25.sp,
                            colorFilter: const ColorFilter.mode(
                              Color(0xffFF3008),
                              BlendMode.srcIn,
                            ),
                          ),
                          Text(
                            "Add more items",
                            style: GoogleFonts.poppins(
                              fontWeight: FontWeight.w500,
                              fontSize: 17.sp,
                              color: const Color(0xffFF3008),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                SizedBox(
                  height: 1.h,
                ),
                Container(
                  padding: const EdgeInsets.all(16),
                  margin: EdgeInsets.symmetric(
                    horizontal: 3.2.w,
                    vertical: 10,
                  ),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    border: Border.all(
                      color: const Color(
                        0xffE1E4E8,
                      ),
                    ),
                    borderRadius: BorderRadius.circular(
                      15,
                    ),
                  ),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Payment Summary",
                        style: GoogleFonts.plusJakartaSans(
                          fontWeight: FontWeight.w600,
                          fontSize: 18,
                        ),
                      ),
                      ...state.items.keys.map(
                        (item) => PaymentItem(
                          title: item.name,
                          price: (state.items[item]! * item.price)
                              .toStringAsFixed(2),
                          count: state.items[item] ?? 0,
                          currencyCode: widget.restaurant.currencyCode,
                        ),
                      ),
                      const Divider(),
                      PaymentItem(
                        title: 'Total',
                        price: context
                            .read<EditQROrderBloc>()
                            .calculateTotalPrice()
                            .toString(),
                        isTotal: true,
                        count: 0,
                        currencyCode: widget.restaurant.currencyCode,
                      ),
                    ],
                  ),
                ),
                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: Row(
                //     children: [
                //       Expanded(
                //         child: GestureDetector(
                //           onTap: () {
                //             setState(() {
                //               orderType = "DineIn";
                //             });
                //           },
                //           child: Container(
                //             margin: EdgeInsets.symmetric(horizontal: 2.w),
                //             height: 7.h,
                //             decoration: BoxDecoration(
                //               border: Border.all(
                //                 color: orderType == "DineIn"
                //                     ? AppColors.primaryColor
                //                     : const Color(0xffE1E4E8),
                //                 width: orderType == "DineIn" ? 2 : 1,
                //               ),
                //               borderRadius: BorderRadius.circular(10),
                //             ),
                //             child: Center(
                //               child: Text(
                //                 "Dine In",
                //                 style: GoogleFonts.poppins(
                //                   fontSize: 16.sp,
                //                   fontWeight: FontWeight.w500,
                //                   color: orderType == "DineIn"
                //                       ? AppColors.primaryColor
                //                       : const Color(0xff6A737D),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //       Expanded(
                //         child: GestureDetector(
                //           onTap: () {
                //             setState(() {
                //               orderType = "Takeaway";
                //             });
                //           },
                //           child: Container(
                //             margin: EdgeInsets.symmetric(horizontal: 2.w),
                //             height: 7.h,
                //             decoration: BoxDecoration(
                //               border: Border.all(
                //                 color: orderType == "Takeaway"
                //                     ? AppColors.primaryColor
                //                     : const Color(0xffE1E4E8),
                //                 width: orderType == "Takeaway" ? 2 : 1,
                //               ),
                //               borderRadius: BorderRadius.circular(10),
                //             ),
                //             child: Center(
                //               child: Text(
                //                 "Takeaway",
                //                 style: GoogleFonts.poppins(
                //                   fontSize: 16.sp,
                //                   fontWeight: FontWeight.w500,
                //                   color: orderType == "Takeaway"
                //                       ? AppColors.primaryColor
                //                       : const Color(0xff6A737D),
                //                 ),
                //               ),
                //             ),
                //           ),
                //         ),
                //       ),
                //     ],
                //   ),
                // ),
                // //* Note Section
                // Padding(
                //   padding: const EdgeInsets.all(12.0),
                //   child: AddNoteField(
                //     title: "Order note",
                //     hintText: "Ex: No onion on the burger",
                //     textEditingController: note,
                //     focusNode: node,
                //   ),
                // ),
                SizedBox(height: 20.h),
              ],
            ),
          );
        },
      ),
      bottomSheet: Container(
        width: 100.w,
        padding: EdgeInsets.symmetric(
          horizontal: 5.w,
          vertical: 1.8.h,
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
        child: SingleChildScrollView(
          child: Column(
            children: [
              Padding(
                padding: EdgeInsets.symmetric(vertical: .9.h),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: <Widget>[
                    Text(
                      "Total",
                      style: GoogleFonts.poppins(
                        fontWeight: FontWeight.w500,
                        fontSize: 17.sp,
                        color: const Color(0xff6A737D),
                      ),
                    ),
                    Text(
                      "${context.read<EditQROrderBloc>().calculateTotalPrice()} ${widget.restaurant.currencyCode}",
                      style: GoogleFonts.poppins(
                        fontSize: 18.sp,
                        fontWeight: FontWeight.w700,
                      ),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 1.h,
              ),
              BlocConsumer<EditQROrderBloc, EditQROrderState>(
                listener: (_, state) {
                  if (state is EditQROrderSuccess) {
                    context.read<EditQROrderBloc>().add(ClearOrder());
                    showCustomToast(
                        context: context,
                        toastType: ToastType.success,
                        toastMessage: "Order Updated Successfully");
                    Future.delayed(const Duration(milliseconds: 500), () {
                      if (context.mounted) {
                        context.pushReplacementNamed(
                          AppRoutes.orderStatusPage,
                          extra: {
                            "order_id": state.order?.id ?? "",
                            "restaurant": widget.restaurant,
                          },
                        );
                      }
                    });
                  }
                  if (state is EditQROrderFailure) {
                    showCustomToast(
                      context: context,
                      toastMessage: state.errorMessage,
                      toastType: ToastType.warning,
                      showIcon: false,
                    );
                  }
                  setState(() {});
                },
                builder: (context, orderState) {
                  return OrderButton(
                    color: (orderState is EditQROrderLoading)
                        ? const Color(0xffFF3008).withOpacity(0.4)
                        : (context.read<EditQROrderBloc>().state.items.isEmpty)
                            ? AppColors.grey400
                            : AppColors.primaryColor,
                    shadowColor:
                        (context.read<EditQROrderBloc>().state.items.isEmpty)
                            ? AppColors.grey400
                            : AppColors.primaryColor.withOpacity(0.7),
                    onTap: (context.read<EditQROrderBloc>().state.items.isEmpty)
                        ? () {}
                        : () async {
                            if (orderState is! EditQROrderLoading) {
                              context.read<EditQROrderBloc>().add(
                                    PlaceUpdatedOrder(
                                      orderId: context
                                              .read<EditQROrderBloc>()
                                              .order
                                              ?.id ??
                                          "",
                                      restaurantId: widget.restaurant.id ?? "",
                                      orderNote: note.text,
                                      items:
                                          context.read<EditQROrderBloc>().items,
                                      orderType: orderType,
                                    ),
                                  );
                            }
                          },
                    child: (orderState is EditQROrderLoading)
                        ? Center(
                            child: LoadingAnimationWidget.dotsTriangle(
                              color: Colors.white,
                              size: 20,
                            ),
                          )
                        : Text(
                            "Update Order",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 17.sp,
                              color: Colors.white,
                            ),
                          ),
                  );
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}

class EditOrderCartItemCard extends StatelessWidget {
  final QRItem item;
  final String currencyCode;
  final Function setState;
  const EditOrderCartItemCard({
    super.key,
    required this.item,
    required this.currencyCode,
    required this.setState,
  });

  @override
  Widget build(BuildContext context) {
    // final cartCubit = context.read<CartCubit>();

    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      child: SizedBox(
        width: double.infinity,
        // alignment: Alignment.center,
        child: Container(
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(10),
          ),
          child: Row(
            // crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Container(
                  decoration:
                      BoxDecoration(borderRadius: BorderRadius.circular(20)),
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(10.0),
                    child: CachedNetworkImage(
                      imageUrl: item.imageUrl!,
                      width: 20.w,
                      height: 13.h,
                      memCacheWidth: (20.w).cacheSize(context),
                      placeholder: (context, url) => Shimmer.fromColors(
                        baseColor: Colors.grey[300]!,
                        highlightColor: Colors.grey[100]!,
                        child: Container(
                          color: Colors.white,
                        ),
                      ),
                      errorWidget: (context, url, error) => Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Text(
                            AppLocalizations.of(context)!.loadImageError,
                            textAlign: TextAlign.center,
                            style: subTitleTextStyle,
                          ),
                        ],
                      ),
                      fit: BoxFit.cover,
                    ),
                  ),
                ),
              ),
              Expanded(
                child: SingleChildScrollView(
                  physics: const NeverScrollableScrollPhysics(),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      verticalPadding(height: .6),
                      Padding(
                        padding: const EdgeInsets.only(left: 5),
                        child: SizedBox(
                          width: 48.w,
                          child: Text(
                            item.name,
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                            style: GoogleFonts.poppins(
                              fontSize: 16.sp,
                              fontWeight: FontWeight.w600,
                              height: 1.5,
                              color: AppColors.textDark,
                            ),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          item.rating > 0
                              ? OrderItemRatingBar(
                                  rating: item.rating,
                                )
                              : Container(
                                  margin: EdgeInsets.only(
                                    left: 2.w,
                                    top: .5.h,
                                  ),
                                  child: Text(
                                    AppLocalizations.of(context)!.notRatedText,
                                    style: GoogleFonts.getFont(
                                      'Poppins',
                                      fontSize: 1.5.h,
                                      fontWeight: FontWeight.w400,
                                      height: 1.5,
                                      letterSpacing: -0.28,
                                      color: const Color(0xff586069),
                                    ),
                                  ),
                                ),
                          Container(
                            padding: const EdgeInsets.symmetric(
                              horizontal: 8,
                              vertical: 4,
                            ),
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(8),
                            ),
                            child: item.rating > 0
                                ? Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        color: Colors.red,
                                        size: 1.5.h,
                                      ),
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      Text(
                                        item.rating.toStringAsFixed(1),
                                        style: GoogleFonts.getFont(
                                          'Poppins',
                                          fontSize: 1.2.h,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff24292e),
                                        ),
                                      ),
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      Text(
                                        '/5',
                                        style: GoogleFonts.getFont(
                                          'Poppins',
                                          fontSize: 1.2.h,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff6a737d),
                                        ),
                                      )
                                    ],
                                  )
                                : Row(
                                    children: [
                                      Icon(
                                        Icons.star_rounded,
                                        color: Colors.red,
                                        size: 1.5.h,
                                      ),
                                      SizedBox(
                                        width: 1.w,
                                      ),
                                      Text(
                                        AppLocalizations.of(context)!
                                            .noRateText,
                                        style: GoogleFonts.getFont(
                                          'Poppins',
                                          fontSize: 1.2.h,
                                          fontWeight: FontWeight.w500,
                                          color: const Color(0xff24292e),
                                        ),
                                      ),
                                    ],
                                  ),
                          ),
                        ],
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 2.w,
                          top: .5.h,
                        ),
                        width: 35.w,
                        child: Text(
                          item.numberOfReviews > 0
                              ? '${item.numberOfReviews} ${AppLocalizations.of(context)!.revText}'
                              : AppLocalizations.of(context)!.noRevText,
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                          style: GoogleFonts.getFont(
                            'Poppins',
                            fontSize: 1.5.h,
                            fontWeight: FontWeight.w400,
                            height: 1.5,
                            letterSpacing: -0.28,
                            color: const Color(0xff586069),
                          ),
                        ),
                      ),
                      Container(
                        margin: EdgeInsets.only(
                          left: 2.w,
                        ),
                        child: Text(
                          '${item.price} $currencyCode',
                          style: GoogleFonts.sen(
                            fontSize: 1.4.h,
                            fontWeight: FontWeight.w600,
                            height: 1.7,
                            letterSpacing: 0.1,
                            color: const Color(0xffff3008),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Container(
                width: 25.w,
                height: 6.h,
                decoration: const BoxDecoration(
                  color: Color(0xffFBFCFF),
                  borderRadius: BorderRadius.all(
                    Radius.circular(
                      15,
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
                            .read<EditQROrderBloc>()
                            .add(RemoveItemFromOrder(item: item));
                        setState(() {});
                      },
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor:
                            context.read<EditQROrderBloc>().isItemInOrder(item)
                                ? const Color(0xffFF3008)
                                : Colors.white,
                        child: SvgPicture.asset(
                          "assets/icons/minus.svg",
                          fit: BoxFit.scaleDown,
                          height: 15.h,
                          colorFilter: ColorFilter.mode(
                            !context.read<EditQROrderBloc>().isItemInOrder(item)
                                ? const Color(0xffFF3008)
                                : Colors.white,
                            BlendMode.srcIn,
                          ),
                        ),
                      ),
                    ),
                    Text(
                      context
                          .read<EditQROrderBloc>()
                          .getItemCount(item)
                          .toString(),
                      style: GoogleFonts.sen(
                        fontWeight: FontWeight.w700,
                        fontSize: 14,
                        color: Colors.black,
                      ),
                    ),
                    InkWell(
                      onTap: () {
                        context.read<EditQROrderBloc>().add(
                              AddItemToOrder(item: item),
                            );
                        setState(() {});
                      },
                      child: CircleAvatar(
                        radius: 15,
                        backgroundColor: const Color(0xffFF3008),
                        child: SvgPicture.asset(
                          "assets/icons/plus_2.svg",
                          fit: BoxFit.scaleDown,
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
            ],
          ),
        ),
      ),
    );
  }
}
