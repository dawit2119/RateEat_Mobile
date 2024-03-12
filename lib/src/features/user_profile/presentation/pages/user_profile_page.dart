import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/widgets/offline_data_widget.dart';
import 'package:rateeat_mobile/src/features/authentication/data/data.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_state.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_draft_review/delete_draft_review_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_event.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_item_review/delete_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/delete_restaurant_review/delete_restaurant_review_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/recommendation/recommendation_event.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/recommendation/recommendation_state.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/saved_reviews/saved_reviews_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/custom_tab_bar.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/profile_header.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/recommendation_card.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/saved_review_card.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/shimmer/user_favorite_items_shimmer.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/shimmer/user_recommendation_items_shimmer.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/shimmer/user_review_shimmer.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import '../../../../core/utils/external_app_intent.dart';
import '../../../../core/widgets/custom_persistent_bottom_navbar.dart';

class UserProfile extends StatefulWidget {
  const UserProfile({super.key});

  @override
  State<UserProfile> createState() => _UserProfileState();
}

class _UserProfileState extends State<UserProfile>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late dynamic debouncedReviewScroll;
  late dynamic debouncedSavedReviewScroll;

  final reviewsController = ScrollController();
  final savedReviewsController = ScrollController();
  final recommendationController = ScrollController();
  final _tabScrollController = ScrollController();
  final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
  late OverlayPortalController _offlineDataOverlayController;
  int favoriteCount = 0;
  int draftCount = 0;

  @override
  void initState() {
    super.initState();
    SchedulerBinding.instance
        .addPostFrameCallback((_) => listenShareMediaFiles(context));
    reviewsController.addListener(_onReviewScroll);
    savedReviewsController.addListener(_onSavedReviewScroll);
    recommendationController.addListener(_onRecommendationScroll);
    _tabController = TabController(length: 4, vsync: this);
    _offlineDataOverlayController = OverlayPortalController();
    if (user?.id != null) {
      debouncedReviewScroll = debounce(_onReviewScroll, 600);
      debouncedSavedReviewScroll = debounce(_onSavedReviewScroll, 600);

      //* Get User data
      if (context.read<SavedReviewsBloc>().state is! SavedReviewLoaded) {
        context.read<SavedReviewsBloc>().add(GetSavedReviewsEvent());
      }
      if (context.read<GetUserProfileBloc>().state is! UserProfileLoaded) {
        context.read<GetUserProfileBloc>().add(
              GetUserProfileEvent(
                userId: user!.id!,
              ),
            );
      }

      if (context.read<UserFavoriteBloc>().state is! UserFavoritesLoaded) {
        context.read<UserFavoriteBloc>().add(
              GetUserFavoritesEvent(
                userId: user!.id!,
              ),
            );
      }

      if (context.read<UserReviewBloc>().state is! UserReviewLoaded) {
        context.read<UserReviewBloc>().add(
              GetUserReviewEvent(
                userId: user!.id!,
                page: 1,
              ),
            );
      }
      if (context.read<RecommendationBloc>().state is! RecommendationSuccess) {
        context.read<RecommendationBloc>().add(
              GetMyRecommendations(page: 1, recommendations: []),
            );
      }
      if (context.read<RankBloc>().state is! RankSuccess) {
        context.read<RankBloc>().add(GetUserRank());
      }
    }
  }

  void validate() {
    if (!mounted) return;

    SchedulerBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;

      bool shouldShowOffline = false;

      final profileState = context.read<GetUserProfileBloc>().state;
      final savedReviewState = context.read<SavedReviewsBloc>().state;
      final userReviewState = context.read<UserReviewBloc>().state;
      final recommendationState = context.read<RecommendationBloc>().state;
      final favoriteState = context.read<UserFavoriteBloc>().state;

      // Check if any loaded state is using local/cached data
      if (savedReviewState is SavedReviewLoaded &&
          savedReviewState.isLocalData) {
        shouldShowOffline = true;
      } else if (profileState is UserProfileLoaded &&
          profileState.isLocalData) {
        shouldShowOffline = true;
      } else if (userReviewState is UserReviewLoaded &&
          userReviewState.isLocalData) {
        shouldShowOffline = true;
      }
      // else if (recommendationState is RecommendationSuccess &&
      //     recommendationState.isLocalData) {
      //   shouldShowOffline = true;
      // }
      else if (favoriteState is UserFavoritesLoaded &&
          favoriteState.isLocalData) {
        shouldShowOffline = true;
      }
      // Also check for error states (no internet, no cache)
      else if (profileState is GetUserProfileError ||
          savedReviewState is SavedReviewError ||
          userReviewState is UserReviewError ||
          recommendationState is RecommendationFailed ||
          favoriteState is UserFavoritesError) {
        shouldShowOffline = true;
      }

      if (shouldShowOffline) {
        _offlineDataOverlayController.show();
      } else {
        if (_offlineDataOverlayController.isShowing) {
          _offlineDataOverlayController.hide();
        }
      }
    });
  }

  Function debounce(Function function, int delay) {
    Timer? timer;
    return () {
      if (timer != null) {
        timer!.cancel();
      }

      timer = Timer(Duration(milliseconds: delay), () {
        function();
      });
    };
  }

  @override
  void dispose() {
    super.dispose();
    reviewsController
      ..removeListener(_onReviewScroll)
      ..dispose();
    savedReviewsController
      ..removeListener(_onSavedReviewScroll)
      ..dispose();
    recommendationController
      ..removeListener(_onRecommendationScroll)
      ..dispose();
  }

  Future refresh() {
    context.read<GetUserProfileBloc>().add(
          GetUserProfileEvent(
            userId: user != null ? user!.id! : "",
          ),
        );
    context.read<UserFavoriteBloc>().add(
          GetUserFavoritesEvent(
            userId: user != null ? user!.id! : "",
          ),
        );
    context.read<UserReviewBloc>().add(
          GetUserReviewEvent(
            userId: user?.id ?? "",
            page: 1,
          ),
        );
    context.read<SavedReviewsBloc>().add(GetSavedReviewsEvent());
    context.read<RecommendationBloc>().add(
          GetMyRecommendations(page: 1, recommendations: []),
        );
    return Future.delayed(const Duration(seconds: 1));
  }

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, _) {
        if (!didPop) {
          context.read<DiscoverSelectedScreenCubit>().toDiscoverOptionsPage();
          context.read<BottomNavigationCubit>().changeIndex(1);
          context.goNamed(
            AppRoutes.home,
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: Text(
            AppLocalizations.of(context)!.profileText,
            style: semiBold18,
          ),
          //centerTitle: true,
          actions: [
            IconButton(
              onPressed: () {
                context.pushNamed(AppRoutes.settingsPage);
              },
              icon: Icon(
                Iconsax.setting_2,
                color: Colors.black,
                size: screenHeight * 0.025,
                semanticLabel: "Settings",
              ),
            ),
          ],
        ),
        body: OverlayPortal(
          controller: _offlineDataOverlayController,
          overlayChildBuilder: (context) => Align(
            alignment: Alignment
                .bottomCenter, // Position it at the bottom of the screen
            child: Padding(
              padding: const EdgeInsets.only(
                  bottom: 100.0), // Adjust position above the bottom
              child: OfflineDataWidget(
                onPressed: () {
                  _offlineDataOverlayController.hide();
                },
              ),
            ),
          ),
          child: BlocBuilder<GetUserProfileBloc, GetUserProfileState>(
            builder: (context, state) {
              validate();
              if (state is UserProfileLoading) {
                return Center(
                  key: const Key("Loading Center Widget"),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      LoadingAnimationWidget.dotsTriangle(
                        key: const Key("Loading Animation Widget"),
                        color: AppColors.primaryColor,
                        size: 60,
                      ),
                      verticalPadding(height: 2),
                      Text(
                        AppLocalizations.of(context)!.loadingProfileText,
                        style: subTitleTextStyle,
                      ),
                    ],
                  ),
                );
              } else if (state is UserProfileLoaded) {
                return SizedBox(
                  key: const Key("Profile Loaded Widget"),
                  height: 100.h,
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: DefaultTabController(
                      length: 4,
                      child: NotificationListener(
                        onNotification: (ScrollNotification scrollInfo) {
                          setState(() {});
                          if (scrollInfo.metrics.pixels ==
                              scrollInfo.metrics.maxScrollExtent) {
                            if (_tabController.index == 0) {
                              debouncedReviewScroll();
                            } else if (_tabController.index == 2) {
                              debouncedSavedReviewScroll();
                            }
                          }
                          return true;
                        },
                        child: RefreshIndicator(
                          onRefresh: refresh,
                          color: Colors.red,
                          child: SingleChildScrollView(
                            child: Column(
                              children: [
                                const ProfileHeader(),
                                SingleChildScrollView(
                                  scrollDirection: Axis.horizontal,
                                  controller: _tabScrollController,
                                  child: CustomTabBar(
                                    height: 30.sp,
                                    tabBar: TabBar(
                                      isScrollable: true,
                                      controller: _tabController,
                                      tabAlignment: TabAlignment.center,
                                      labelColor: Colors.red,
                                      labelStyle:
                                          const TextStyle(color: Colors.red),
                                      dividerColor: Colors.transparent,
                                      indicator: const BoxDecoration(),
                                      // physics:
                                      //     const NeverScrollableScrollPhysics(),
                                      onTap: (index) {
                                        tabListener();
                                      },
                                      tabs: [
                                        _buildTab(
                                          title: AppLocalizations.of(context)!
                                              .revText
                                              .toUpperCase(),
                                          iconData: Iconsax.activity,
                                          count: state.user.userStat != null
                                              ? state
                                                  .user.userStat!.reviewsCount!
                                              : 0,
                                          isActive: _tabController.index == 0,
                                        ),
                                        _buildTab(
                                            title: AppLocalizations.of(context)!
                                                .favText
                                                .toUpperCase(),
                                            iconData:
                                                Icons.favorite_border_rounded,
                                            count: state.user.userStat != null
                                                ? state.user.userStat!
                                                    .favoritesCount!
                                                : 0,
                                            isActive:
                                                _tabController.index == 1),
                                        _buildTab(
                                            title: AppLocalizations.of(context)!
                                                .draftText
                                                .toUpperCase(),
                                            iconData: Icons.drafts_outlined,
                                            count: state.user.userStat
                                                        ?.draftsCount !=
                                                    null
                                                ? state
                                                    .user.userStat!.draftsCount!
                                                : 0,
                                            isActive:
                                                _tabController.index == 2),
                                        _buildTab(
                                            title: AppLocalizations.of(context)!
                                                .recommendations
                                                .toUpperCase(),
                                            iconData: Iconsax.like,
                                            count: state.user.userStat != null
                                                ? state.user.userStat!
                                                        .recommendations ??
                                                    0
                                                : 0,
                                            isActive:
                                                _tabController.index == 3),
                                      ],
                                    ),
                                  ),
                                ),
                                SizedBox(
                                  height: 50.h,
                                  child: Padding(
                                    padding: EdgeInsets.only(
                                        top: screenHeight * 0.015),
                                    child: TabBarView(
                                      controller: _tabController,
                                      children: [
                                        BlocConsumer<DeleteItemReviewBloc,
                                            DeleteItemReviewState>(
                                          listener: (context, state) {
                                            if (state
                                                is DeleteItemReviewSuccess) {
                                              showCustomToast(
                                                  context: context,
                                                  toastMessage: state.message,
                                                  toastType: ToastType.success);

                                              //* Call to load the current Review
                                              context
                                                  .read<UserReviewBloc>()
                                                  .add(
                                                    GetUserReviewEvent(
                                                      userId: user!.id!,
                                                      page: 1,
                                                    ),
                                                  );
                                            } else if (state
                                                is DeleteItemReviewFailure) {
                                              showCustomToast(
                                                context: context,
                                                toastMessage: state.message,
                                                toastType: ToastType.error,
                                              );
                                            } else {}
                                          },
                                          builder: (context, state) {
                                            return _buildUserReviewsTab(
                                                context);
                                          },
                                        ),
                                        _buildFavoritesTab(context),
                                        BlocConsumer<DeleteDraftReviewBloc,
                                            DeleteDraftReviewState>(
                                          listener: (context, state) {
                                            if (state
                                                is DeleteDraftItemReviewSuccess) {
                                              showCustomToast(
                                                context: context,
                                                toastMessage: state.message,
                                                toastType: ToastType.success,
                                              );
                                              //* Call to load the current Saved Reviews
                                              context
                                                  .read<SavedReviewsBloc>()
                                                  .add(GetSavedReviewsEvent());
                                            } else if (state
                                                is DeleteDraftItemReviewFailure) {
                                              showCustomToast(
                                                context: context,
                                                toastMessage: state.message,
                                                toastType: ToastType.error,
                                              );
                                            } else {}
                                          },
                                          builder: (context, state) {
                                            return buildSavedReviewsTab(
                                                context);
                                          },
                                        ),
                                        _buildRecommendedTab(context),
                                      ],
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                );
              } else if (state is GetUserProfileError) {
                return RefreshIndicator(
                  color: AppColors.primaryColor,
                  onRefresh: refresh,
                  child: ListView(
                    children: [
                      SizedBox(
                        height: 80.h,
                        child: Center(
                          child: ErrorAndInfoDisplayWidget(
                              assetImage: "assets/icons/no_internet_1.svg",
                              title:
                                  AppLocalizations.of(context)!.profileFailText,
                              description:
                                  AppLocalizations.of(context)!.tryAgainText,
                              onPressed: () {
                                context.read<GetUserProfileBloc>().add(
                                      GetUserProfileEvent(
                                        userId: user!.id!,
                                      ),
                                    );
                              }),
                        ),
                      ),
                    ],
                  ),
                );
              }
              return Container();
            },
          ),
        ),
      ),
    );
  }

  Widget _buildTab(
      {required String title,
      required IconData iconData,
      int count = 0,
      required bool isActive}) {
    return Padding(
      padding: EdgeInsets.symmetric(vertical: 8.sp),
      child: Row(
        children: [
          isActive
              ? Icon(
                  iconData,
                  color: Colors.red,
                  size: 16.sp,
                )
              : const SizedBox(),
          isActive
              ? SizedBox(
                  width: 1.w,
                )
              : const SizedBox(),
          Text(
            title,
            style: TextStyle(
              fontSize: 16.sp,
              color: isActive ? Colors.red : AppColors.grey600,
            ),
          ),
          !isActive
              ? SizedBox(
                  width: 1.w,
                )
              : const SizedBox(),
          !isActive
              ? AnimatedContainer(
                  duration: const Duration(milliseconds: 500),
                  width: 5.w,
                  height: 3.5.h,
                  decoration: const BoxDecoration(
                      shape: BoxShape.circle, color: Colors.grey),
                  child: Center(
                    child: Text(
                      count.toString(),
                      style: TextStyle(color: Colors.white, fontSize: 13.sp),
                    ),
                  ),
                )
              : const SizedBox()
        ],
      ),
    );
  }

  Widget buildSavedReviewsTab(BuildContext context) {
    return BlocBuilder<SavedReviewsBloc, SavedReviewsState>(
      builder: (context, savedReviewState) {
        validate();
        if (savedReviewState is SavedReviewLoaded) {
          var savedReviews = savedReviewState.savedReviews;
          if (savedReviews.isEmpty) {
            return ErrorAndInfoDisplayWidget(
              assetImage: "assets/icons/no_content.svg",
              title: AppLocalizations.of(context)!.profileNoDraftReviewsText,
              description:
                  AppLocalizations.of(context)!.profileNoDraftReviewsText1,
              onPressed: null,
            );
          }
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ...List.generate(
                      savedReviews.length,
                      (index) => DraftReviewCard(
                        savedReview: savedReviews[index],
                      ),
                    ),
                    if (savedReviewState.hasReachedMax)
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Center(
                          child: Text(
                            "${AppLocalizations.of(context)!.noMoreDraftReviewsText} :(",
                            style: GoogleFonts.poppins(
                              color: Colors.grey,
                              fontSize: 13,
                            ),
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ],
          );
        } else if (savedReviewState is SavedNextReviewsLoading) {
          var savedReviews = savedReviewState.savedReviews;
          return CustomScrollView(
            slivers: [
              SliverToBoxAdapter(
                child: Column(
                  children: [
                    ...List.generate(
                      savedReviews.length,
                      (index) => DraftReviewCard(
                        savedReview: savedReviews[index],
                      ),
                    ),
                    const UserReviewShimmerDisplay(
                      shimmerCount: 1,
                    ),
                  ],
                ),
              ),
            ],
          );
        } else if (savedReviewState is SavedReviewLoading) {
          return const UserReviewShimmerDisplay();
        } else if (savedReviewState is SavedReviewError) {
          return ErrorAndInfoDisplayWidget(
            assetImage: "assets/icons/no_internet_1.svg",
            title: AppLocalizations.of(context)!.unknownErrorText,
            description: AppLocalizations.of(context)!.tryAgainText,
            onPressed: () {
              context.read<SavedReviewsBloc>().add(
                    GetSavedReviewsEvent(
                      page: 1,
                      limit: 100,
                    ),
                  );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildUserReviewsTab(BuildContext context) {
    return BlocConsumer<DeleteRestaurantReviewBloc,
        DeleteRestaurantReviewState>(
      listener: (context, state) {
        if (state is DeleteRestaurantReviewSuccess) {
          showCustomToast(
            context: context,
            toastMessage: "Restaurant ${state.message}",
            toastType: ToastType.success,
          );

          //* Call to load the current Review
          context.read<UserReviewBloc>().add(
                GetUserReviewEvent(
                  userId: user!.id!,
                  page: 1,
                ),
              );
        } else if (state is DeleteRestaurantReviewFailure) {
          showCustomToast(
            context: context,
            toastMessage: "Restaurant ${state.message}",
            toastType: ToastType.error,
          );
        } else {}
      },
      builder: (context, state) {
        return BlocBuilder<UserReviewBloc, UserReviewState>(
          builder: (context, userReviewState) {
            validate();
            if (userReviewState is UserReviewLoaded) {
              var userReviews = userReviewState.userReviews;
              if (userReviews.isEmpty) {
                return ErrorAndInfoDisplayWidget(
                  assetImage: "assets/icons/no_content.svg",
                  title: AppLocalizations.of(context)!.profileNoReviewsText,
                  description:
                      AppLocalizations.of(context)!.profileNoReviewsText1,
                  onPressed: null,
                );
              }
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        ...List.generate(
                          userReviews.length,
                          (index) => UserReviewCard(
                            userReview: userReviews[index],
                          ),
                        ),
                        if (userReviewState.hasReachedMax)
                          Padding(
                            padding: const EdgeInsets.all(16.0),
                            child: Center(
                              child: Text(
                                "${AppLocalizations.of(context)!.noMoreReviewsText} :(",
                                style: GoogleFonts.poppins(
                                  color: Colors.grey,
                                  fontSize: 13,
                                ),
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                ],
              );
            } else if (userReviewState is UserNextReviewsLoading) {
              var userReviews = userReviewState.userReviews;
              return CustomScrollView(
                slivers: [
                  SliverToBoxAdapter(
                    child: Column(
                      children: [
                        ...List.generate(
                          userReviews.length,
                          (index) => UserReviewCard(
                            userReview: userReviews[index],
                          ),
                        ),
                        const UserReviewShimmerDisplay(
                          shimmerCount: 1,
                        ),
                      ],
                    ),
                  )
                ],
              );
            } else if (userReviewState is UserReviewLoading) {
              return const UserReviewShimmerDisplay();
            } else if (userReviewState is UserReviewError) {
              return ErrorAndInfoDisplayWidget(
                assetImage: "assets/icons/no_internet_1.svg",
                title: AppLocalizations.of(context)!.unknownErrorText,
                description: AppLocalizations.of(context)!.tryAgainText,
                onPressed: () {
                  context.read<UserReviewBloc>().add(
                        GetUserReviewEvent(
                          userId: user!.id!,
                          page: 1,
                        ),
                      );
                },
              );
            } else {
              return Container();
            }
          },
        );
      },
    );
  }

  Widget _buildFavoritesTab(BuildContext context) {
    return BlocBuilder<UserFavoriteBloc, UserFavoritesState>(
      builder: (context, userFavoritesState) {
        validate();
        if (userFavoritesState is UserFavoritesLoaded) {
          var favorites = userFavoritesState.favorites;
          if (favorites.isEmpty) {
            return ErrorAndInfoDisplayWidget(
              assetImage: "assets/icons/no_content.svg",
              title: AppLocalizations.of(context)!.noFavText,
              description: AppLocalizations.of(context)!.noFavText1,
              onPressed: null,
            );
          }
          return GridView.builder(
            itemCount: favorites.length,
            padding: const EdgeInsets.symmetric(
              horizontal: 4,
            ),
            gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
              crossAxisSpacing: 12,
              mainAxisSpacing: 16,
            ),
            itemBuilder: (BuildContext context, int index) => UserFavoriteCard(
              userFavorite: favorites[index],
            ),
          );
        } else if (userFavoritesState is UserFavoritesLoading) {
          return const UserFavoriteItemsShimmer();
        } else if (userFavoritesState is UserFavoritesError) {
          return ErrorAndInfoDisplayWidget(
            assetImage: "assets/icons/no_internet_1.svg",
            title: AppLocalizations.of(context)!.unknownErrorText,
            description: AppLocalizations.of(context)!.tryAgainText,
            onPressed: () {
              context.read<UserFavoriteBloc>().add(
                    GetUserFavoritesEvent(
                      userId: user!.id!,
                    ),
                  );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildRecommendedTab(BuildContext context) {
    return BlocBuilder<RecommendationBloc, RecommendationState>(
      builder: (context, state) {
        validate();
        if (state is RecommendationSuccess) {
          if (state.recommendations.isEmpty) {
            return ErrorAndInfoDisplayWidget(
              assetImage: "assets/icons/no_content.svg",
              title: AppLocalizations.of(context)!.noRecommendationFound,
              description: AppLocalizations.of(context)!.othersnoFavText,
              onPressed: null,
            );
          }
          return SingleChildScrollView(
            controller: recommendationController,
            child: Column(
              children: [
                ...List.generate(state.recommendations.length, (index) {
                  return RecommendationCard(
                      userRecommendation: state.recommendations[index]);
                }),
                state.hasReachedMax
                    ? Text(
                        AppLocalizations.of(context)!.noMoreRecommendations,
                        style: const TextStyle(color: AppColors.grey600),
                      )
                    : const SizedBox(
                        height: 0,
                      ),
                SizedBox(height: 10.h)
              ],
            ),
          );
        } else if (state is RecommendationLoading) {
          return const UserRecommendationItemsShimmer();
        } else if (state is RecommendationNextLoading) {
          return SingleChildScrollView(
            controller: recommendationController,
            child: Column(
              children: [
                ...List.generate(state.recommendations.length, (index) {
                  return RecommendationCard(
                      userRecommendation: state.recommendations[index]);
                }),
                const UserRecommendationItemsShimmer(
                  shimmerCount: 1,
                ),
              ],
            ),
          );
        } else {
          return ErrorAndInfoDisplayWidget(
            assetImage: "assets/icons/no_internet_1.svg",
            title: AppLocalizations.of(context)!.unknownErrorText,
            description: AppLocalizations.of(context)!.tryAgainText,
            onPressed: () {
              context.read<RecommendationBloc>().add(
                    GetMyRecommendations(page: 1, recommendations: []),
                  );
            },
          );
        }
      },
    );
  }

  void _onReviewScroll() {
    final state = context.read<UserReviewBloc>().state;
    if ((state is UserReviewLoaded) &&
        (state.hasReachedMax || state.isLocalData)) {
      return;
    } else if (state is UserReviewLoaded && !state.hasReachedMax) {
      var user = dpLocator<AuthenticationLocalSource>().getUserCredential();

      context.read<UserReviewBloc>().add(
            GetUserReviewEvent(
              userId: user!.id!,
              page: state.page + 1,
            ),
          );
    }
  }

  void _onRecommendationScroll() {
    final state = context.read<RecommendationBloc>().state;
    if (state is RecommendationSuccess && state.hasReachedMax) {
    } else if (state is RecommendationSuccess) {
      if (recommendationController.position.pixels ==
          recommendationController.position.maxScrollExtent) {
        context.read<RecommendationBloc>().add(GetMyRecommendations(
            page: state.page + 1, recommendations: state.recommendations));
      }
    }
  }

  void _onSavedReviewScroll() {
    final state = context.read<SavedReviewsBloc>().state;
    if ((state is SavedReviewLoaded) &&
        (state.hasReachedMax || state.isLocalData)) {
      return;
    } else if (state is SavedReviewLoaded) {
      context.read<SavedReviewsBloc>().add(
            GetSavedReviewsEvent(
              page: state.page + 1,
            ),
          );
    }
  }

  // bool get _isReviewBottomReached {
  //   if (!reviewsController.hasClients) return false;
  //   return reviewsController.position.maxScrollExtent ==
  //       reviewsController.position.pixels;
  // }

  // bool get _isSavedBottomReached {
  //   if (!savedReviewsController.hasClients) return false;
  //   return savedReviewsController.position.maxScrollExtent ==
  //       savedReviewsController.position.pixels;
  // }

  void tabListener() {
    double newPos;
    if (_tabController.index == _tabController.length - 1) {
      newPos = _tabScrollController.position.maxScrollExtent;
    } else if (_tabController.index == 0) {
      newPos = 0;
    } else {
      newPos = _tabScrollController.position.maxScrollExtent *
          (_tabController.index) /
          _tabController.length;
    }
    _tabScrollController.animateTo(newPos,
        duration: const Duration(milliseconds: 100), curve: Curves.easeIn);
  }
}

String formatNumber(double number) {
  if (number >= 1000) {
    double roundedNumber = number / 1000;
    String formattedNumber = roundedNumber.toStringAsFixed(
        roundedNumber.truncateToDouble() == roundedNumber ? 0 : 1);
    return '${formattedNumber}k';
  } else {
    return number.toInt().toString();
  }
}

Column getSubProfileInfo({
  required String value,
  required String title,
  IconData? iconData,
}) {
  return Column(
    children: [
      Text(
        value,
        style: GoogleFonts.urbanist(
          fontWeight: FontWeight.w700,
          fontSize: 1.8.h,
        ),
      ),
      iconData == null
          ? Text(
              title,
              style: GoogleFonts.poppins(
                fontWeight: FontWeight.w400,
                fontSize: 1.8.h,
              ),
            )
          : Row(
              children: [
                Text(
                  title,
                  style: GoogleFonts.poppins(
                    fontWeight: FontWeight.w400,
                    fontSize: 1.8.h,
                  ),
                ),
                const SizedBox(
                  width: 3,
                ),
                Icon(
                  iconData,
                  size: 14,
                ),
              ],
            ),
    ],
  );
}
