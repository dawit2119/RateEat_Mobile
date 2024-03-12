import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/features/review/data/models/flag_review_model.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/flag_review/flag_review_bloc.dart';

import '../../../../core/core.dart';
import '../../../features.dart';

class FlagReview extends StatefulWidget {
  final String reviewId;
  const FlagReview({
    super.key,
    required this.reviewId,
  });
  @override
  State<FlagReview> createState() => _FlagReviewState();
}

class _FlagReviewState extends State<FlagReview> {
  final otherReasonController = TextEditingController();

  final formKey = GlobalKey<FormState>();

  @override
  Widget build(BuildContext context) {
    final screenHeight = MediaQuery.of(context).size.height;
    final screenWidth = MediaQuery.of(context).size.width;
    final reportTypes = [
      AppLocalizations.of(context)!.hateAndHarassmentText,
      AppLocalizations.of(context)!.nudityAndSexualContentText,
      AppLocalizations.of(context)!.shockingAndGraphicContentText,
      AppLocalizations.of(context)!.misInformationText,
      AppLocalizations.of(context)!.deceptiveBehaviorAndSpamText,
      AppLocalizations.of(context)!.fraudsAndScamsText,
      AppLocalizations.of(context)!.sharingPersonalInformationText,
      AppLocalizations.of(context)!.counterFeitsAndIntellectualPropertyText,
      AppLocalizations.of(context)!.otherText,
    ];
    return BlocProvider(
      create: (context) => ReportTypeCubit(),
      child: BlocBuilder<ReportTypeCubit, String>(
        builder: (context, reportType) {
          return Form(
            key: formKey,
            child: Container(
              height: screenHeight * .7,
              padding: MediaQuery.of(context).viewInsets,
              width: screenWidth,
              child: Container(
                padding: const EdgeInsets.all(
                  20,
                ),
                child: SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          reportType == ""
                              ? Container()
                              : IconButton(
                                  onPressed: () {
                                    context
                                        .read<ReportTypeCubit>()
                                        .changeReportType(
                                          "",
                                        );
                                  },
                                  icon: const Icon(
                                    Icons.arrow_back,
                                  ),
                                ),
                          Text(
                            reportType == ""
                                ? AppLocalizations.of(context)!.selectReasonText
                                : AppLocalizations.of(context)!.reportText,
                            style: GoogleFonts.poppins(
                              fontSize: screenHeight * 0.02,
                              fontWeight: FontWeight.bold,
                              color: const Color(0xFF586069),
                            ),
                          ),
                          InkWell(
                            child: const Icon(Icons.cancel_rounded),
                            onTap: () {
                              Navigator.pop(context);
                            },
                          ),
                        ],
                      ),
                      const Divider(),
                      if (reportType != "")
                        SizedBox(
                          height: screenHeight * .5,
                          child: Column(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisAlignment:
                                      MainAxisAlignment.spaceBetween,
                                  children: [
                                    Text(
                                      reportType,
                                      style: GoogleFonts.poppins(
                                        fontSize: screenHeight * 0.02,
                                        fontWeight: FontWeight.w600,
                                      ),
                                    ),
                                    const SizedBox(
                                      height: 20,
                                    ),
                                    if (reportType ==
                                        AppLocalizations.of(context)!.otherText)
                                      TextFormField(
                                        controller: otherReasonController,
                                        autovalidateMode:
                                            AutovalidateMode.onUserInteraction,
                                        validator: (value) {
                                          if (value == null || value.isEmpty) {
                                            return AppLocalizations.of(context)!
                                                .requiredText;
                                          } else if (value.length < 3) {
                                            return AppLocalizations.of(context)!
                                                .requiredWarningText;
                                          }
                                          return null;
                                        },
                                        maxLines: 3,
                                        decoration: InputDecoration(
                                          contentPadding:
                                              const EdgeInsets.symmetric(
                                            vertical: 5,
                                            horizontal: 8,
                                          ),
                                          hintText:
                                              AppLocalizations.of(context)!
                                                  .yourReasonText,
                                          border: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: BorderSide.none,
                                          ),
                                          focusedBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                                color: Colors.blue),
                                          ),
                                          errorBorder: OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red),
                                          ),
                                          focusedErrorBorder:
                                              OutlineInputBorder(
                                            borderRadius:
                                                BorderRadius.circular(5.0),
                                            borderSide: const BorderSide(
                                                color: Colors.red),
                                          ),
                                          filled: true,
                                          fillColor: Colors.white,
                                        ),
                                      ),
                                  ],
                                ),
                                SizedBox(
                                  width: double.infinity,
                                  height: screenHeight * 0.064,
                                  child: ElevatedButton(
                                    onPressed: () {
                                      final currentState = formKey.currentState;
                                      if (currentState!.validate()) {
                                        final user = dpLocator<
                                                AuthenticationLocalSource>()
                                            .getUserCredential();
                                        var review = FlagReviewModel(
                                          reportType: reportType,
                                          text: otherReasonController.text,
                                          reviewId: widget.reviewId,
                                          userId: user!.id!,
                                        );
                                        context.read<FlagReviewBloc>().add(
                                              Flag(
                                                review: review,
                                              ),
                                            );
                                      }
                                    },
                                    style: ElevatedButton.styleFrom(
                                      foregroundColor:
                                          Colors.white, // Text color
                                      backgroundColor:
                                          AppColors.primaryColor, // Text color
                                      shape: RoundedRectangleBorder(
                                        borderRadius:
                                            BorderRadius.circular(12.0),
                                      ),
                                    ),
                                    child: BlocConsumer<FlagReviewBloc,
                                        FlagReviewState>(
                                      listener: (_, state) {
                                        if (state is FlagReviewSuccess) {
                                          showCustomToast(
                                            context: context,
                                            toastMessage:
                                                AppLocalizations.of(context)!
                                                    .reviewAcceptanceText,
                                            toastType: ToastType.success,
                                          );
                                          context.pop();
                                        } else if (state is FlagReviewFailed) {
                                          showCustomToast(
                                            context: context,
                                            toastMessage:
                                                AppLocalizations.of(context)!
                                                    .reportFailureText,
                                            toastType: ToastType.error,
                                          );
                                          context.pop();
                                        }
                                      },
                                      builder: (_, state) {
                                        if (state is FlagReviewLoading) {
                                          return LoadingAnimationWidget
                                              .dotsTriangle(
                                            color: Colors.white,
                                            size: screenHeight * 0.04,
                                          );
                                        }
                                        return Text(
                                          AppLocalizations.of(context)!
                                              .submitText,
                                          style: TextStyle(
                                              color: Colors.white,
                                              fontSize: screenHeight *
                                                  0.02 // Text color
                                              ),
                                        );
                                      },
                                    ),
                                    // ?
                                  ),
                                ),
                              ]),
                        )
                      else
                        Column(
                          children: List.generate(
                            reportTypes.length,
                            (index) => ListTile(
                              onTap: () {
                                context
                                    .read<ReportTypeCubit>()
                                    .changeReportType(
                                      reportTypes[index],
                                    );
                              },
                              title: Text(
                                reportTypes[index],
                                style: GoogleFonts.poppins(
                                  fontSize: screenHeight * 0.018,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              trailing: const Icon(
                                Icons.chevron_right,
                              ),
                            ),
                          ),
                        ),
                    ],
                  ),
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class ReportTypeCubit extends Cubit<String> {
  ReportTypeCubit() : super("");
  void changeReportType(reportType) => emit(reportType);
}
