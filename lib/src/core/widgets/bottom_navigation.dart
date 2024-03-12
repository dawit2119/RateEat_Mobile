import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/svg.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/order_history/presentation/bloc/orders_count/order_count_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart'; // Import responsive_sizer

import '../../features/authentication/authentication.dart';
import '../../features/notification/presentation/bloc/un_read_notification_counter/un_read_notification_counter_bloc.dart';

class CustomBottomNavigationBar extends StatelessWidget {
  const CustomBottomNavigationBar({super.key});

  bool getUser() {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      var currentIndex = dpLocator<BottomNavIndexBloc>().state;
      final unReadNotificationsBloc =
          dpLocator<UnreadNotificationsCounterBloc>();
      final ordersCountBloc = dpLocator<OrdersCountBloc>();
      if (user != null && currentIndex == 0) {
        if (unReadNotificationsBloc.state
            is! UnreadNotificationsCounterFetched) {
          unReadNotificationsBloc.add(
            GetUnreadNotificationsCount(
              userId: user.id!,
            ),
          );
        }
        if (ordersCountBloc.state is! OrdersCountLoaded) {
          ordersCountBloc.add(
            FetchOrdersCount(userId: user.id!, status: "pending"),
          );
        }
      }
      return user != null;
    } on CacheException {
      return false;
    }
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<BottomNavIndexBloc, int>(
      builder: (context, state) {
        return Scaffold(
          bottomNavigationBar: BottomNavigationBar(
            type: BottomNavigationBarType.fixed,
            elevation: 5,
            showUnselectedLabels: true,
            unselectedItemColor: Colors.grey,
            selectedItemColor: const Color(0XFFFF3008),
            currentIndex: state,
            selectedLabelStyle: TextStyle(
              fontSize: 12.sp, // Responsive font size
              fontWeight: FontWeight.w600,
              overflow: TextOverflow.ellipsis,
            ),
            unselectedLabelStyle: TextStyle(
              fontSize: 11.sp, // Responsive font size
              overflow: TextOverflow.ellipsis,
            ),
            onTap: (index) {
              context.read<BottomNavIndexBloc>().changeIndex(index);
            },
            items: [
              _buildBottomNavBarItem(
                icon: "assets/icons/home-2.svg",
                label: AppLocalizations.of(context)!.homeText,
              ),
              _buildBottomNavBarItem(
                icon: "assets/icons/discover.svg",
                label: AppLocalizations.of(context)!.discoverText,
              ),
              _buildBottomNavBarItem(
                icon: "assets/icons/search.svg",
                label: AppLocalizations.of(context)!.searchText,
              ),
              _buildBottomNavBarItem(
                icon: "assets/icons/user.svg",
                label: AppLocalizations.of(context)!.profileText,
              )
            ],
          ),
        );
      },
    );
  }

  BottomNavigationBarItem _buildBottomNavBarItem({
    required String icon,
    required String label,
  }) {
    return BottomNavigationBarItem(
      icon: Container(
        margin: EdgeInsets.only(
          bottom: 1.h, // Responsive margin
        ),
        child: CircleAvatar(
          radius: 2.h, // Responsive radius
          backgroundColor: Colors.transparent,
          child: SvgPicture.asset(
            icon,
            colorFilter: const ColorFilter.mode(
              Colors.grey,
              BlendMode.srcIn,
            ),
          ),
        ),
      ),
      label: label,
    );
  }
}

class BottomNavIndexBloc extends Cubit<int> {
  BottomNavIndexBloc(super.initialState);
  changeIndex(index) => emit(index);
}
