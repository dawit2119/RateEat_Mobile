import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/widgets/updated_bottom_sheet.dart';
import 'package:rateeat_mobile/src/features/notification/presentation/bloc/un_read_notification_counter/un_read_notification_counter_bloc.dart';

import '../../features/discover_item/presentation/pages/item_result_page.dart';
import '../../features/discover_restaurant_result/presentation/pages/discover_result_page.dart';
import '../../features/features.dart';
import '../../features/search_result/presentation/pages/search_result_page.dart';
import '../../features/user_profile/presentation/pages/pages.dart';
import 'login_redirect_page.dart';

class CustomPersistentBottomNavBar extends StatefulWidget {
  const CustomPersistentBottomNavBar({super.key});

  @override
  State<CustomPersistentBottomNavBar> createState() =>
      _CustomPersistentBottomNavBarState();
}

class _CustomPersistentBottomNavBarState
    extends State<CustomPersistentBottomNavBar> {
  late PageController bottomNavPageController;

  @override
  void initState() {
    super.initState();
    bottomNavPageController = PageController(
        initialPage: context.read<BottomNavigationCubit>().state);
  }

  @override
  Widget build(BuildContext context) {
    return Builder(builder: (context) {
      return Scaffold(
        bottomNavigationBar: const UpdatedBottomNavigationBar(),
        body: BlocListener<BottomNavigationCubit, int>(
          listener: (context, state) {
            bottomNavPageController.jumpToPage(
              state,
            );
          },
          child: PageView.builder(
            controller: bottomNavPageController,
            itemCount: 5,
            physics: const NeverScrollableScrollPhysics(),
            dragStartBehavior: DragStartBehavior.start,
            itemBuilder: (context, index) {
              return [
                const HomePage(),
                _homeScreensMapping(),
                Container(),
                const SearchResultPage(),
                getUser() ? const UserProfile() : const RedirectLoginWidget()
              ].elementAt(index);
            },
          ),
        ),
      );
    });
  }

  bool getUser() {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      var unReadNotificationsBloc =
          context.read<UnreadNotificationsCounterBloc>();

      if (user != null && context.read<BottomNavigationCubit>().state == 0) {
        if (unReadNotificationsBloc.state
            is! UnreadNotificationsCounterFetched) {
          unReadNotificationsBloc.add(
            GetUnreadNotificationsCount(userId: user.id!),
          );
        }
      }
      return user != null;
    } on CacheException {
      return false;
    }
  }

  Widget? _homeScreensMapping() {
    var currentScreen = context.read<DiscoverSelectedScreenCubit>().state;
    final Map<DiscoverResultScreens, Widget> discoverScreenOptions = {
      DiscoverResultScreens.discoverOptionsPage: const DiscoverScreen(),
      DiscoverResultScreens.discoverRestaurantResultPage:
          const DiscoverResultPage(),
      DiscoverResultScreens.discoverItemsResultPage: const ItemResultPage(),
    };
    return discoverScreenOptions[currentScreen];
  }
}

class BottomNavigationCubit extends Cubit<int> {
  BottomNavigationCubit() : super(0);

  changeIndex(int index) => emit(index);
  resetIndex() => emit(0);
}

class DiscoverSelectedScreenCubit extends Cubit<DiscoverResultScreens> {
  DiscoverSelectedScreenCubit()
      : super(DiscoverResultScreens.discoverOptionsPage);
  toDiscoverRestaurantResult() =>
      emit(DiscoverResultScreens.discoverRestaurantResultPage);
  toDiscoverItemsResult() =>
      emit(DiscoverResultScreens.discoverItemsResultPage);
  toDiscoverOptionsPage() => emit(DiscoverResultScreens.discoverOptionsPage);
}

enum DiscoverResultScreens {
  discoverOptionsPage,
  discoverRestaurantResultPage,
  discoverItemsResultPage
}
