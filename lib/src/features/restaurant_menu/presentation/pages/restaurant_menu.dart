import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/src/core/widgets/custom_app_bar.dart';
import 'package:rateeat_mobile/src/features/restaurant_menu/presentation/pages/menu_items_list.dart';
import 'package:video_player/video_player.dart';
import '../../../features.dart';
import '../../../homepage/domain/entities/item.dart';
import '../../../item_category/presentation/widgets/tag_shimmer.dart';
import '../../../item_detail/data/data.dart';
import '../../../item_detail/presentation/pages/widgets/image_and_video_highlight.dart';
import '../../data/models/restaurant_category.dart';
import '../bloc/restaurant_category/restaurant_category_bloc.dart';
import '../widgets/categories.dart';

class RestaurantMenu extends StatelessWidget {
  final Restaurant restaurant;
  const RestaurantMenu({
    super.key,
    required this.restaurant,
  });

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      resizeToAvoidBottomInset: false,
      appBar: CustomAppBar(
          onTap: () {
            context.pop();
          },
          title: restaurant.name!),
      body: NestedScrollView(
        headerSliverBuilder: (context, value) {
          return [];
        },
        body: buildRestaurantInfo(context),
      ),
    );
  }

  Widget buildRestaurantInfo(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 10),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          BlocBuilder<RestaurantCategoryBloc, RestaurantCategoryState>(
            builder: (context, state) {
              if (state is RestaurantCategoriesLoading) {
                return SingleChildScrollView(
                  key: const Key("restaurant_menu_categories_loading"),
                  scrollDirection: Axis.horizontal,
                  child: Wrap(
                    direction: Axis.horizontal,
                    spacing: 2.0,
                    runSpacing: 2.0,
                    children: List.generate(
                      7,
                      (index) => const TagShimmer(),
                    ),
                  ),
                );
              }
              if (state is RestaurantCategoriesLoaded) {
                final categories = [
                  const RestaurantMenuCategoryModel(
                    id: "",
                    name: "All",
                    menuId: "",
                    isApproved: true,
                  ),
                  ...state.categories,
                ];

                return Categories(
                  categories: categories,
                  restaurantId: restaurant.id!,
                );
              }
              return Container();
            },
          ),
          MenuPage(
            restaurant: restaurant,
          )
        ],
      ),
    );
  }
}

class CustomSliverRestaurantAppBarDelegate
    extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Restaurant restaurant;
  final VideoPlayerController? videoPlayerController;

  const CustomSliverRestaurantAppBarDelegate({
    required this.expandedHeight,
    required this.restaurant,
    this.videoPlayerController,
  });

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        buildHighlight(shrinkOffset, restaurant),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildHighlight(double shrinkOffset, restaurant) => Opacity(
        opacity: disappear(shrinkOffset),
        child: HorizontalHighlight(
          highlights: mapToHighlightModels(
            restaurant.restaurantImages ?? [],
            restaurant.restaurantVideos ?? [],
          ),
          videoController: videoPlayerController,
          isFavorite: restaurant.isFavorite,
          isItem: false,
          restaurant: restaurant,
        ),
      );

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}

class CustomSliverItemAppBarDelegate extends SliverPersistentHeaderDelegate {
  final double expandedHeight;
  final Item item;
  final VideoPlayerController? videoPlayerController;

  const CustomSliverItemAppBarDelegate(
      {required this.expandedHeight,
      required this.item,
      this.videoPlayerController});

  @override
  Widget build(
      BuildContext context, double shrinkOffset, bool overlapsContent) {
    return Stack(
      clipBehavior: Clip.none,
      fit: StackFit.expand,
      children: [
        buildHighlight(shrinkOffset, item),
      ],
    );
  }

  double appear(double shrinkOffset) => shrinkOffset / expandedHeight;

  double disappear(double shrinkOffset) => 1 - shrinkOffset / expandedHeight;

  Widget buildHighlight(double shrinkOffset, item) => Opacity(
        opacity: disappear(shrinkOffset),
        child: HorizontalHighlight(
          highlights: mapToHighlightModels(
              (item.itemImages?.isEmpty ?? true)
                  ? [
                      ItemMedia.fromJson(
                          {'id': item.itemId, 'url': item.imageUrl})
                    ]
                  : item.itemImages!,
              item.itemVideos ?? []),
          item: item,
          isFavorite: item.isFavorite,
          videoController: videoPlayerController,
        ),
      );

  @override
  double get maxExtent => expandedHeight;

  @override
  double get minExtent => kToolbarHeight + 30;

  @override
  bool shouldRebuild(SliverPersistentHeaderDelegate oldDelegate) => true;
}
