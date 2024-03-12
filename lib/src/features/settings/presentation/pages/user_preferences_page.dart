import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class UserPreferencesPage extends StatefulWidget {
  const UserPreferencesPage({super.key});

  @override
  State<StatefulWidget> createState() {
    return UserPreferencesPageState();
  }
}

class UserPreferencesPageState extends State<UserPreferencesPage> {
  late final TextEditingController walkingDistanceController;
  late final TextEditingController minNumberOfReviewsController;

  @override
  void initState() {
    super.initState();
    walkingDistanceController = TextEditingController();
    minNumberOfReviewsController = TextEditingController();
    context.read<UserPreferenceBloc>().add(GetPreviousPreference());
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: CustomAppBar(
        onTap: () {
          context.pop();
        },
        title: AppLocalizations.of(context)!.preferenceText,
      ),
      body: Padding(
        padding: EdgeInsets.symmetric(
          vertical: 1.h,
          horizontal: 2.h,
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            SizedBox(
              height: 1.h,
            ),
            Text(
              "Preferred walking distance (meters)",
              maxLines: 1,
              style: TextStyle(
                  fontSize: 18.sp,
                  fontWeight: FontWeight.w400,
                  color: AppColors.grey600),
            ),
            SizedBox(
              height: 1.h,
            ),
            TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: true),
              controller: walkingDistanceController,
              decoration: InputDecoration(
                hintText: "Ex: 500",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.h),
                  borderSide: const BorderSide(
                    width: 0.001,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 3.h,
            ),
            Text(
              "Preferred Minimum number of reviews",
              maxLines: 1,
              style: TextStyle(
                fontSize: 18.sp,
                fontWeight: FontWeight.w400,
                color: AppColors.grey600,
              ),
            ),
            SizedBox(
              height: 1.h,
            ),
            TextField(
              keyboardType:
                  const TextInputType.numberWithOptions(decimal: false),
              controller: minNumberOfReviewsController,
              decoration: InputDecoration(
                hintText: "Ex: 10",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(1.h),
                  borderSide: const BorderSide(
                    width: 0.01,
                    color: AppColors.primaryColor,
                  ),
                ),
              ),
            ),
            Expanded(
                child: BlocListener<UserPreferenceBloc, UserPreferenceState>(
                    listener: (context, state) async {
                      if (state is UserPreferenceUpdateSuccess) {
                        showCustomToast(
                            context: context,
                            toastMessage: "preference updated successfully",
                            toastType: ToastType.success);
                        await Future.delayed(const Duration(milliseconds: 500));
                        if (context.mounted) {
                          context.pop();
                        }
                      } else if (state is PreviousPreferencesFetched) {
                        if (walkingDistanceController.text.isEmpty) {
                          walkingDistanceController.text = state
                                  .userPreference.walkingDistance
                                  ?.toString() ??
                              "";
                        }
                        if (minNumberOfReviewsController.text.isEmpty) {
                          minNumberOfReviewsController.text = state
                                  .userPreference.minNumberOfReviews
                                  ?.toString() ??
                              "";
                        }
                        setState(() {});
                      } else if (state is PreviousPreferencesFetchFailed) {
                        showCustomToast(
                            context: context,
                            toastMessage:
                                "failed to fetch previous preferences",
                            toastType: ToastType.error);
                      }
                    },
                    child: Container())),
            Align(
              alignment: AlignmentDirectional.center,
              child: GestureDetector(
                onTap: () {
                  if (context.read<UserPreferenceBloc>().state
                      is! UserPreferenceUpdateLoading) {
                    final distance =
                        int.tryParse(walkingDistanceController.text);
                    final numberOfReviews =
                        int.tryParse(minNumberOfReviewsController.text);
                    if (distance == null ||
                        numberOfReviews == null ||
                        distance < 0 ||
                        numberOfReviews < 0) {
                      showCustomToast(
                          context: context,
                          toastType: ToastType.error,
                          toastMessage: "only use numeric values");
                    } else {
                      context.read<UserPreferenceBloc>().add(
                          UpdateUserPreference(
                              preferredWalkingDistance: distance,
                              preferredDrivingDistance: null,
                              minNumberOfReviews: numberOfReviews));
                    }
                  }
                },
                child: Container(
                  height: 8.h,
                  width: 90.w,
                  decoration: BoxDecoration(
                      color: AppColors.primaryColor,
                      borderRadius: BorderRadius.circular(2.h)),
                  child: Center(
                    child: BlocBuilder<UserPreferenceBloc, UserPreferenceState>(
                        builder: (context, state) {
                      if (state is UserPreferenceUpdateLoading) {
                        return LoadingAnimationWidget.dotsTriangle(
                          key: const Key("Loading Animation Widget"),
                          color: Colors.white,
                          size: 18.sp,
                        );
                      } else if (state is UserPreferenceUpdateFailed) {
                        return Text(
                          AppLocalizations.of(context)!.retryText,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp),
                        );
                      } else {
                        return Text(
                          AppLocalizations.of(context)!.updateText,
                          style: TextStyle(
                              color: Colors.white,
                              fontWeight: FontWeight.w600,
                              fontSize: 16.sp),
                        );
                      }
                    }),
                  ),
                ),
              ),
            )
          ],
        ),
      ),
    );
  }
}
