import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class CustomTabBar extends StatelessWidget implements PreferredSizeWidget {
  final TabBar tabBar;
  final double height;

  const CustomTabBar({super.key, required this.tabBar, required this.height});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: height,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(14),
      ),
      child: tabBar,
    );
  }

  @override
  Size get preferredSize => Size.fromHeight(height);
}

class UserReviewsPageCubit extends Cubit<int> {
  UserReviewsPageCubit() : super(1);
  void changePage(page) => emit(page);
}

class SavedReviewsPageCubit extends Cubit<int> {
  SavedReviewsPageCubit() : super(1);
  void changePage(page) => emit(page);
}
