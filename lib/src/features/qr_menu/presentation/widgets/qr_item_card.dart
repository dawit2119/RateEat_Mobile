import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class QRItemCard extends StatelessWidget {
  final QRItem item;

  const QRItemCard({super.key, required this.item});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        context.pushNamed(
          AppRoutes.itemDetail,
          pathParameters: {"itemId": item.id},
        );
      },
      child: Container(
        margin: EdgeInsets.only(
          right: 3.w,
          left: 1.w,
        ),
        height: 28.h,
        width: 40.w,
        decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(2.w), color: AppColors.grey100),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              height: 17.h,
              width: 40.w,
              decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(2.w),
                  image: DecorationImage(
                      fit: BoxFit.cover,
                      image: NetworkImage(item.imageUrl ??
                          "https://images.unsplash.com/photo-1571091718767-18b5b1457add?ixlib=rb-4.0.3&ixid=M3wxMjA3fDB8MHxzZWFyY2h8MTB8fGJ1cmdlcnxlbnwwfHwwfHx8MA%3D%3D&w=1000&q=80"))),
            ),
            Container(
              padding: EdgeInsets.only(top: 0.8.h, left: 2.w, bottom: 0.5.h),
              width: 35.w,
              child: Text(
                item.name,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
              ),
            ),
            SizedBox(
              child: SizedBox(
                width: 40.w,
                child: Row(children: [
                  SizedBox(
                    width: 2.w,
                  ),
                  Icon(
                    Icons.star,
                    color: Colors.red,
                    size: 16.sp,
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  Text(
                    item.rating.toString(),
                    style: TextStyle(color: AppColors.grey400, fontSize: 15.sp),
                  ),
                  SizedBox(
                    width: 1.w,
                  ),
                  Text(
                    "(${item.numberOfReviews} reviews)",
                    style: TextStyle(color: AppColors.grey400, fontSize: 15.sp),
                  )
                ]),
              ),
            ),
            Container(
              padding: EdgeInsets.only(top: 0.8.h, left: 2.w, bottom: 0.5.h),
              width: 40.w,
              child: Text(
                "${item.price} Birr",
                maxLines: 1,
                style: TextStyle(color: Colors.black, fontSize: 15.sp),
              ),
            )
          ],
        ),
      ),
    );
  }
}
