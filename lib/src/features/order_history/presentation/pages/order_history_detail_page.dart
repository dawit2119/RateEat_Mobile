import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';
import 'package:rateeat_mobile/src/features/order/order.dart';
import 'package:rateeat_mobile/src/features/order_history/data/data_sources/socket/order_history_socket_impl.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class OrderHistoryDetailPage extends StatefulWidget {
  final String orderId;
  final String restaurantId;

  const OrderHistoryDetailPage(
      {super.key, required this.orderId, required this.restaurantId});

  @override
  State<OrderHistoryDetailPage> createState() => _OrderHistoryDetailPageState();
}

class _OrderHistoryDetailPageState extends State<OrderHistoryDetailPage> {
  @override
  void initState() {
    super.initState();

    context.read<OrderDetailBloc>().add(
          GetOrderDetailEvent(
            orderId: widget.orderId,
          ),
        );
    OrderHistorySocketImpl().getOrderStatus(context, widget.restaurantId);
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
        child: BlocConsumer<OrderHistoryStatusBloc, OrderHistoryStatusState>(
          listener: (context, socketState) {
            if (socketState is OrderHistorySocketConnectedState) {
              OrderHistorySocketImpl()
                  .getOrderStatus(context, widget.restaurantId);

              context.read<OrderDetailBloc>().add(
                    GetOrderDetailEvent(
                      orderId: widget.orderId,
                    ),
                  );
            }
          },
          builder: (context, socketState) {
            if (socketState is OrderHistorySocketLoadingState) {
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
            } else if (socketState is OrderHistorySocketFailedState) {
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
                      dpLocator<OrderHistoryStatusBloc>().add(
                        OrderHistoryConnectSocket(),
                      );
                    },
                  ),
                ),
              );
            }
            return BlocConsumer<OrderDetailBloc, OrderDetailState>(
              listener: (context, orderDetailState) {},
              builder: (context, orderDetailState) {
                if (orderDetailState is OrderHistoryStatusUpdatedInProgress ||
                    orderDetailState is OrderDetailInitial) {
                  return SizedBox(
                    height: 100.h,
                    width: 100.w,
                    child: Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        key: const Key(
                          'order_detail_status_loading',
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
                } else if (orderDetailState is OrderDetailError) {
                  return SizedBox(
                    height: 100.h,
                    width: 100.w,
                    child: Center(
                      child: ErrorAndInfoDisplayWidget(
                        title: "Error loading order status",
                        description: " could not get order status",
                        assetImage: "assets/icons/no_internet.svg",
                        onPressed: () {
                          context.read<OrderDetailBloc>().add(
                                GetOrderDetailEvent(
                                  orderId: widget.orderId,
                                ),
                              );
                        },
                      ),
                    ),
                  );
                } else if (orderDetailState is OrderHistoryStatusUpdated) {
                  final orderStates = getOrderStatusModels(orderDetailState);
                  final orderProgressCard =
                      getOrderProgressModel(orderDetailState);

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
                }
                return Container();
              },
            );
          },
        ),
      ),
      bottomNavigationBar: BlocBuilder<OrderDetailBloc, OrderDetailState>(
        builder: (context, state) {
          final socketState = dpLocator<OrderHistoryStatusBloc>().state;
          if (socketState is OrderHistorySocketConnectedState &&
              state is OrderHistoryStatusUpdated) {
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
                  return Container(
                    margin: EdgeInsets.all(1.8.h),
                    child: OrderHistoryReusableButton(
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
                              key:
                                  const Key("loading_payment_order_button_key"),
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
                  );
                },
              );
            } else if (state.completed != null && state.started != null) {
              return Container(
                margin: EdgeInsets.all(30.h),
                child: OrderHistoryReusableButton(
                  onTap: () {},
                  child: Text(
                    "Order Id: ${state.confirmed?.id.split("-")[0]}",
                    style: GoogleFonts.plusJakartaSans(
                      fontWeight: FontWeight.w600,
                      fontSize: 17.sp,
                      color: Colors.white,
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

  List<OrderHistoryProgressStepCard> getOrderStatusModels(
      OrderHistoryStatusUpdated state) {
    final statusTitles = [
      {"Order Created": "Order submitted to ${state.created!.restaurantName}"},
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
      if (orderStatusList[i][0] == null) {
        break;
      }
      currentStatusIndex = i + 1;
    }

    if (state.cancelled != null || state.rejected != null) {
      return List.generate(1, (index) {
        return OrderHistoryProgressStepCard(
          time: state.cancelled != null
              ? 'at ${DateFormat("hh:mm a, EE, dd, yyyy").format(state.cancelled!.createdAt)}'
              : 'at ${DateFormat("hh:mm a, EE, dd, yyyy").format(state.rejected!.createdAt)}',
          title: state.cancelled != null ? "Order Cancelled" : "Order Rejected",
          orderId: widget.orderId,
          isCompleted: true,
          isCurrent: false,
          isLastRow: true,
          currentStatusIndex: currentStatusIndex,
          restaurantId: widget.restaurantId,
        );
      });
    }

    return List.generate(statusTitles.length, (index) {
      var orderTime = orderStatusList[index][0];
      return OrderHistoryProgressStepCard(
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
        restaurantId: widget.restaurantId,
      );
    });
  }

  OrderHistoryCardProgressModel getOrderProgressModel(
      OrderHistoryStatusUpdated state) {
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
      return OrderHistoryCardProgressModel(
        text: "Order Cancelled",
        subtext: "Order has been cancelled",
        backgroundColor: const Color(0xFFEDCCB4),
        subtextColor: const Color(0xffBD6320),
      );
    } else if (state.rejected != null) {
      return OrderHistoryCardProgressModel(
        text: "Order Rejected",
        subtext: "Order has been rejected",
        backgroundColor: const Color(0xFFEDCCB4),
        subtextColor: const Color(0xffBD6320),
      );
    }

    switch (currentStatusIndex) {
      case 2:
        return OrderHistoryCardProgressModel(
          text: "Confirm Payment",
          subtext: "Waiting for your payment",
          backgroundColor: const Color(0xFFEDCCB4),
          subtextColor: const Color(0xffBD6320),
        );
      case 3:
        return OrderHistoryCardProgressModel(
          text: "Payment Completed",
          subtext: "Waiting for order to start",
          backgroundColor: const Color(0xFFEDCCB4),
          subtextColor: const Color(0xffBD6320),
        );
      case 4:
        return OrderHistoryCardProgressModel(
          text: "Order is being prepared",
          subtext: "Waiting for order to complete",
          backgroundColor: const Color(0xFFEDCCB4),
          subtextColor: const Color(0xffBD6320),
        );
      case 5:
        return OrderHistoryCardProgressModel(
          text: "Order Completed",
          subtext: "Go and pick your order right now",
          backgroundColor: const Color(0xFF9FDCF2),
          subtextColor: const Color(0xff1B5A8C),
        );
      default:
        return OrderHistoryCardProgressModel(
          text: "Order being processed",
          subtext: "Waiting for restaurant to respond",
          backgroundColor: const Color(0xFFD9F4EF),
          subtextColor: const Color(0xff114F39),
        );
    }
  }
}

class OrderHistoryCardProgressModel {
  final String text;
  final String subtext;
  final Color backgroundColor;
  final Color subtextColor;

  OrderHistoryCardProgressModel({
    required this.text,
    required this.subtext,
    required this.backgroundColor,
    required this.subtextColor,
  });
}
