import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/order/data/data.dart';
import 'package:rateeat_mobile/src/features/order/presentation/bloc/bloc.dart';
import 'package:rateeat_mobile/src/features/order/presentation/widgets/widgets.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:flutter_svg/flutter_svg.dart';

class OrderStatusPage extends StatefulWidget {
  final String orderId;
  final Restaurant restaurant;
  const OrderStatusPage({
    super.key,
    required this.orderId,
    required this.restaurant,
  });

  @override
  State<OrderStatusPage> createState() => _OrderStatusPageState();
}

class _OrderStatusPageState extends State<OrderStatusPage> {
  @override
  void initState() {
    super.initState();

    context.read<OrderStatusBloc>().add(
          GetOrderStatusEvent(
            orderId: widget.orderId,
          ),
        );
    OrderSocketMethod().getOrderStatus(context, widget.restaurant.id);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: "Order Status",
        onTap: () {
          context.pop();
        },
      ),
      body: SingleChildScrollView(
        physics: const ClampingScrollPhysics(),
        child: BlocConsumer<OrderSocketStatusBloc, OrderSocketStatusState>(
            listener: (context, socketState) {
          if (socketState is OrderSocketConnectedState) {
            OrderSocketMethod().getOrderStatus(context, widget.restaurant.id);
            context.read<OrderStatusBloc>().add(
                  GetOrderStatusEvent(
                    orderId: widget.orderId,
                  ),
                );
          }
        }, builder: (context, socketState) {
          if (socketState is OrderSocketLoadingState) {
            return SizedBox(
              height: 100.h,
              width: 100.w,
              child: Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  key: const Key(
                    'socket_connection_loading',
                  ),
                  children: [
                    LoadingAnimationWidget.dotsTriangle(
                      color: AppColors.primaryColor,
                      size: 6.h,
                    ),
                    SizedBox(height: 1.h),
                    Text(
                      "Connecting ...",
                      style: subTitleTextStyle,
                    ),
                  ],
                ),
              ),
            );
          } else if (socketState is OrderSocketFailedState) {
            return SizedBox(
              height: 100.h,
              width: 100.w,
              child: Center(
                child: ErrorAndInfoDisplayWidget(
                  title: "Connection failed",
                  description:
                      "Error connecting to the server, check your connection",
                  assetImage: "assets/icons/no_internet.svg",
                  onPressed: () {
                    dpLocator<OrderSocketStatusBloc>().add(
                      OrderConnectSocket(),
                    );
                  },
                ),
              ),
            );
          }

          return BlocConsumer<OrderStatusBloc, OrderStatusState>(
            listener: (_, state) {},
            builder: (context, orderState) {
              if (orderState is OrderStatusInitial ||
                  orderState is OrderStatusUpdatedInProgress) {
                return SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      key: const Key(
                        'order_status_loading',
                      ),
                      children: [
                        LoadingAnimationWidget.dotsTriangle(
                          color: AppColors.primaryColor,
                          size: 6.h,
                        ),
                        SizedBox(height: 1.h),
                        Text(
                          "loading order status",
                          style: subTitleTextStyle,
                        ),
                      ],
                    ),
                  ),
                );
              } else if (orderState is OrderStatusUpdateFailed) {
                return SizedBox(
                  height: 100.h,
                  width: 100.w,
                  child: Center(
                    child: ErrorAndInfoDisplayWidget(
                      title: "Error loading order status",
                      description: " could not get order status",
                      assetImage: "assets/icons/no_internet.svg",
                      onPressed: () {
                        context.read<OrderStatusBloc>().add(
                              GetOrderStatusEvent(
                                orderId: widget.orderId,
                              ),
                            );
                      },
                    ),
                  ),
                );
              } else if (orderState is OrderStatusUpdated) {
                final orderStates = getOrderStatusModels(orderState);
                final orderProgressCard = getOrderProgressModel(orderState);
                return Padding(
                  padding: EdgeInsets.only(left: 8.w, right: 8.w, top: 9.h),
                  child: Column(
                    children: [
                      Container(
                        height: 20.h,
                        width: 88.w,
                        padding: EdgeInsets.only(bottom: 2.h),
                        decoration: BoxDecoration(
                          color: orderProgressCard.backgroundColor,
                          borderRadius: BorderRadius.circular(15),
                        ),
                        child: Stack(
                          alignment: AlignmentDirectional.bottomCenter,
                          clipBehavior: Clip.none,
                          children: [
                            Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  orderProgressCard.text,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w600,
                                    fontSize: 14.sp,
                                    color: Colors.black,
                                  ),
                                ),
                                Text(
                                  orderProgressCard.subtext,
                                  style: GoogleFonts.plusJakartaSans(
                                    fontWeight: FontWeight.w500,
                                    fontSize: 13.sp,
                                    color: orderProgressCard.subtextColor,
                                  ),
                                ),
                              ],
                            ),
                            Positioned(
                              top: -4.h,
                              child: SvgPicture.asset(
                                "assets/icons/search_result.svg",
                                height: 15.h,
                                fit: BoxFit.cover,
                              ),
                            ),
                          ],
                        ),
                      ),
                      SizedBox(height: 4.h),
                      ...orderStates,
                    ],
                  ),
                );
              } else if (orderState is OrderRejected) {
                return Center(
                  child: Text(
                    "Order rejected",
                    textAlign: TextAlign.center,
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 14.sp,
                      color: Colors.red,
                    ),
                  ),
                );
              }
              return Container();
            },
          );
        }),
      ),
      bottomNavigationBar: BlocBuilder<OrderStatusBloc, OrderStatusState>(
        builder: (context, state) {
          if (state is OrderStatusUpdated) {
            if (state.confirmed != null &&
                state.paid == null &&
                state.started == null &&
                state.cancelled == null &&
                state.rejected == null) {
              return BlocConsumer<PayOrderBloc, PayOrderState>(
                listener: (context, payState) {
                  if (payState is PaymentOrderCreated) {
                    context.pushNamed(
                      AppRoutes.confirmPaymentWebView,
                      extra: payState.returnUrl,
                    );
                  } else if (payState is PaymentOrderActionsFailed) {
                    showCustomToast(
                      context: context,
                      toastMessage: payState.errorMessage,
                      toastType: ToastType.error,
                    );
                  }
                },
                builder: (context, payState) {
                  return IntrinsicHeight(
                    child: Container(
                      margin: EdgeInsets.all(1.8.h),
                      child: OrderButton(
                        onTap: (payState is PaymentOrderActionsLoading)
                            ? null
                            : () {
                                final user =
                                    dpLocator<AuthenticationLocalSource>()
                                        .getUserCredential();

                                context.read<PayOrderBloc>().add(
                                      CreatePaymentOrderEvent(
                                        paymentInfo: PaymentRequestModel(
                                          orderId: widget.orderId,
                                          firstName: user!.firstName ?? "",
                                          lastName: user.lastName ?? "",
                                          email: user.email ?? "",
                                          phoneNumber: user.phoneNumber ?? "",
                                        ),
                                      ),
                                    );
                              },
                        child: (payState is PaymentOrderActionsLoading)
                            ? LoadingAnimationWidget.dotsTriangle(
                                key: const Key(
                                    "loading_payment_order_button_key"),
                                color: Colors.white,
                                size: 4.h,
                              )
                            : Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  SvgPicture.asset(
                                    "assets/icons/empty-wallet.svg",
                                    fit: BoxFit.scaleDown,
                                    colorFilter: const ColorFilter.mode(
                                      Colors.white,
                                      BlendMode.srcIn,
                                    ),
                                  ),
                                  SizedBox(
                                    width: 2.w,
                                  ),
                                  Text(
                                    "Proceed to Payment",
                                    style: GoogleFonts.plusJakartaSans(
                                      fontWeight: FontWeight.w600,
                                      fontSize: 17.sp,
                                      color: Colors.white,
                                    ),
                                  ),
                                ],
                              ),
                      ),
                    ),
                  );
                },
              );
            } else if (state.completed != null && state.started != null) {
              return Container(
                margin: EdgeInsets.all(1.8.h),
                child: SizedBox(
                  height: 6.h,
                  child: OrderButton(
                    onTap: () {},
                    child: Text(
                      "Going to pick item",
                      style: GoogleFonts.plusJakartaSans(
                        fontWeight: FontWeight.w600,
                        fontSize: 17.sp,
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              );
            }
          }
          return SizedBox(
            height: 1.h,
          );
        },
      ),
    );
  }

  List<OrderStep> getOrderStatusModels(OrderStatusUpdated state) {
    final statusTitles = [
      {"Order Created": "Order submitted to ${widget.restaurant.name}"},
      {"Waiting for confirmation": "Waiting for confirmation"},
      {
        "Confirm Payment":
            state.paid != null ? "Payment Confirmed" : "Confirm payment"
      },
      {"Order started": "Order started"},
      {"Order completed": "Order completed"},
    ];

    final orderStatusList = [
      [state.created?.createdAt, state.created?.id],
      [state.confirmed?.orderConfirmedAt, state.confirmed?.id],
      [state.paid?.paymentConfirmedAt, state.paid?.id],
      [state.started?.orderPlacedAt, state.started?.id],
      [state.completed?.orderCompletedAt, state.completed?.id],
    ];

    int currentStatusIndex = 0;

    for (int i = 0; i < orderStatusList.length; i++) {
      if (orderStatusList[i][1] == null) {
        break;
      }
      currentStatusIndex = i + 1;
    }

    if (state.cancelled != null || state.rejected != null) {
      return List.generate(
        1,
        (index) {
          return OrderStep(
            time: state.cancelled != null
                ? 'at ${DateFormat("hh:mm a, EE, dd, yyyy").format(state.cancelled!.createdAt)}'
                : 'at ${DateFormat("hh:mm a, EE, dd, yyyy").format(state.rejected!.createdAt)}',
            title:
                state.cancelled != null ? "Order Cancelled" : "Order Rejected",
            orderId: widget.orderId,
            isCompleted: true,
            isCurrent: false,
            isLastRow: true,
            currentStatusIndex: currentStatusIndex,
            restaurantId: widget.restaurant.id!,
          );
        },
      );
    }

    return List.generate(statusTitles.length, (index) {
      var orderTime = orderStatusList[index][0];

      return OrderStep(
        time: orderTime != null
            ? 'at ${DateFormat("hh:mm a, EE, dd, yyyy").format(orderTime as DateTime)}'
            : '',
        title: statusTitles[index].values.first,
        orderId: widget.orderId,
        isCompleted: index < currentStatusIndex,
        isCurrent: index == currentStatusIndex &&
            (index != 0 &&
                widget.orderId == (orderStatusList[index - 1][1] as String)),
        isLastRow: index == 4,
        currentStatusIndex: currentStatusIndex,
        restaurantId: widget.restaurant.id!,
      );
    });
  }

  OrderProgressModel getOrderProgressModel(OrderStatusUpdated state) {
    final orderStatusList = [
      state.created,
      state.confirmed,
      state.paid,
      state.started,
      state.completed,
    ];
    int currentStatusIndex = 0;

    for (int i = 0; i < orderStatusList.length; i++) {
      if (orderStatusList[i] == null) {
        break;
      }
      currentStatusIndex = i + 1;
    }

    if (state.cancelled != null) {
      return OrderProgressModel(
        text: "Order Cancelled",
        subtext: "Order has been cancelled",
        backgroundColor: const Color(0xFFEDCCB4),
        subtextColor: const Color(0xffBD6320),
      );
    } else if (state.rejected != null) {
      return OrderProgressModel(
        text: "Order Rejected",
        subtext: "Order has been rejected",
        backgroundColor: const Color(0xFFEDCCB4),
        subtextColor: const Color(0xffBD6320),
      );
    }

    switch (currentStatusIndex) {
      case 2:
        return OrderProgressModel(
          text: "Confirm Payment",
          subtext: "Waiting for your payment",
          backgroundColor: const Color(0xFFEDCCB4),
          subtextColor: const Color(0xffBD6320),
        );
      case 3:
        return OrderProgressModel(
          text: "Payment Completed",
          subtext: "Waiting for order to start",
          backgroundColor: const Color(0xFFEDCCB4),
          subtextColor: const Color(0xffBD6320),
        );
      case 4:
        return OrderProgressModel(
          text: "Order is being prepared",
          subtext: "Waiting for order to complete",
          backgroundColor: const Color(0xFFEDCCB4),
          subtextColor: const Color(0xffBD6320),
        );
      case 5:
        return OrderProgressModel(
          text: "Order Completed",
          subtext: "Go and pick your order right now",
          backgroundColor: const Color(0xFF9FDCF2),
          subtextColor: const Color(0xff1B5A8C),
        );
      default:
        return OrderProgressModel(
          text: "Order being processed",
          subtext: "Waiting for restaurant to respond",
          backgroundColor: const Color(0xFFD9F4EF),
          subtextColor: const Color(0xff114F39),
        );
    }
  }
}

