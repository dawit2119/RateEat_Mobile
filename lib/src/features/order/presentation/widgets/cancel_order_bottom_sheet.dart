import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';
import 'package:rateeat_mobile/src/features/order/presentation/widgets/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CancelOrderBottomSheet extends StatefulWidget {
  final String orderId;
  final String restaurantId;
  const CancelOrderBottomSheet({
    super.key,
    required this.orderId,
    required this.restaurantId,
  });

  @override
  State<CancelOrderBottomSheet> createState() => _CancelOrderBottomSheetState();
}

class _CancelOrderBottomSheetState extends State<CancelOrderBottomSheet> {
  final TextEditingController reason = TextEditingController();

  String? customReason;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          EdgeInsets.only(bottom: MediaQuery.of(context).viewInsets.bottom),
      child: IntrinsicHeight(
        child: Container(
          padding: EdgeInsets.symmetric(horizontal: 5.w, vertical: 1.h),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(20),
              topRight: Radius.circular(20),
            ),
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                height: 1.h,
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    "Cancel Order",
                    style: TextStyle(
                      fontWeight: FontWeight.w600,
                      fontSize: 17.sp,
                    ),
                  ),
                  IconButton(
                    onPressed: () {
                      context.pop();
                    },
                    icon: const Icon(
                      Icons.close,
                      color: AppColors.grey700,
                    ),
                  ),
                ],
              ),
              SizedBox(
                height: .8.h,
              ),
              Text(
                "What is your reason for declining this order?",
                style: TextStyle(
                  // fontWeight: FontWeight.w600,
                  fontSize: 17.sp,
                  color: AppColors.grey500,
                ),
              ),

              SizedBox(
                height: 1.5.h,
              ),
              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Radio(
              //       value: 'Not accepting orders at the moment',
              //       groupValue: customReason,
              //       activeColor: AppColors.primaryColor,
              //       onChanged: (value) {
              //         setState(() {
              //           customReason = value;
              //         });
              //       },
              //     ),
              //     Text(
              //       "Not accepting orders at the moment",
              //       style: TextStyle(
              //         fontSize: 15.sp,
              //       ),
              //     ),
              //   ],
              // ),

              // Row(
              //   mainAxisAlignment: MainAxisAlignment.start,
              //   children: [
              //     Radio(
              //       value: "About to close ordering",
              //       groupValue: customReason,
              //       activeColor: AppColors.primaryColor,
              //       onChanged: (value) {
              //         setState(() {
              //           customReason = value;
              //         });
              //       },
              //     ),
              //     Text(
              //       "About to close ordering",
              //       style: TextStyle(
              //         fontSize: 15.sp,
              //       ),
              //     ),
              //   ],
              // ),

              // SizedBox(
              //   height: 2.h,
              // ),
              // Other
              AddNoteField(
                title: "Other",
                hintText: "Ex: decided to eat in another place",
                textEditingController: reason,
              ),
              SizedBox(height: 2.6.h),

              // Button
              BlocConsumer<CancelOrderBloc, CancelOrderState>(
                listener: (context, cancelState) {
                  if (cancelState is CancelOrderRequestSuccess) {
                    showCustomToast(
                      context: context,
                      toastMessage: "Order has been cancelled",
                      toastType: ToastType.success,
                    );
                    // context.goNamed(
                    //   AppRoutes.restaurantDetail,
                    //   pathParameters: {'restaurantId': widget.restaurantId},
                    // );
                    context.pop();
                    context.pop();
                  } else if (cancelState is CancelOrderRequestFailed) {
                    showCustomToast(
                      context: context,
                      toastMessage: cancelState.errorMessage,
                      toastType: ToastType.error,
                    );
                  }
                },
                builder: (context, cancelState) {
                  return SizedBox(
                    key: const Key("cancel_order_button_key"),
                    height: 5.h,
                    width: 90.w,
                    child: TextButton(
                      //key: const Key("cancel_order_button_key"),
                      onPressed: (cancelState is CancelOrderRequestLoading)
                          ? null
                          : () {
                              context.read<CancelOrderBloc>().add(
                                    CancelOrderRequestEvent(
                                      orderId: widget.orderId,
                                      reason: (customReason != null)
                                          ? customReason!
                                          : reason.text,
                                    ),
                                  );
                            },
                      style: TextButton.styleFrom(
                        backgroundColor: AppColors.primaryColor,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14.0),
                          side: const BorderSide(
                            color: Colors.white,
                            width: .6,
                          ),
                        ),
                      ),
                      child: (cancelState is CancelOrderRequestLoading)
                          ? LoadingAnimationWidget.dotsTriangle(
                              key:
                                  const Key("loading_payment_order_button_key"),
                              color: Colors.white,
                              size: 18,
                            )
                          : Text(
                              "Cancel Order",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16.sp,
                                fontWeight: FontWeight.w600,
                              ),
                            ),
                    ),
                  );
                },
              )
            ],
          ),
        ),
      ),
    );
  }
}
