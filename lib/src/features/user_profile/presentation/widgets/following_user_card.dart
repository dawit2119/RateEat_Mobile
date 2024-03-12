import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/constants/constants.dart';
import 'package:rateeat_mobile/src/core/routes/app_routes.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/following_list/following_list.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FollowingUserCard extends StatelessWidget {
  final FollowUser user;
  const FollowingUserCard({super.key, required this.user});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: EdgeInsets.symmetric(
        vertical: 1.5.h,
        horizontal: 2.h,
      ),
      child: GestureDetector(
        onTap: () {
          context.pushNamed(AppRoutes.othersProfilePage,
              pathParameters: {"userId": user.id});
        },
        child: Row(
          children: [
            user.imageUrl != ""
                ? Container(
                    height: 7.5.h,
                    width: 7.5.h,
                    decoration: BoxDecoration(
                      color: AppColors.grey300,
                      shape: BoxShape.circle,
                      image: DecorationImage(
                        image: NetworkImage(user.imageUrl),
                        fit: BoxFit.cover,
                      ),
                    ),
                  )
                : Container(
                    height: 7.5.h,
                    width: 7.5.h,
                    decoration: const BoxDecoration(
                      color: AppColors.grey200,
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      Icons.person_rounded,
                      size: 4.h,
                    ),
                  ),
            SizedBox(
              width: 2.w,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text("${user.firstName} ${user.lastName}"),
                Text(user.username)
              ],
            ),
            Expanded(child: Container()),
            user.isFollowed != null
                ? GestureDetector(
                    onTap: () {
                      if (!user.isFollowed!) {
                        context
                            .read<FollowingListBloc>()
                            .add(FollowUserFromList(userId: user.id));
                      } else {
                        context
                            .read<FollowingListBloc>()
                            .add(UnfollowUserFromList(userId: user.id));
                      }
                    },
                    child: Container(
                      height: 4.h,
                      width: 20.w,
                      decoration: BoxDecoration(
                          color: AppColors.followButtonBackgroundColor,
                          borderRadius: BorderRadius.circular(1.h)),
                      child: Center(
                        child: Text(
                          user.isFollowed!
                              ? AppLocalizations.of(context)!.followingText
                              : AppLocalizations.of(context)!.follow,
                          style:
                              TextStyle(color: Colors.white, fontSize: 15.sp),
                        ),
                      ),
                    ),
                  )
                : const SizedBox(),
          ],
        ),
      ),
    );
  }
}
