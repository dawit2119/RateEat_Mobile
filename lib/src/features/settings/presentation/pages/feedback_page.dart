import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/loading_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/give_feedback/give_feedback_bloc.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/give_feedback/give_feedback_event.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/give_feedback/give_feedback_state.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/widgets/feedback_field.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class FeedbackPage extends StatefulWidget {
  const FeedbackPage({super.key});

  @override
  State<FeedbackPage> createState() => _FeedbackPageState();
}

class _FeedbackPageState extends State<FeedbackPage> {
  final TextEditingController comment = TextEditingController();
  @override
  void dispose() {
    comment.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: CustomAppBar(
            onTap: () {
              context.pop();
            },
            title: AppLocalizations.of(context)!.giveFeedbackText),
        body: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Column(
            children: [
              const SizedBox(
                height: 20,
              ),
              FeedbackField(
                title: AppLocalizations.of(context)!.expText,
                textEditingController: comment,
              ),
              const SizedBox(
                height: 15,
              ),
              BlocListener<FeedbackBloc, FeedbackState>(
                listener: (context, state) {
                  if (state is FeedbackSuccess) {
                    showCustomToast(
                      context: context,
                      toastMessage: state.message,
                      toastType: ToastType.success,
                    );

                    setState(() {
                      comment.clear();
                    });
                    context.pop();
                  } else if (state is FeedbackFailure) {
                    showCustomToast(
                      context: context,
                      toastMessage: state.error,
                      toastType: ToastType.error,
                    );
                  } else {}
                },
                child: Padding(
                  padding: EdgeInsets.symmetric(vertical: 1.5.h),
                  child: BlocBuilder<FeedbackBloc, FeedbackState>(
                    builder: (context, state) {
                      if (state is FeedbackLoading) {
                        return LoadingButton(
                          title: AppLocalizations.of(context)!.submittingText,
                          color: AppColors.primaryButtonColor,
                          onClick: () {},
                          loadingState: true,
                        );
                      } else {
                        return SubmitButton(
                          title: AppLocalizations.of(context)!.submitText,
                          color: AppColors.primaryButtonColor,
                          onClick: () {
                            context.read<FeedbackBloc>().add(
                                SubmitFeedbackEvent(comment: comment.text));
                          },
                        );
                      }
                    },
                  ),
                ),
              ),
            ],
          ),
        ));
  }
}
