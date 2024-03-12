import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:receive_sharing_intent/receive_sharing_intent.dart';

import '../../features/authentication/authentication.dart';
import '../../features/shared_media_review/presentation/bloc/share_media/share_media_bloc.dart';
import '../../features/shared_media_review/presentation/bloc/share_media/share_media_event.dart';
import '../../features/shared_media_review/presentation/widgets/review_type_popup.dart';

void listenShareMediaFiles(BuildContext context) {
  // while the app is in the memory
  ReceiveSharingIntent.instance.getMediaStream().listen((value) {
    if (value.isEmpty) return;
    if (context.mounted) {
      var shareMediaBloc = context.read<SharedMediaBloc>();
      var user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      if (user == null) {
        showCustomToast(
          context: context,
          toastMessage: "Please login first to share media.",
          toastType: ToastType.warning,
        );
        context.pushNamed(AppRoutes.login);
        return;
      }
      if (shareMediaBloc.state.sharedFiles == null ||
          shareMediaBloc.state.sharedFiles!.isEmpty) {
        shareMediaBloc.add(LoadSharedMedia(media: value));
        showDialog(
          context: context,
          builder: (context) => ReviewTypeDialogContent(
            mediaFiles: value,
          ),
        ).then((value) {
          shareMediaBloc.add(ClearSharedMedia());
        });
      } else {
        showCustomToast(
          context: context,
          toastMessage:
              "Please finish your current review before starting a new one.",
          toastType: ToastType.warning,
        );
      }
    }
  }, onError: (err) {
    if (context.mounted) {
      showCustomToast(
        context: context,
        toastMessage: "Error: $err",
        toastType: ToastType.error,
      );
    }
  });

  // For sharing images coming from outside the app while the app is closed
  ReceiveSharingIntent.instance.getInitialMedia().then(
      (List<SharedMediaFile> value) {
    if (value.isEmpty) return;
    if (context.mounted) {
      var shareMediaBloc = context.read<SharedMediaBloc>();
      var user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      if (user == null) {
        showCustomToast(
          context: context,
          toastMessage: "Please login first to share media.",
          toastType: ToastType.warning,
        );
        context.pushNamed(AppRoutes.login);
        return;
      }
      if (shareMediaBloc.state.sharedFiles == null ||
          shareMediaBloc.state.sharedFiles!.isEmpty) {
        shareMediaBloc.add(LoadSharedMedia(media: value));
        showDialog(
          context: context,
          builder: (context) => ReviewTypeDialogContent(
            mediaFiles: value,
          ),
        ).then((value) {
          shareMediaBloc.add(ClearSharedMedia());
        });
      } else {
        showCustomToast(
          context: context,
          toastMessage:
              "Please finish your current review before starting a new one.",
          toastType: ToastType.warning,
        );
      }
    }
  }, onError: (err) {
    if (context.mounted) {
      showCustomToast(
        context: context,
        toastMessage: "Error: $err",
        toastType: ToastType.error,
      );
    }
  });
}
