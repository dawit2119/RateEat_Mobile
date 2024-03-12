import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/domain/entities/item.dart';
import './order_item_card.dart';

import '../../../restaurant_menu/presentation/bloc/restaurant_menu/restaurant_menu_bloc.dart';

class OrderItems extends StatefulWidget {
  final Restaurant restaurant;
  final List<Item> restaurantItems;
  const OrderItems({
    super.key,
    required this.restaurantItems,
    required this.restaurant,
  });

  @override
  State<OrderItems> createState() => _OrderItemsState();
}

class _OrderItemsState extends State<OrderItems> {
  final _scrollController = ScrollController();
  int page = 1;
  int limit = 7;

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
      context.read<RestaurantMenuBloc>().add(
            GetRestaurantMenuCategoryItems(
              restaurantId: widget.restaurant.id!,
              categoryId: restaurantMenuState.categoryId,
              page: restaurantMenuState.page + 1,
              limit: 10,
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
    return Expanded(
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16.0),
        child: GridView.builder(
          controller: _scrollController,
          shrinkWrap: true,
          gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
            crossAxisSpacing: 8.0,
            mainAxisSpacing: 8.0,
            crossAxisCount: 2,
            childAspectRatio: 0.76,
          ),
          itemBuilder: (BuildContext context, int index) {
            var item = widget.restaurantItems[index];
            return OrderItemCard(
              item: item,
              restaurant: widget.restaurant,
              currencyCode: widget.restaurant.currencyCode,
            );
          },
          itemCount: widget.restaurantItems.length,
        ),
      ),
    );
  }
}

class OrderCategoriesPageCubit extends Cubit<int> {
  OrderCategoriesPageCubit() : super(1);

  void changeIndex(index) => emit(index);
}

class CategoriesNameCubit extends Cubit<String> {
  CategoriesNameCubit() : super("");

  void changeIndex(index) => emit(index);
}