class OrderStep extends StatelessWidget {
  final String time;
  final String title;
  final String orderId;
  final bool isCompleted;
  final bool isCurrent;
  final int currentStatusIndex;
  final bool isLastRow;
  final String restaurantId;

  const OrderStep({
    super.key,
    required this.time,
    required this.title,
    required this.orderId,
    required this.isCompleted,
    required this.isCurrent,
    required this.currentStatusIndex,
    this.isLastRow = false,
    required this.restaurantId,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Column(
          mainAxisSize: MainAxisSize.min,
          children: <Widget>[
            Container(
              width: 30,
              height: 30,
              decoration: BoxDecoration(
                color: isCompleted
                    ? const Color.fromARGB(26, 255, 48, 8)
                    : const Color(0xffF6F6F6),
                shape: BoxShape.circle,
              ),
              child: Center(
                child: isCompleted
                    ? SvgPicture.asset(
                        "assets/icons/checks.svg",
                        fit: BoxFit.scaleDown,
                        height: 14.h,
                        colorFilter: const ColorFilter.mode(
                          Color(0xffFF3008),
                          BlendMode.srcIn,
                        ),
                      )
                    : Container(
                        width: 15,
                        height: 15,
                        decoration: BoxDecoration(
                          color: isCurrent
                              ? const Color(0xffFF9292)
                              : const Color(0xffD9D9D9),
                          shape: BoxShape.circle,
                        ),
                      ),
              ),
            ),
            if (!isLastRow)
              Container(
                margin: const EdgeInsets.symmetric(
                  vertical: 5,
                ),
                width: 3,
                height: 6.h,
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(
                    5,
                  ),
                  gradient: isCurrent
                      ? LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            const Color(0xFFFF3008).withOpacity(1.0),
                            const Color(0xFFFF3008).withOpacity(0.1),
                          ],
                        )
                      : null,
                  color: isCompleted
                      ? const Color(0xFFFF3008)
                      : !isCurrent
                          ? const Color(0xffE5E7EB)
                          : null,
                ),
              ),
          ],
        ),
        SizedBox(width: 2.w),
        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              if (time.isNotEmpty)
                Text(
                  time,
                  style: TextStyle(
                    color: Colors.grey,
                    fontSize: 14.sp,
                  ),
                ),
              const SizedBox(height: 4),
              Text(
                maxLines: 1,
                title,
                style: TextStyle(
                  overflow: TextOverflow.ellipsis,
                  color: Colors.black,
                  fontSize: 16.sp,
                  fontWeight: FontWeight.w600,
                ),
              ),
              (isCurrent)
                  ? (isCurrent && currentStatusIndex == 1 ||
                          currentStatusIndex == 2)
                      ? InkWell(
                          splashColor: Colors.transparent,
                          onTap: () {
                            showModalBottomSheet(
                              context: context,
                              builder: (BuildContext context) {
                                return CancelOrderBottomSheet(
                                  orderId: orderId,
                                  restaurantId: restaurantId,
                                );
                              },
                              isScrollControlled: true,
                            );
                          },
                          child: Container(
                            width: 30.w,
                            alignment: Alignment.center,
                            margin: const EdgeInsets.symmetric(
                              vertical: 10,
                            ),
                            padding: const EdgeInsets.symmetric(
                              vertical: 6,
                            ),
                            decoration: BoxDecoration(
                              color: AppColors.primaryColor,
                              borderRadius: BorderRadius.circular(20),
                            ),
                            child: Text(
                              "Cancel Order",
                              style: GoogleFonts.plusJakartaSans(
                                fontWeight: FontWeight.w600,
                                fontSize: 14.5.sp,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        )
                      : Container(
                          width: 30.w,
                          alignment: Alignment.center,
                          margin: const EdgeInsets.symmetric(
                            vertical: 10,
                          ),
                          padding: const EdgeInsets.symmetric(
                            vertical: 6,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primaryColor,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Text(
                            "Current State",
                            style: GoogleFonts.plusJakartaSans(
                              fontWeight: FontWeight.w600,
                              fontSize: 14.5.sp,
                              color: Colors.white,
                            ),
                          ),
                        )
                  : Container()
            ],
          ),
        ),
      ],
    );
  }
}

class OrderProgressModel {
  final String text;
  final String subtext;
  final Color backgroundColor;
  final Color subtextColor;

  OrderProgressModel({
    required this.text,
    required this.subtext,
    required this.backgroundColor,
    required this.subtextColor,
  });
}
