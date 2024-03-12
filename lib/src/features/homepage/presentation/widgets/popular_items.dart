import 'dart:developer';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/bloc/tag/tag_bloc.dart';
import 'package:rateeat_mobile/src/features/homepage/presentation/widgets/shimmer/popular_items_shimmer.dart';

import '../../domain/entities/item.dart';
import '../bloc/highest_rated/popular_event.dart';
import '../bloc/highest_rated/popular_state.dart';

class PopularItems extends StatefulWidget {
  final List<Item>? popular;
  const PopularItems({super.key, required this.popular});

  @override
  State<PopularItems> createState() => _PopularItemsState();
}

class _PopularItemsState extends State<PopularItems> {
  final _scrollController = ScrollController();
  bool isLoading = false;
  int page = 1;
  List<Item> popularItems = [];

  @override
  void initState() {
    super.initState();
    popularItems = widget.popular!;
    _scrollController.addListener(_onScroll);
  }

  mapPopularItems() {
    return popularItems.map((item) => Padding(
          padding: const EdgeInsets.only(right: 12, top: 8, left: 4),
          child: FoodCard(
            item: item,
          ),
        ));
  }

  @override
  Widget build(BuildContext context) {
    log('popular items build card $popularItems');

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        BlocConsumer<PopularBloc, PopularState>(
          listener: (context, state) {
            if (state is TopRatedState &&
                state.status == ItemStatus.nextError) {
              showCustomToast(
                context: context,
                toastMessage: "Error Loading More Items",
                toastType: ToastType.error,
              );

              setState(() {
                page -= 1;
                isLoading = false;
              });
            }
            if (state is TopRatedState && state.status == ItemStatus.loaded) {
              setState(() {
                popularItems = state.popular!;
                isLoading = false;
              });
            }
          },
          builder: (context, state) {
            return SingleChildScrollView(
              scrollDirection: Axis.horizontal,
              controller: _scrollController,
              child: Row(
                children: [
                  ...mapPopularItems().toList(),
                  (isLoading &&
                          (state is TopRatedState && !state.hasReachedMax))
                      ? const PopularItemsShimmerHorizontal(
                          shimmerCount: 1,
                        )
                      : Container(),
                ],
              ),
            );
          },
        ),
      ],
    );
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final state = context.read<PopularBloc>().state as TopRatedState;
    if (state.hasReachedMax && _isBottom) {
      return;
    }
    if (_isBottom && !isLoading && !state.hasReachedMax) {
      setState(() {
        isLoading = true;
        page += 1;
      });

      if (context.read<UserLocationBloc>().state is UserLocationLoaded) {
        var userLocation =
            (context.read<UserLocationBloc>().state as UserLocationLoaded)
                .location;
        context.read<PopularBloc>().add(
              GetTopRatedEvent(
                page: page,
                lat: userLocation.latitude,
                lng: userLocation.longitude,
                tags: context.read<TagBloc>().state.selectedTags,
                isFasting: context.read<HomeFastingToggleBloc>().state,
              ),
            );
      } else {
        context.read<PopularBloc>().add(
              GetTopRatedEvent(
                page: page,
                tags: context.read<TagBloc>().state.selectedTags,
                isFasting: context.read<HomeFastingToggleBloc>().state,
              ),
            );
      }
    }
  }

  bool get _isBottom {
    if (!_scrollController.hasClients) return false;
    final maxScroll = _scrollController.position.maxScrollExtent;
    final currentScroll = _scrollController.position.pixels;
    return currentScroll == maxScroll;
  }
}

class NextIsLoadingBloc extends Cubit<bool> {
  NextIsLoadingBloc(super.initialState);
  changeIsLoading(isLoading) => emit(isLoading);
}
