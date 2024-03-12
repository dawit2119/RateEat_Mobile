import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/leadermodel.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/monthly_leader_board_response_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/rank.dart';
import 'package:rateeat_mobile/src/features/leaderboard/data/model/weekly_leader_response_model.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/leadear_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/leaderboard_event.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/leaderboard_state.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/monthly_leader_board/monthly_leader_board_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_event.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/user_rank_bloc/user_rank_state.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/bloc/weekly_leader_board/weekly_leader_board_bloc.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/widgets/leader_card.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/widgets/leader_cards_shimmer.dart';
import 'package:rateeat_mobile/src/features/leaderboard/presentation/widgets/leader_widget.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class LeaderBoard extends StatefulWidget {
  // final Rank? rank;
  const LeaderBoard({
    super.key,
  });

  @override
  State<LeaderBoard> createState() => _LeaderBoardState();
}

class _LeaderBoardState extends State<LeaderBoard>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late ScrollController _weeklyStandingController;
  late ScrollController _monthlyStandingController;
  late ScrollController _leaderBoardScrollController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
    _leaderBoardScrollController = ScrollController();
    _weeklyStandingController = ScrollController();
    _monthlyStandingController = ScrollController();
    _weeklyStandingController.addListener(_onWeeklyLeaderBoardScroll);
    _monthlyStandingController.addListener(_onMonthlyLeaderBoardScroll);
    _leaderBoardScrollController.addListener(_onAllTimeLeaderBoardScroll);

    //* Fetch Weekly Stats
    context.read<WeeklyLeaderBoardPageCubit>().changePage(1);
    context.read<MonthlyLeaderBoardPageCubit>().changePage(1);
    context.read<AllTimeLeaderBoardPageCubit>().changePage(1);
    context.read<WeeklyLeaderBoardBloc>().add(GetWeeklyLeaderBoardEvent());
    context.read<MonthlyLeaderBoardBloc>().add(GetMonthlyLeaderBoardEvent());
    context.read<LeaderBoardBloc>().add(GetLeaderBoardEvent());
    context.read<RankBloc>().add(GetUserRank());
  }

  @override
  void dispose() {
    super.dispose();
    _weeklyStandingController
      ..removeListener(_onWeeklyLeaderBoardScroll)
      ..dispose();
    _monthlyStandingController
      ..removeListener(_onMonthlyLeaderBoardScroll)
      ..dispose();
    _leaderBoardScrollController
      ..removeListener(_onAllTimeLeaderBoardScroll)
      ..dispose();
  }

  @override
  Widget build(BuildContext context) {
    // final screenHeight = SizeConfig.screenHeight;
    // final screenWidth = SizeConfig.screenWidth;

    return Scaffold(
      appBar: AppBar(
        elevation: 0,
        scrolledUnderElevation: 0,
        title: Padding(
          padding: EdgeInsets.only(top: 1.h),
          child: Text(
            AppLocalizations.of(context)!.leadText,
            style: GoogleFonts.poppins(
              fontSize: 18,
              fontWeight: FontWeight.w500,
            ),
          ),
        ),
        centerTitle: true,
        toolbarHeight: 7.h,
        automaticallyImplyLeading: false,
        flexibleSpace: Padding(
          padding: EdgeInsets.only(top: 2.h, left: 4.w),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.start,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Container(
                height: 10.h,
                width: 10.w,
                decoration: BoxDecoration(
                    color: Colors.white,
                    boxShadow: [...elevation_4],
                    borderRadius: BorderRadius.circular(10)),
                child: InkWell(
                  borderRadius: BorderRadius.circular(10),
                  onTap: () {
                    context.pop();
                  },
                  child: const Center(
                    child: Icon(
                      Icons.arrow_back,
                      color: Colors.black,
                      size: 20,
                      semanticLabel: "Back",
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
      body: BlocBuilder<RankBloc, RankState>(
        builder: (context, rankState) {
          if (rankState is RankInitial) {
            return Container(color: Colors.blue);
          } else if (rankState is RankSuccess) {
            return Padding(
              padding: EdgeInsets.only(top: 5.h, left: 2.w, right: 2.w),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  //******************************** Tabs for the leader board
                  Center(
                    child: Container(
                      padding: EdgeInsets.symmetric(horizontal: 0.6.h),
                      height: 7.h,
                      width: 85.w,
                      decoration: BoxDecoration(
                        color: AppColors.grey200,
                        borderRadius: BorderRadius.circular(18),
                      ),
                      child: TabBar(
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
                            AppLocalizations.of(context)!.weeklyText,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.monthlyText,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                          Text(
                            AppLocalizations.of(context)!.allTimeText,
                            style: GoogleFonts.poppins(
                              fontSize: 14,
                              fontWeight: FontWeight.w400,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                  //******************************** Leader board
                  Expanded(
                    child: TabBarView(
                      controller: _tabController,
                      children: [
                        _buildWeeklyLeaderBoardTab(context, rankState.rank),
                        _buildMonthlyLeaderBoardTab(context, rankState.rank),
                        _buildAllTimeLeaderBoardTab(2.h, 2.w, rankState.rank),
                      ],
                    ),
                  ),
                ],
              ),
            );
          } else if (rankState is RankLoading) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  height: 0,
                  width: 100.w,
                ),
                LoadingAnimationWidget.dotsTriangle(
                  color: AppColors.primaryColor,
                  size: 10.h,
                ),
                const Text("Loading ranks")
              ],
            );
          } else if (rankState is RankError) {
            return Column(
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                SizedBox(
                  width: 100.w,
                ),
                const Text('Failed to load ranks'),
                SizedBox(
                  height: 1.5.h,
                ),
                GestureDetector(
                  onTap: () {
                    context.read<RankBloc>().add(GetUserRank());
                  },
                  child: Container(
                    width: 30.w,
                    height: 5.5.h,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(7),
                      color: AppColors.primaryButtonColor,
                    ),
                    child: const Center(
                      child: Text(
                        "retry",
                        style: TextStyle(
                          color: Colors.white,
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            );
          }
          return Column(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              SizedBox(
                width: 100.w,
              ),
              const Text('Unknown error'),
              SizedBox(
                height: 1.5.h,
              ),
              GestureDetector(
                onTap: () {
                  context.read<RankBloc>().add(GetUserRank());
                },
                child: Container(
                  width: 30.w,
                  height: 5.5.h,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(7),
                    color: AppColors.primaryButtonColor,
                  ),
                  child: const Center(
                    child: Text(
                      "retry",
                      style: TextStyle(
                        color: Colors.white,
                      ),
                    ),
                  ),
                ),
              ),
            ],
          );
        },
      ),
    );
  }

  Widget _buildAllTimeLeaderBoardTab(
      double screenHeight, double screenWidth, Rank rank) {
    return BlocBuilder<LeaderBoardBloc, LeaderBoardState>(
        builder: ((context, standingState) {
      if (standingState is LeaderBoardLoading) {
        return const SingleChildScrollView(
            child: ShimmerListDisplay(count: 10));
      } else if (standingState is LeaderBoardFetchSuccess) {
        if (standingState.status == false) {
          var previousPage = context.read<AllTimeLeaderBoardPageCubit>().state;
          context
              .read<AllTimeLeaderBoardPageCubit>()
              .changePage(previousPage - 1);
        }
        var standings = standingState.leads;
        if (standings.isEmpty) {
          return const ErrorAndInfoDisplayWidget(
            assetImage: "assets/icons/no_content.svg",
            title: "LeaderBoard is Empty",
            description: "The LoaderBoard is Empty For Now",
            onPressed: null,
          );
        }
        var leads = standingState.leads;

        LeaderBoardModel first = leads[0];
        LeaderBoardModel second = leads[1];
        LeaderBoardModel third = leads[2];
        return SingleChildScrollView(
          controller: _leaderBoardScrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              verticalPadding(height: 3),
              //* Top Three
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LeaderWidget(
                    onTap: () {
                      context.pushNamed(
                        AppRoutes.othersProfilePage,
                        pathParameters: {"userId": second.user.id},
                      );
                    },
                    imageUrl: second.user.image.toString(),
                    rank: 2.toString(),
                    name: "${second.user.firstName} ${second.user.lastName}",
                    points:
                        (second.allTimeTotal + second.currentTotal).toString(),
                    borderColor: AppColors.grey400,
                  ),
                  LeaderWidget(
                    onTap: () {
                      context.pushNamed(
                        AppRoutes.othersProfilePage,
                        pathParameters: {"userId": first.user.id},
                      );
                    },
                    isLeader: true,
                    imageUrl: first.user.image.toString(),
                    rank: 1.toString(),
                    name: "${first.user.firstName} ${first.user.lastName}",
                    points:
                        (first.allTimeTotal + first.currentTotal).toString(),
                    borderColor: AppColors.leaderBorderColor,
                  ),
                  LeaderWidget(
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.othersProfilePage,
                          pathParameters: {"userId": third.user.id},
                        );
                      },
                      imageUrl: third.user.image.toString(),
                      rank: 3.toString(),
                      name: "${third.user.firstName} ${third.user.lastName}",
                      points:
                          (third.allTimeTotal + third.currentTotal).toString(),
                      borderColor: AppColors.thirdBorderColor),
                ],
              ),
              verticalPadding(height: 4),

              //* list of rankings
              LeaderCard(
                backgroundColor: AppColors.currentUserLeaderCardColor,
                textColor: Colors.white,
                name: "${rank.user.firstName} ${rank.user.lastName}",
                points: (rank.allTimeTotal + rank.currentTotal).toString(),
                rank: rank.rank.toString(),
                imageUrl: rank.user.image.toString(),
              ),
              ...List.generate(
                standings.length,
                (index) {
                  final name =
                      "${leads[index].user.firstName} ${leads[index].user.lastName}";
                  return LeaderCard(
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.othersProfilePage,
                          pathParameters: {"userId": leads[index].user.id},
                        );
                      },
                      name: name,
                      points: (leads[index].currentTotal +
                              leads[index].allTimeTotal)
                          .toString(),
                      rank: (index + 1).toString(),
                      imageUrl: leads[index].user.image.toString());
                },
              ),
              if (standingState.hasReachedMax)
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Center(
                    child: Text(
                      "${AppLocalizations.of(context)!.thatsAllText} :(",
                      style: GoogleFonts.poppins(
                        color: Colors.grey,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
            ],
          ),
        );
      } else if (standingState is LeaderBoardNextFetchLoading) {
        final List<LeaderBoardModel> leads = standingState.leads;
        LeaderBoardModel first = leads[0];
        LeaderBoardModel second = leads[1];
        LeaderBoardModel third = leads[2];
        return SingleChildScrollView(
          controller: _leaderBoardScrollController,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  LeaderWidget(
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.othersProfilePage,
                          pathParameters: {"userId": second.user.id},
                        );
                      },
                      imageUrl: second.user.image.toString(),
                      rank: 2.toString(),
                      name: "${second.user.firstName} ${second.user.lastName}",
                      points: (second.allTimeTotal + second.currentTotal)
                          .toString(),
                      borderColor: AppColors.grey400),
                  LeaderWidget(
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.othersProfilePage,
                          pathParameters: {"userId": first.user.id},
                        );
                      },
                      isLeader: true,
                      imageUrl: first.user.image.toString(),
                      rank: 1.toString(),
                      name: "${first.user.firstName} ${first.user.lastName}",
                      points:
                          (first.allTimeTotal + first.currentTotal).toString(),
                      borderColor: AppColors.leaderBorderColor),
                  LeaderWidget(
                    onTap: () {
                      context.pushNamed(
                        AppRoutes.othersProfilePage,
                        pathParameters: {"userId": third.user.id},
                      );
                    },
                    imageUrl: third.user.image.toString(),
                    rank: 3.toString(),
                    name: "${third.user.firstName} ${third.user.lastName}",
                    points:
                        (third.allTimeTotal + third.currentTotal).toString(),
                    borderColor: AppColors.thirdBorderColor,
                  ),
                ],
              ),
              verticalPadding(height: 4),
              //*  Current Profile
              LeaderCard(
                  backgroundColor: AppColors.currentUserLeaderCardColor,
                  textColor: Colors.white,
                  name: "${rank.user.firstName} ${rank.user.lastName}",
                  points: (rank.allTimeTotal + rank.currentTotal).toString(),
                  rank: rank.rank.toString(),
                  imageUrl: rank.user.image.toString()),
              ...List.generate(
                leads.length,
                (index) {
                  final name =
                      "${leads[index].user.firstName} ${leads[index].user.lastName}";
                  return LeaderCard(
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.othersProfilePage,
                          pathParameters: {"userId": leads[index].user.id},
                        );
                      },
                      name: name,
                      points: (leads[index].currentTotal +
                              leads[index].allTimeTotal)
                          .toString(),
                      rank: (index + 1).toString(),
                      imageUrl: leads[index].user.image.toString());
                },
              ),
              //* Loading more ranks
              const ShimmerListDisplay(count: 1),
            ],
          ),
        );
      } else if (standingState is LeaderBoardError) {
        return Container(
          key: const Key("error widget"),
          child: ErrorAndInfoDisplayWidget(
            assetImage: "assets/icons/no_internet_1.svg",
            title: AppLocalizations.of(context)!.unknownErrorText,
            description: AppLocalizations.of(context)!.tryAgainText,
            onPressed: () {
              context.read<LeaderBoardBloc>().add(
                    GetLeaderBoardEvent(),
                  );
            },
          ),
        );
      } else {
        return Container();
      }
    }));
  }

  Widget _buildWeeklyLeaderBoardTab(context, Rank rank) {
    return BlocBuilder<WeeklyLeaderBoardBloc, WeeklyLeaderBoardState>(
      builder: (context, standingsState) {
        if (standingsState is WeeklyLeaderBoardLoaded) {
          if (standingsState.status == false) {
            var previousPage = context.read<WeeklyLeaderBoardPageCubit>().state;
            context
                .read<WeeklyLeaderBoardPageCubit>()
                .changePage(previousPage - 1);
          }
          var standings = standingsState.standings.users;
          if (standings.isEmpty) {
            return const ErrorAndInfoDisplayWidget(
              assetImage: "assets/icons/no_content.svg",
              title: "LeaderBoard is Empty",
              description: "The LoaderBoard is Empty For Now",
              onPressed: null,
            );
          }
          final List<WeeklyLeaderBoardResponse> leads = standings;
          WeeklyLeaderBoardResponse first = leads[0];
          WeeklyLeaderBoardResponse second = leads[1];
          WeeklyLeaderBoardResponse third = leads[2];
          return SingleChildScrollView(
            controller: _weeklyStandingController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                verticalPadding(height: 3),
                //* Top Three
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LeaderWidget(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": second.user.id},
                          );
                        },
                        imageUrl: second.user.image.toString(),
                        rank: 2.toString(),
                        name:
                            "${second.user.firstName} ${second.user.lastName}",
                        points: (second.totalPoints).toString(),
                        borderColor: AppColors.grey400),
                    LeaderWidget(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": first.user.id},
                          );
                        },
                        isLeader: true,
                        imageUrl: first.user.image.toString(),
                        rank: 1.toString(),
                        name: "${first.user.firstName} ${first.user.lastName}",
                        points: (first.totalPoints).toString(),
                        borderColor: AppColors.leaderBorderColor),
                    LeaderWidget(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": third.user.id},
                          );
                        },
                        imageUrl: third.user.image.toString(),
                        rank: 3.toString(),
                        name: "${third.user.firstName} ${third.user.lastName}",
                        points: (third.totalPoints).toString(),
                        borderColor: AppColors.thirdBorderColor),
                  ],
                ),
                verticalPadding(height: 4),
                //*  Current Profile
                if (standingsState.standings.rank != 0)
                  LeaderCard(
                    backgroundColor: AppColors.currentUserLeaderCardColor,
                    textColor: Colors.white,
                    name: "${rank.user.firstName} ${rank.user.lastName}",
                    points: ("").toString(),
                    rank: (standingsState.standings.rank).toString(),
                    imageUrl: rank.user.image.toString(),
                  ),
                //* List of Rankings
                ...List.generate(
                  standings.length,
                  (index) {
                    final name =
                        "${leads[index].user.firstName} ${leads[index].user.lastName}";
                    return LeaderCard(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": leads[index].user.id},
                          );
                        },
                        name: name,
                        points: (leads[index].totalPoints).toString(),
                        rank: (index + 1).toString(),
                        imageUrl: leads[index].user.image.toString());
                  },
                ),
                if (standingsState.hasReachedMax)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "${AppLocalizations.of(context)!.thatsAllText} :(",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        } else if (standingsState is WeeklyLeaderBoardNextLoading) {
          var standings = standingsState.standings.users;
          final List<WeeklyLeaderBoardResponse> leads = standings;
          WeeklyLeaderBoardResponse first = leads[0];
          WeeklyLeaderBoardResponse second = leads[1];
          WeeklyLeaderBoardResponse third = leads[2];
          return SingleChildScrollView(
            controller: _weeklyStandingController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* Top Three
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LeaderWidget(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": second.user.id},
                          );
                        },
                        imageUrl: second.user.image.toString(),
                        rank: 2.toString(),
                        name:
                            "${second.user.firstName} ${second.user.lastName}",
                        points: (second.totalPoints).toString(),
                        borderColor: AppColors.grey400),
                    LeaderWidget(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": first.user.id},
                          );
                        },
                        isLeader: true,
                        imageUrl: first.user.image.toString(),
                        rank: 1.toString(),
                        name: "${first.user.firstName} ${first.user.lastName}",
                        points: (first.totalPoints).toString(),
                        borderColor: AppColors.leaderBorderColor),
                    LeaderWidget(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": third.user.id},
                          );
                        },
                        imageUrl: third.user.image.toString(),
                        rank: 3.toString(),
                        name: "${third.user.firstName} ${third.user.lastName}",
                        points: (third.totalPoints).toString(),
                        borderColor: AppColors.thirdBorderColor),
                  ],
                ),
                verticalPadding(height: 4),
                //*  Current Profile
                if (standingsState.standings.rank != 0)
                  LeaderCard(
                      backgroundColor: AppColors.currentUserLeaderCardColor,
                      textColor: Colors.white,
                      name: "${rank.user.firstName} ${rank.user.lastName}",
                      points: ("").toString(),
                      rank: (standingsState.standings.rank).toString(),
                      imageUrl: rank.user.image.toString()),
                //* List of Rankings
                ...List.generate(standings.length, (index) {
                  final name =
                      "${leads[index].user.firstName} ${leads[index].user.lastName}";
                  return LeaderCard(
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.othersProfilePage,
                          pathParameters: {"userId": leads[index].user.id},
                        );
                      },
                      name: name,
                      points: (leads[index].totalPoints).toString(),
                      rank: (index + 1).toString(),
                      imageUrl: leads[index].user.image.toString());
                }),
                //* Loading more ranks
                const ShimmerListDisplay(count: 1),
              ],
            ),
          );
        } else if (standingsState is WeeklyLeaderBoardLoading) {
          return const SingleChildScrollView(
              child: ShimmerListDisplay(count: 10));
        } else if (standingsState is WeeklyLeaderBoardFailure) {
          return ErrorAndInfoDisplayWidget(
            assetImage: "assets/icons/no_internet_1.svg",
            title: AppLocalizations.of(context)!.unknownErrorText,
            description: AppLocalizations.of(context)!.tryAgainText,
            onPressed: () {
              context.read<WeeklyLeaderBoardBloc>().add(
                    GetWeeklyLeaderBoardEvent(),
                  );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  Widget _buildMonthlyLeaderBoardTab(context, Rank rank) {
    return BlocBuilder<MonthlyLeaderBoardBloc, MonthlyLeaderBoardState>(
      builder: (context, standingsState) {
        if (standingsState is MonthlyLeaderBoardLoaded) {
          if (standingsState.status == false) {
            var previousPage =
                context.read<MonthlyLeaderBoardPageCubit>().state;
            context
                .read<MonthlyLeaderBoardPageCubit>()
                .changePage(previousPage - 1);
          }
          var standings = standingsState.standings.users;
          if (standings.isEmpty) {
            return const ErrorAndInfoDisplayWidget(
              assetImage: "assets/icons/no_content.svg",
              title: "LeaderBoard is Empty",
              description: "The LoaderBoard is Empty For Now",
              onPressed: null,
            );
          }
          final List<MonthlyLeaderBoardResponse> leads = standings;
          MonthlyLeaderBoardResponse first = leads[0];
          MonthlyLeaderBoardResponse second = leads[1];
          MonthlyLeaderBoardResponse third = leads[2];
          return SingleChildScrollView(
            controller: _monthlyStandingController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 15),
                //* Top Three
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LeaderWidget(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": second.user.id},
                          );
                        },
                        imageUrl: second.user.image.toString(),
                        rank: 2.toString(),
                        name:
                            "${second.user.firstName} ${second.user.lastName}",
                        points: (second.totalPoints).toString(),
                        borderColor: AppColors.grey400),
                    LeaderWidget(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": first.user.id},
                          );
                        },
                        isLeader: true,
                        imageUrl: first.user.image.toString(),
                        rank: 1.toString(),
                        name: "${first.user.firstName} ${first.user.lastName}",
                        points: (first.totalPoints).toString(),
                        borderColor: AppColors.leaderBorderColor),
                    LeaderWidget(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": third.user.id},
                          );
                        },
                        imageUrl: third.user.image.toString(),
                        rank: 3.toString(),
                        name: "${third.user.firstName} ${third.user.lastName}",
                        points: (third.totalPoints).toString(),
                        borderColor: AppColors.thirdBorderColor),
                  ],
                ),
                verticalPadding(height: 4),
                //*  Current Profile
                if (standingsState.standings.rank != 0)
                  LeaderCard(
                    backgroundColor: AppColors.currentUserLeaderCardColor,
                    textColor: Colors.white,
                    name: "${rank.user.firstName} ${rank.user.lastName}",
                    points: ("").toString(),
                    rank: (standingsState.standings.rank).toString(),
                    imageUrl: rank.user.image.toString(),
                  ),
                //* List of Rankings
                ...List.generate(
                  standings.length,
                  (index) {
                    final name =
                        "${leads[index].user.firstName} ${leads[index].user.lastName}";
                    return LeaderCard(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": leads[index].user.id},
                          );
                        },
                        name: name,
                        points: (leads[index].totalPoints).toString(),
                        rank: (index + 1).toString(),
                        imageUrl: leads[index].user.image.toString());
                  },
                ),
                if (standingsState.hasReachedMax)
                  Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Center(
                      child: Text(
                        "${AppLocalizations.of(context)!.thatsAllText} :(",
                        style: GoogleFonts.poppins(
                          color: Colors.grey,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          );
        } else if (standingsState is MonthlyLeaderBoardNextLoading) {
          var standings = standingsState.standings.users;
          final List<MonthlyLeaderBoardResponse> leads = standings;
          MonthlyLeaderBoardResponse first = leads[0];
          MonthlyLeaderBoardResponse second = leads[1];
          MonthlyLeaderBoardResponse third = leads[2];
          return SingleChildScrollView(
            controller: _monthlyStandingController,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                //* Top Three
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                  children: [
                    LeaderWidget(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": second.user.id},
                          );
                        },
                        imageUrl: second.user.image.toString(),
                        rank: 2.toString(),
                        name:
                            "${second.user.firstName} ${second.user.lastName}",
                        points: (second.totalPoints).toString(),
                        borderColor: AppColors.grey400),
                    LeaderWidget(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": first.user.id},
                          );
                        },
                        isLeader: true,
                        imageUrl: first.user.image.toString(),
                        rank: 1.toString(),
                        name: "${first.user.firstName} ${first.user.lastName}",
                        points: (first.totalPoints).toString(),
                        borderColor: AppColors.leaderBorderColor),
                    LeaderWidget(
                        onTap: () {
                          context.pushNamed(
                            AppRoutes.othersProfilePage,
                            pathParameters: {"userId": third.user.id},
                          );
                        },
                        imageUrl: third.user.image.toString(),
                        rank: 3.toString(),
                        name: "${third.user.firstName} ${third.user.lastName}",
                        points: (third.totalPoints).toString(),
                        borderColor: AppColors.thirdBorderColor),
                  ],
                ),
                verticalPadding(height: 4),
                //*  Current Profile
                if (standingsState.standings.rank != 0)
                  LeaderCard(
                      backgroundColor: AppColors.currentUserLeaderCardColor,
                      textColor: Colors.white,
                      name: "${rank.user.firstName} ${rank.user.lastName}",
                      points: ("").toString(),
                      rank: (standingsState.standings.rank).toString(),
                      imageUrl: rank.user.image.toString()),
                //* List of Rankings
                ...List.generate(standings.length, (index) {
                  final name =
                      "${leads[index].user.firstName} ${leads[index].user.lastName}";
                  return LeaderCard(
                      onTap: () {
                        context.pushNamed(
                          AppRoutes.othersProfilePage,
                          pathParameters: {"userId": leads[index].user.id},
                        );
                      },
                      name: name,
                      points: (leads[index].totalPoints).toString(),
                      rank: (index + 1).toString(),
                      imageUrl: leads[index].user.image.toString());
                }),
                //* Loading more ranks
                const ShimmerListDisplay(count: 1),
              ],
            ),
          );
        } else if (standingsState is MonthlyLeaderBoardLoading) {
          return const SingleChildScrollView(
              child: ShimmerListDisplay(count: 10));
        } else if (standingsState is MonthlyLeaderBoardFailure) {
          return ErrorAndInfoDisplayWidget(
            assetImage: "assets/icons/no_internet_1.svg",
            title: AppLocalizations.of(context)!.unknownErrorText,
            description: AppLocalizations.of(context)!.tryAgainText,
            onPressed: () {
              context.read<MonthlyLeaderBoardBloc>().add(
                    GetMonthlyLeaderBoardEvent(),
                  );
            },
          );
        } else {
          return Container();
        }
      },
    );
  }

  void _onWeeklyLeaderBoardScroll() {
    final state = context.read<WeeklyLeaderBoardBloc>().state;
    if ((state is WeeklyLeaderBoardLoaded) &&
        state.hasReachedMax &&
        _isWeeklyLeaderBottomReached) {
      return;
    }
    if (state is WeeklyLeaderBoardLoaded &&
        !state.hasReachedMax &&
        _isWeeklyLeaderBottomReached) {
      var previousPage = context.read<WeeklyLeaderBoardPageCubit>().state;
      context.read<WeeklyLeaderBoardPageCubit>().changePage(previousPage + 1);

      context.read<WeeklyLeaderBoardBloc>().add(
            GetWeeklyLeaderBoardEvent(page: previousPage + 1),
          );
    }
  }

  void _onMonthlyLeaderBoardScroll() {
    final state = context.read<MonthlyLeaderBoardBloc>().state;
    if ((state is MonthlyLeaderBoardLoaded) &&
        state.hasReachedMax &&
        _isMonthlyLeaderBottomReached) {
      return;
    }
    if (state is MonthlyLeaderBoardLoaded &&
        !state.hasReachedMax &&
        _isMonthlyLeaderBottomReached) {
      var previousPage = context.read<MonthlyLeaderBoardPageCubit>().state;
      context.read<MonthlyLeaderBoardPageCubit>().changePage(previousPage + 1);
      context.read<MonthlyLeaderBoardBloc>().add(
            GetMonthlyLeaderBoardEvent(page: previousPage + 1),
          );
    }
  }

  void _onAllTimeLeaderBoardScroll() {
    final leaderBoardState = context.read<LeaderBoardBloc>().state;
    if (leaderBoardState is LeaderBoardFetchSuccess &&
        _isAllTimeLeaderBottomReached &&
        leaderBoardState.hasReachedMax) {
      return;
    }
    if (leaderBoardState is LeaderBoardFetchSuccess &&
        _isAllTimeLeaderBottomReached &&
        !leaderBoardState.hasReachedMax) {
      var previousPage = context.read<AllTimeLeaderBoardPageCubit>().state;
      context.read<AllTimeLeaderBoardPageCubit>().changePage(previousPage + 1);

      context.read<LeaderBoardBloc>().add(
            GetLeaderBoardEvent(page: previousPage + 1),
          );
    }
  }

  bool get _isWeeklyLeaderBottomReached {
    if (!_weeklyStandingController.hasClients) return false;
    return _weeklyStandingController.position.maxScrollExtent ==
        _weeklyStandingController.position.pixels;
  }

  bool get _isMonthlyLeaderBottomReached {
    if (!_monthlyStandingController.hasClients) return false;
    return _monthlyStandingController.position.maxScrollExtent ==
        _monthlyStandingController.position.pixels;
  }

  bool get _isAllTimeLeaderBottomReached {
    if (!_leaderBoardScrollController.hasClients) return false;
    return _leaderBoardScrollController.position.maxScrollExtent ==
        _leaderBoardScrollController.position.pixels;
  }
}

class WeeklyLeaderBoardPageCubit extends Cubit<int> {
  WeeklyLeaderBoardPageCubit() : super(1);
  void changePage(page) => emit(page);
}

class MonthlyLeaderBoardPageCubit extends Cubit<int> {
  MonthlyLeaderBoardPageCubit() : super(1);
  void changePage(page) => emit(page);
}

class AllTimeLeaderBoardPageCubit extends Cubit<int> {
  AllTimeLeaderBoardPageCubit() : super(1);
  void changePage(page) => emit(page);
}
