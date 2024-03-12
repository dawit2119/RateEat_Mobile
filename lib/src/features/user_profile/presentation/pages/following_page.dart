import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/pages/custom_tab_bar.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/widgets/shimmer/following_user_items_shimmer.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FollowingPage extends StatefulWidget {
  final String userId;
  final String name;
  const FollowingPage({super.key, required this.userId, required this.name});

  @override
  State<FollowingPage> createState() => _FollowingPageState();
}

class _FollowingPageState extends State<FollowingPage>
    with TickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _followingScrollController;
  late ScrollController _followerScrollController;
  late TextEditingController _followingQueryController;
  late TextEditingController _followerQueryController;

  @override
  void initState() {
    super.initState();

    _followingScrollController = ScrollController();
    _followerScrollController = ScrollController();
    _followingScrollController.addListener(_onFollowingScroll);
    _followerScrollController.addListener(_onFollowerScroll);
    _followerQueryController = TextEditingController(text: "");
    _followingQueryController = TextEditingController(text: "");
    _followerQueryController.addListener(_onFollowerQuery);
    _followingQueryController.addListener(_onFollowingQuery);
    _tabController = TabController(length: 2, vsync: this);
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();

    final String? tab = GoRouterState.of(context).uri.queryParameters['tab'];

    _tabController.index = (tab == 'followers') ? 1 : 0;

    context.read<FollowingListBloc>().add(GetFollowingList(
        userId: widget.userId, page: 1, followings: [], query: ""));

    context.read<FollowerListBloc>().add(GetFollowerList(
        userId: widget.userId, page: 1, followers: [], query: ""));
  }

  @override
  void dispose() {
    _followingScrollController
      ..removeListener(_onFollowingScroll)
      ..dispose();
    _followerScrollController
      ..removeListener(_onFollowerScroll)
      ..dispose();
    _followerQueryController
      ..removeListener(_onFollowerQuery)
      ..dispose();
    _followingQueryController
      ..removeListener(_onFollowingQuery)
      ..dispose();

    super.dispose();
  }

  void _onFollowerQuery() {
    context.read<FollowerListBloc>().add(GetFollowerList(
        followers: [],
        userId: widget.userId,
        page: 1,
        query: _followerQueryController.text));
  }

  void _onFollowingQuery() {
    context.read<FollowingListBloc>().add(GetFollowingList(
        followings: [],
        userId: widget.userId,
        page: 1,
        query: _followingQueryController.text));
  }

  void _onFollowingScroll() {
    if (_followingScrollController.position.maxScrollExtent ==
        _followingScrollController.position.pixels) {
      final state = context.read<FollowingListBloc>().state;
      if ((state is FollowingListSuccess ||
              state is FollowUnFollowSuccess ||
              state is FollowUnFollowFailed) &&
          !state.hasReachedMax) {
        context.read<FollowingListBloc>().add(GetFollowingList(
            followings: state.followings!,
            userId: widget.userId,
            page: state.page + 1,
            query: _followingQueryController.text));
      }
    }
  }

  void _onFollowerScroll() {
    if (_followerScrollController.position.maxScrollExtent ==
        _followerScrollController.position.pixels) {
      final state = context.read<FollowerListBloc>().state;
      if (state is FollowerListSuccess && !state.hasReachedMax) {
        context.read<FollowerListBloc>().add(GetFollowerList(
            followers: state.followers,
            userId: widget.userId,
            page: state.page + 1,
            query: _followerQueryController.text));
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(onTap: context.pop, title: widget.name),
      body: Column(
        children: [
          BlocListener<FollowingListBloc, FollowingListState>(
            listenWhen: (prevState, state) {
              return (state is FollowUnFollowSuccess ||
                  state is FollowUnFollowFailed);
            },
            listener: (context, state) {
              if (state is FollowUnFollowSuccess) {
                context.read<FollowerListBloc>().add(UpdateFollowStatus(
                    userId: state.userId, followStatus: state.newFollowStatus));
              } else if (state is FollowUnFollowFailed) {
                showCustomToast(
                    context: context,
                    toastType: ToastType.error,
                    toastMessage: AppLocalizations.of(context)!.followFailed);
              }
            },
            child: const SizedBox(),
          ),
          CustomTabBar(
            tabBar: TabBar(
              unselectedLabelColor: AppColors.grey300,
              controller: _tabController,
              labelStyle: GoogleFonts.poppins(
                fontSize: 14,
                color: Colors.black,
                fontWeight: FontWeight.w500,
              ),
              indicatorPadding: EdgeInsets.symmetric(
                vertical: 0.4.h,
              ),
              dividerColor: Colors.transparent,
              indicatorSize: TabBarIndicatorSize.tab,
              indicator: BoxDecoration(
                color: Colors.white,
                boxShadow: elevation_2,
                borderRadius: BorderRadius.circular(18),
              ),
              physics: const BouncingScrollPhysics(
                  parent: FixedExtentScrollPhysics()),
              tabs: [
                Text(
                  AppLocalizations.of(context)!.followingText,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
                Text(
                  AppLocalizations.of(context)!.followersText,
                  style: GoogleFonts.poppins(
                    fontSize: 14,
                    fontWeight: FontWeight.w400,
                  ),
                ),
              ],
            ),
            height: 7.h,
          ),
          SizedBox(
            height: 2.h,
          ),
          Expanded(
            child: TabBarView(
              controller: _tabController,
              children: [
                //followers tab
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: TextField(
                        controller: _followerQueryController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.grey200, // Grey background
                          hintText: AppLocalizations.of(context)!
                              .searchText, // Hint text
                          hintStyle: TextStyle(
                              color: Colors.grey[600]), // Hint text color
                          prefixIcon: const Icon(
                              Icons.search), // Search icon on the left
                          border: InputBorder.none, // No border
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.6.h, horizontal: 2.w), // Padding
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // Rounded border
                            borderSide: BorderSide.none, // No border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // Rounded border
                            borderSide: BorderSide.none, // No border
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    SizedBox(
                      height: 72.h - MediaQuery.of(context).viewInsets.bottom,
                      child: BlocBuilder<FollowerListBloc, FollowerListState>(
                        builder: (context, state) {
                          if (state is FollowerListSuccess) {
                            if (state.followers.isEmpty) {
                              return Center(
                                child: ErrorAndInfoDisplayWidget(
                                  assetImage: "assets/icons/no_content.svg",
                                  title:
                                      AppLocalizations.of(context)!.noFollowers,
                                  description: AppLocalizations.of(context)!
                                      .followersAppearHereText,
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              controller: _followerScrollController,
                              child: Column(
                                  children: List.generate(
                                      state.followers.length, (index) {
                                return FollowingUserCard(
                                  user: state.followers[index],
                                  key: ValueKey(state.followers[index].id +
                                      state.followers[index].isFollowed
                                          .toString()),
                                );
                              }).toList()),
                            );
                          } else if (state is FollowerListLoading) {
                            return const SingleChildScrollView(
                              child:
                                  FollowingUserItemsShimmer(shimmerCount: 10),
                            );
                          } else if (state is FollowerListNextLoading) {
                            return SingleChildScrollView(
                              controller: _followerScrollController,
                              child: Column(
                                children: [
                                  ...List.generate(
                                    state.followers.length,
                                    (index) {
                                      return FollowingUserCard(
                                          user: state.followers[index],
                                          key: ValueKey(state
                                                  .followers[index].id +
                                              state.followers[index].isFollowed
                                                  .toString()));
                                    },
                                  ),
                                  const FollowingUserItemsShimmer(
                                      shimmerCount: 1)
                                ],
                              ),
                            );
                          } else {
                            return ErrorAndInfoDisplayWidget(
                              assetImage: "assets/icons/no_internet.svg",
                              title: AppLocalizations.of(context)!
                                  .unableToGetFollowers,
                              description: AppLocalizations.of(context)!
                                  .errorWhileLoadingFollowers,
                              onPressed: () {
                                context.read<FollowerListBloc>().add(
                                    GetFollowerList(
                                        followers: [],
                                        userId: widget.userId,
                                        page: 1,
                                        query: _followingQueryController.text));
                              },
                              buttonText:
                                  AppLocalizations.of(context)!.retryText,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),

                // following tab
                Column(
                  children: [
                    Padding(
                      padding: EdgeInsets.symmetric(horizontal: 5.w),
                      child: TextField(
                        controller: _followingQueryController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: AppColors.grey200, // Grey background
                          hintText: AppLocalizations.of(context)!
                              .searchText, // Hint text
                          hintStyle: TextStyle(
                              color: Colors.grey[600]), // Hint text color
                          prefixIcon: const Icon(
                              Icons.search), // Search icon on the left
                          border: InputBorder.none, // No border
                          contentPadding: EdgeInsets.symmetric(
                              vertical: 0.6.h, horizontal: 2.w), // Padding
                          enabledBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // Rounded border
                            borderSide: BorderSide.none, // No border
                          ),
                          focusedBorder: OutlineInputBorder(
                            borderRadius:
                                BorderRadius.circular(30.0), // Rounded border
                            borderSide: BorderSide.none, // No border
                          ),
                        ),
                      ),
                    ),
                    SizedBox(
                      height: 1.h,
                    ),
                    SizedBox(
                      height: 72.h - MediaQuery.of(context).viewInsets.bottom,
                      child: BlocBuilder<FollowingListBloc, FollowingListState>(
                        builder: (context, state) {
                          if (state is FollowingListSuccess ||
                              state is FollowUnFollowFailed ||
                              state is FollowUnFollowSuccess) {
                            if (state.followings!.isEmpty) {
                              return Center(
                                child: ErrorAndInfoDisplayWidget(
                                  assetImage: "assets/icons/no_content.svg",
                                  title: AppLocalizations.of(context)!
                                      .noFollowings,
                                  description: AppLocalizations.of(context)!
                                      .followingAppearHereText,
                                ),
                              );
                            }
                            return SingleChildScrollView(
                              controller: _followingScrollController,
                              child: Column(
                                  children: List.generate(
                                      state.followings!.length, (index) {
                                return FollowingUserCard(
                                  user: state.followings![index],
                                  key: ValueKey(state.followings![index].id +
                                      state.followings![index].isFollowed
                                          .toString()),
                                );
                              }).toList()),
                            );
                          } else if (state is FollowingListLoading) {
                            return const SingleChildScrollView(
                              child:
                                  FollowingUserItemsShimmer(shimmerCount: 10),
                            );
                          } else if (state is FollowingListNextLoading) {
                            return SingleChildScrollView(
                              controller: _followingScrollController,
                              child: Column(
                                children: [
                                  ...List.generate(
                                    state.followings!.length,
                                    (index) {
                                      return FollowingUserCard(
                                          user: state.followings![index],
                                          key: ValueKey(
                                              state.followings![index].id +
                                                  state.followings![index]
                                                      .isFollowed
                                                      .toString()));
                                    },
                                  ),
                                  const FollowingUserItemsShimmer(
                                      shimmerCount: 1)
                                ],
                              ),
                            );
                          } else {
                            return ErrorAndInfoDisplayWidget(
                              assetImage: "assets/icons/no_internet.svg",
                              title: AppLocalizations.of(context)!
                                  .unableToGetFollowings,
                              description: AppLocalizations.of(context)!
                                  .errorWhileLoadingFollowings,
                              onPressed: () {
                                context.read<FollowingListBloc>().add(
                                    GetFollowingList(
                                        followings: [],
                                        userId: widget.userId,
                                        page: 1,
                                        query: _followingQueryController.text));
                              },
                              buttonText:
                                  AppLocalizations.of(context)!.retryText,
                            );
                          }
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
