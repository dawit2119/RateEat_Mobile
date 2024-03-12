import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../domain/entities/order_history/order_history.dart';

class OrderHistoryCard extends StatelessWidget {
  const OrderHistoryCard({super.key, required this.orderData});
  final OrderHistory orderData;

  String _getOrderName({required OrderHistory orderData}) {
    return orderData.orderItems!
        .map((orderItem) => '${orderItem.quantity} ${orderItem.item!.name!}')
        .join(", ");
  }

  String _stringToDateTime({required DateTime dateTime}) {
    DateTime now = DateTime.now();
    Duration difference = now.difference(dateTime);
    if (difference.inMinutes < 60) {
      // Less than 1 hour ago
      return '${DateFormat('hh:mm a', 'en_US').format(dateTime)} (${difference.inMinutes} minutes ago)';
    } else if (difference.inHours < 24) {
      // Less than 1 day ago
      return '${DateFormat('hh:mm a', 'en_US').format(dateTime)} (${difference.inHours} hours ago)';
    } else if (difference.inDays < 7) {
      // Less than 1 week ago
      return '${DateFormat('hh:mm a', 'en_US').format(dateTime)} (${difference.inDays} days ago)';
    } else if (difference.inDays <= 365) {
      // More than a week but within the same year, show the date with time
      return DateFormat('MMM dd, hh:mm a', 'en_US').format(dateTime);
    } else {
      // More than a year, show the full date with year and time
      return DateFormat('MMM dd, yyyy, hh:mm a', 'en_US').format(dateTime);
    }
  }

  Map<String, dynamic> getOrderStatusStyle(String status) {
    switch (status) {
      case "Order Cancelled":
        return {
          'color': AppColors.primaryColor.withOpacity(0.9),
          'text': "Order Cancelled"
        };
      case "Order Rejected":
        return {
          'color': AppColors.primaryColor.withOpacity(0.9),
          'text': "Order Rejected"
        };
      case "Order Created":
        return {
          'color': AppColors.primaryColor.withOpacity(0.6),
          'text': "Waiting Confirmation"
        };
      case "Confirm Payment":
        return {
          'color': Colors.blue.withOpacity(0.6),
          'text': "Confirm Payment"
        };
      case "Order Started":
        return {
          'color': Colors.purple.withOpacity(0.6),
          'text': "Order Started"
        };
      case "Order Completed":
        return {
          'color': Colors.green.withOpacity(0.9),
          'text': "Order Completed"
        };
      default:
        return {
          'color': AppColors.primaryColor.withOpacity(0.6),
          'text': status
        };
    }
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.orderHistoryDetail,
          pathParameters: {
            'orderId': orderData.id!,
          },
          extra: {'restaurantId': orderData.restaurantId!},
        );
      },
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.all(15),
        margin: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: AppColors.grey300.withOpacity(.6),
              blurRadius: 4,
              offset: const Offset(0, 3),
            ),
          ],
          border: Border.all(
            color: AppColors.grey100,
          ),
        ),
        child: Column(
          mainAxisSize: MainAxisSize.max,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    _getOrderName(orderData: orderData),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: GoogleFonts.poppins(
                      fontSize: 16.sp,
                      fontWeight: FontWeight.w600,
                      color: const Color.fromARGB(255, 3, 6, 9),
                    ),
                  ),
                ),
                SizedBox(width: 2.w),
                (orderData.orderStatus == 'Payment Completed')
                    ? Container(
                        padding: EdgeInsets.symmetric(
                            horizontal: 3.w, vertical: 1.h),
                        decoration: BoxDecoration(
                          gradient: const LinearGradient(
                            tileMode: TileMode.decal,
                            colors: [
                              Color(0xffE7845F),
                              Color(0xffA874BD),
                              Color(0xff3A99DF),
                            ],
                          ),
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          orderData.orderStatus!,
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      )
                    : Container(
                        padding: EdgeInsets.symmetric(
                          horizontal: 3.w,
                          vertical: 1.h,
                        ),
                        decoration: BoxDecoration(
                          color: getOrderStatusStyle(
                              orderData.orderStatus!)['color'],
                          borderRadius: BorderRadius.circular(10),
                        ),
                        child: Text(
                          getOrderStatusStyle(orderData.orderStatus!)['text'],
                          style: GoogleFonts.poppins(
                            fontSize: 15.sp,
                            color: Colors.white,
                            fontWeight: FontWeight.w500,
                          ),
                        ),
                      ),
              ],
            ),
            SizedBox(height: 0.8.h),
            Row(
              children: [
                Text(
                  '${orderData.totalPrice} Birr',
                  style: GoogleFonts.poppins(
                    color: AppColors.textColor,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Container(
                  height: 10.sp,
                  width: 10.sp,
                  decoration: BoxDecoration(
                    color: AppColors.grey300,
                    borderRadius: BorderRadius.circular(50),
                  ),
                ),
                SizedBox(
                  width: 3.w,
                ),
                Text(
                  orderData.orderType!,
                  style: GoogleFonts.poppins(
                    color: AppColors.textDark,
                    fontSize: 16.sp,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
            SizedBox(height: 1.h),
            Row(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Flexible(
                  child: StackedImagesDisplayWidget(
                    imageURLs: orderData.orderItems!
                        .map((item) => item.item!.imageUrl as dynamic)
                        .toList(),
                    videos: const [],
                  ),
                ),
                Text(
                  _stringToDateTime(dateTime: orderData.createdAt!),
                  style: GoogleFonts.poppins(
                    color: AppColors.grey500,
                    fontSize: 15.sp,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
