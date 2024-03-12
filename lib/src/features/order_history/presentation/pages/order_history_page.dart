import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order_history/order_history.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../authentication/authentication.dart';

class OrderHistoryPage extends StatefulWidget {
  const OrderHistoryPage({super.key});

  @override
  State<OrderHistoryPage> createState() => _OrderHistoryPageState();
}

class _OrderHistoryPageState extends State<OrderHistoryPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  final _scrollController = ScrollController();

  final int limit = 10;
  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
  final List<String> orderTypes = ["Pending", "Completed"];

  @override
  void initState() {
    super.initState();
    _tabController = TabController(
      length: 2,
      vsync: this,
    );
    _scrollController.addListener(_onHistoryScroll);

    if (user != null) {
      BlocProvider.of<OrderHistoryBloc>(context).add(
        FetchOrderHistory(
          userId: user!.id!,
          status: orderTypes[0],
          page: 1,
          limit: limit,
        ),
      );

      context.read<OrderHistoryStatusBloc>().add(OrderHistoryConnectSocket());
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        title: 'Order History',
        onTap: () {
          Navigator.pop(context);
        },
      ),
      body: SafeArea(
        child: Column(
          children: [
            verticalPadding(height: 2),
            Expanded(
              child: Column(
                children: [
                  TabBar(
                    controller: _tabController,
                    physics: const NeverScrollableScrollPhysics(),
                    isScrollable: false,
                    onTap: (index) {
                      if (user != null) {
                        context.read<OrderHistoryBloc>().add(
                              FetchOrderHistory(
                                userId: user!.id!,
                                status: orderTypes[index],
                                page: 1,
                                limit: limit,
                              ),
                            );
                      }
                    },
                    overlayColor: WidgetStateProperty.all<Color>(
                      AppColors.primaryColor.withOpacity(.05),
                    ),
                    splashBorderRadius: BorderRadius.circular(10),
                    indicatorColor: AppColors.primaryColor,
                    dividerColor: Colors.transparent,
                    unselectedLabelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w500,
                      fontSize: 16.sp,
                      color: AppColors.grey500,
                    ),
                    labelStyle: GoogleFonts.poppins(
                      fontWeight: FontWeight.w600,
                      fontSize: 16.sp,
                      color: AppColors.secondaryColor,
                    ),
                    tabs: [
                      Tab(text: '${orderTypes.first} Orders'),
                      Tab(text: '${orderTypes.last} Orders'),
                    ],
                  ),
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      physics: const NeverScrollableScrollPhysics(),
                      children: [
                        OrderHistoryResultList(
                          tabController: _tabController,
                          scrollController: _scrollController,
                        ),
                        OrderHistoryResultList(
                          tabController: _tabController,
                          scrollController: _scrollController,
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _onHistoryScroll() {
    final state = context.read<OrderHistoryBloc>().state;

    if (state is OrderHistoryLoaded && state.hasReachedMax && _isBottom) {
      return;
    }
    if (state is OrderHistoryLoaded && _isBottom && !state.hasReachedMax) {
      context.read<OrderHistoryBloc>().add(
            FetchOrderHistory(
              userId: user!.id!,
              status: orderTypes[_tabController.index],
              page: state.page,
              limit: limit,
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

class OrderHistoryResultList extends StatelessWidget {
  final TabController tabController;

  final ScrollController scrollController;
  final limit = 10;
  const OrderHistoryResultList({
    super.key,
    required this.tabController,
    required this.scrollController,
  });

  @override
  Widget build(BuildContext context) {
    final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
    final List<String> orderTypes = ["pending", "completed"];
    return RefreshIndicator(
      onRefresh: () async {
        if (user != null) {
          context.read<OrderHistoryBloc>().add(
                FetchOrderHistory(
                  userId: user.id!,
                  status: orderTypes[tabController.index],
                  page: 1,
                  limit: limit,
                ),
              );
        }
      },
      child: SingleChildScrollView(
        controller: scrollController,
        physics: const AlwaysScrollableScrollPhysics(),
        child: BlocBuilder<OrderHistoryBloc, OrderHistoryState>(
          builder: (context, orderState) {
            if (orderState is OrderHistoryNextLoading) {
              return Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  ...orderState.orders.map(
                    (orderItem) => OrderHistoryCard(
                      orderData: orderItem,
                    ),
                  ),
                  SizedBox(
                    height: 0.6.h,
                  ),
                  const LoadingCircularIndicator(
                    text: "Loading orders",
                  ),
                ],
              );
            } else if (orderState is OrderHistoryLoaded) {
              if (orderState.orders.isEmpty) {
                return SizedBox(
                  height: 80.h,
                  child: const Center(
                    child: ErrorAndInfoDisplayWidget(
                        assetImage: "assets/icons/no_content.svg",
                        title: "Orders not found",
                        description:
                            "You don't have pre-orders available at the moment.",
                        onPressed: null),
                  ),
                );
              }
              return Container(
                margin: const EdgeInsets.symmetric(vertical: 16),
                child: Column(
                  children: [
                    ...orderState.orders.map(
                      (orderItem) => OrderHistoryCard(
                        orderData: orderItem,
                      ),
                    ),
                    if (orderState.hasReachedMax)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            " No more orders :(",
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 14.sp,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              );
            } else if (orderState is OrderHistoryLoading) {
              return SizedBox(
                height: 80.h,
                child: const LoadingCircularIndicator(
                  text: "Loading orders",
                ),
              );
            } else if (orderState is OrderHistoryError) {
              return Center(
                child: ErrorAndInfoDisplayWidget(
                  assetImage: 'assets/images/connection_lost.svg',
                  title: "Fetching orders failed",
                  description: orderState.errorMessage,
                  onPressed: () {
                    if (user != null) {
                      BlocProvider.of<OrderHistoryBloc>(context).add(
                        FetchOrderHistory(
                          userId: user.id!,
                          status: orderTypes[tabController.index],
                          page: 1,
                          limit: limit,
                        ),
                      );
                    }
                  },
                ),
              );
            }
            return Container(
              height: 300,
              color: Colors.transparent,
              child: Container(),
            );
          },
        ),
      ),
    );
  }
}
