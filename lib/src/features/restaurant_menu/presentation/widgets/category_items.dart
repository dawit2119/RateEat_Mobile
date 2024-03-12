import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/widgets/menu_item_card.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../bloc/restaurant_menu/restaurant_menu_bloc.dart';

class CategoryItems extends StatefulWidget {
  final Restaurant restaurant;
  final List<Item> restaurantItems;
  final String sortBy;
  const CategoryItems({
    super.key,
    required this.restaurantItems,
    required this.restaurant,
    required this.sortBy,
  });

  @override
  State<CategoryItems> createState() => _CategoryItemsState();
}

class _CategoryItemsState extends State<CategoryItems> {
  final _scrollController = ScrollController();
  int page = 1;
  int limit = 10;

  @override
  void initState() {
    _scrollController.addListener(_onScroll);
    super.initState();
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final restaurantMenuBloc = context.read<RestaurantMenuBloc>();
    final restaurantMenuState = restaurantMenuBloc.state;
    if (_isBottom &&
        restaurantMenuState is RestaurantMenuCategoryItemsFetched &&
        (restaurantMenuState).hasMaxReached) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("No more items"),
        ),
      );
      return;
    } else if (_isBottom &&
        restaurantMenuState is RestaurantMenuCategoryItemsFetched &&
        !(restaurantMenuState).hasMaxReached) {
      final currentPage = restaurantMenuState.page;
      context.read<RestaurantMenuBloc>().add(
            GetRestaurantMenuCategoryItems(
              restaurantId: widget.restaurant.id!,
              categoryId: restaurantMenuState.categoryId,
              page: currentPage + 1,
              limit: 10,
              query: restaurantMenuState.query,
              sortBy: widget.sortBy,
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

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16.0),
      child: SizedBox(
        height: 65.h,
        child: Column(
          children: [
            Expanded(
              child: GridView.builder(
                controller: _scrollController,
                shrinkWrap: true,
                gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                  crossAxisSpacing: 8.0,
                  mainAxisSpacing: 8.0,
                  crossAxisCount: 2,
                  childAspectRatio: 0.78,
                ),
                itemBuilder: (BuildContext context, int index) {
                  var item = widget.restaurantItems[index];
                  return MenuFoodCard(
                    restaurant: widget.restaurant,
                    item: item,
                  );
                },
                itemCount: widget.restaurantItems.length,
              ),
            ),
            BlocBuilder<RestaurantMenuBloc, RestaurantMenuState>(
              builder: (context, state) {
                if (state is RestaurantMenuCategoryItemsNextLoading) {
                  return Padding(
                    padding: const EdgeInsets.symmetric(
                      vertical: 10,
                    ),
                    child: Center(
                      child: LoadingAnimationWidget.dotsTriangle(
                        color: AppColors.primaryColor,
                        size: 4.h,
                      ),
                    ),
                  );
                }
                return Container();
              },
            ),
          ],
        ),
      ),
    );
  }
}

class CategoriesPageCubit extends Cubit<int> {
  CategoriesPageCubit() : super(1);

  void changeIndex(index) => emit(index);
}

class CategoriesNameCubit extends Cubit<String> {
  CategoriesNameCubit() : super("");

  void changeIndex(index) => emit(index);
}
