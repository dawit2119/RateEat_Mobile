import 'dart:async';
import 'dart:io';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:camerawesome/pigeon.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:go_router/go_router.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:iconsax/iconsax.dart';
import 'package:image_picker/image_picker.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:path/path.dart' as path;
import 'package:path_provider/path_provider.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/capture_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CaptureMediaPage extends StatefulWidget {
  const CaptureMediaPage({super.key});

  @override
  State<CaptureMediaPage> createState() => _CaptureMediaPageState();
}

Future<void> saveToGallery(XFile file, context, isImage) async {
  // Get the directory for the DCIM folder
  final Directory dcimDir = Directory('/storage/emulated/0/DCIM/RateEat');
  if (!await dcimDir.exists()) {
    try {
      await dcimDir.create(recursive: true);
    } catch (e) {
      // showCustomToast(
      //     context: context,
      //     toastMessage: AppLocalizations.of(context)!.faileToSaveMediaText,
      //     toastType: ToastType.error);
    }
  }
  try {
    final String fileName =
        '${isImage ? "image" : "video"}_${DateTime.now().millisecondsSinceEpoch}.${isImage ? "jpg" : "mp4"}';
    final String filePath = path.join(dcimDir.path, fileName);
    await File(file.path).copy(filePath);
  } catch (e) {
    //leave if not saved
  }
}

class _CaptureMediaPageState extends State<CaptureMediaPage> {
  @override
  void initState() {
    super.initState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Platform.isAndroid
        ? Builder(
            builder: (context) => Scaffold(
              key: const Key('capture_media_page'),
              body: Container(
                color: Colors.white,
                child: FutureBuilder<PermissionStatus>(
                  future: Permission.camera.status,
                  builder: (context, snapshot) {
                    if (snapshot.connectionState == ConnectionState.waiting) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (snapshot.data == PermissionStatus.granted) {
                      return CameraAwesomeBuilder.awesome(
                        onMediaCaptureEvent: (event) {
                          switch ((
                            event.status,
                            event.isPicture,
                            event.isVideo
                          )) {
                            case (MediaCaptureStatus.capturing, true, false):
                              debugPrint('Capturing picture...');
                            case (MediaCaptureStatus.success, true, false):
                              event.captureRequest.when(
                                single: (single) {
                                  if (single.file != null) {
                                    final files = context
                                        .read<SimpleReviewStepperBloc>()
                                        .state
                                        .simpleAddReviewStepperProps;

                                    final prevCapture = files.images ?? [];
                                    final newList = List.of(prevCapture)
                                      ..add(XFile(single.file!.path));
                                    // ignore: use_build_context_synchronously
                                    context.read<SimpleReviewStepperBloc>().add(
                                          SimpleReviewStepperUpdate(
                                            images: newList,
                                          ),
                                        );
                                    saveToGallery(single.file!, context, true);
                                  } else {}
                                  debugPrint(
                                      'Picture saved: ${single.file?.path}');
                                },
                                multiple: (multiple) {
                                  multiple.fileBySensor.forEach((key, value) {
                                    debugPrint(
                                        'multiple image taken: $key ${value?.path}');
                                  });
                                },
                              );
                            case (MediaCaptureStatus.failure, true, false):
                              debugPrint(
                                  'Failed to capture picture: ${event.exception}');
                            case (MediaCaptureStatus.capturing, false, true):
                              debugPrint('Capturing video...');
                            case (MediaCaptureStatus.success, false, true):
                              event.captureRequest.when(
                                single: (single) {
                                  debugPrint(
                                      'Video saved: ${single.file?.path}');
                                  if (single.file != null) {
                                    final files = context
                                        .read<SimpleReviewStepperBloc>()
                                        .state
                                        .simpleAddReviewStepperProps;

                                    final prevCapture = files.videos ?? [];
                                    final newList = List.of(prevCapture)
                                      ..add(XFile(single.file!.path));
                                    context.read<SimpleReviewStepperBloc>().add(
                                          SimpleReviewStepperUpdate(
                                            videos: newList,
                                          ),
                                        );
                                  }
                                  saveToGallery(single.file!, context, false);
                                },
                                multiple: (multiple) {
                                  multiple.fileBySensor.forEach((key, value) {
                                    debugPrint(
                                        'multiple video taken: $key ${value?.path}');
                                  });
                                },
                              );
                            case (MediaCaptureStatus.failure, false, true):
                              debugPrint(
                                  'Failed to capture video: ${event.exception}');
                            default:
                              debugPrint('Unknown event: $event');
                          }
                        },
                        progressIndicator: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              LoadingAnimationWidget.dotsTriangle(
                                  color: AppColors.primaryColor, size: 40),
                              verticalPadding(height: 2),
                              const Text("Loading Camera"),
                            ],
                          ),
                        ),
                        saveConfig: SaveConfig.photoAndVideo(
                          initialCaptureMode: CaptureMode.photo,
                          videoPathBuilder: (sensors) async {
                            final Directory extDir =
                                await getTemporaryDirectory();
                            final draftDir = await Directory(
                              '${extDir.path}/draftReviews',
                            ).create(recursive: true);
                            final String filePath =
                                '${draftDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

                            return SingleCaptureRequest(
                                filePath, sensors.first);
                          },
                          photoPathBuilder: (sensors) async {
                            final Directory extDir =
                                await getTemporaryDirectory();
                            final draftDir = await Directory(
                              '${extDir.path}/draftReviews',
                            ).create(recursive: true);

                            final String filePath =
                                '${draftDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

                            return SingleCaptureRequest(
                                filePath, sensors.first);
                          },
                          videoOptions: VideoOptions(
                            enableAudio: true,
                            ios: CupertinoVideoOptions(
                              fps: 20,
                            ),
                            android: AndroidVideoOptions(
                              bitrate: 6000000,
                              fallbackStrategy: QualityFallbackStrategy.lower,
                            ),
                          ),
                          exifPreferences:
                              ExifPreferences(saveGPSLocation: true),
                        ),
                        sensorConfig: SensorConfig.single(
                          sensor: Sensor.position(SensorPosition.back),
                          // flashMode: FlashMode.auto,
                          aspectRatio: CameraAspectRatios.ratio_4_3,
                          zoom: 0.0,
                        ),
                        enablePhysicalButton: true,
                        // filter: AwesomeFilter.AddictiveRed,
                        previewFit: CameraPreviewFit.contain,
                        availableFilters: awesomePresetFiltersList,
                        topActionsBuilder: (state) => AwesomeTopActions(
                          padding: const EdgeInsets.all(8.0),
                          state: state,
                          children: [
                            // Close button for Android
                            Padding(
                              padding: EdgeInsets.all(8.0),
                              child: GestureDetector(
                                onTap: () => context.pop(),
                                child: Container(
                                  width: 10.w,
                                  height: 10.h,
                                  decoration: BoxDecoration(
                                    color: Colors.black,
                                    borderRadius: BorderRadius.circular(5.w),
                                  ),
                                  child: Icon(
                                    Icons.close,
                                    color: Colors.white,
                                    size: 6.w,
                                  ),
                                ),
                              ),
                            ),
                            const Spacer(),
                            AwesomeCameraSwitchButton(
                              state: state,
                              scale: 1.0,
                              onSwitchTap: (state) {
                                state.switchCameraSensor(
                                  aspectRatio: state.sensorConfig.aspectRatio,
                                );
                              },
                            ),
                            const Spacer(),
                            AwesomeFlashButton(
                              state: state,
                            ),
                          ],
                        ),
                        bottomActionsBuilder: (state) => AwesomeBottomActions(
                          state: state,
                          captureButton: CaptureButton(state: state),
                          right: GestureDetector(
                            onTap: () async {
                              context.pushNamed(AppRoutes.quickAddGallery);
                            },
                            child: Column(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                BlocBuilder<SimpleReviewStepperBloc,
                                    SimpleReviewStepperState>(
                                  builder: (context, state) {
                                    final imageData = state
                                            .simpleAddReviewStepperProps
                                            .images ??
                                        [];
                                    if (imageData.isEmpty) {
                                      return Container(
                                        decoration: BoxDecoration(
                                          shape: BoxShape.circle,
                                          color: Colors.white.withOpacity(0.1),
                                        ),
                                        child: Padding(
                                          padding: EdgeInsets.all(16),
                                          child: Icon(Iconsax.image,
                                              color: Colors.white,
                                              size: 20
                                                  .sp), // make responsive the icon size
                                        ),
                                      );
                                    }
                                    return Container(
                                      decoration: BoxDecoration(
                                        shape: BoxShape.circle,
                                        color: Colors.white.withOpacity(0.2),
                                      ),
                                      child: SizedBox(
                                        height: 50,
                                        width: 50,
                                        child: ClipRRect(
                                          borderRadius:
                                              BorderRadius.circular(50),
                                          child: Image.file(
                                            File(imageData.last.path),
                                            fit: BoxFit.cover,
                                          ),
                                        ),
                                      ),
                                    );
                                  },
                                ),
                                verticalPadding(height: 1),
                                Text(
                                  AppLocalizations.of(context)!.previewText,
                                  style: GoogleFonts.poppins(
                                    fontSize:
                                        15.sp, // making responsive font size
                                    color: Colors.white,
                                  ),
                                ),
                              ],
                            ),
                          ),
                          left: Column(
                            children: [
                              Container(
                                decoration: BoxDecoration(
                                  shape: BoxShape.circle,
                                  color: Colors.white.withOpacity(0.1),
                                ),
                                child: Padding(
                                  padding: EdgeInsets.all(1.w),
                                  child: IconButton(
                                    icon: Icon(
                                      Iconsax.gallery,
                                      size: 20.sp, // responsive size
                                    ),
                                    onPressed: () async {
                                      await pickMultipleMedia();
                                      // ignore: use_build_context_synchronously
                                      if (context
                                                  .read<
                                                      SimpleReviewStepperBloc>()
                                                  .state
                                                  .simpleAddReviewStepperProps
                                                  .images !=
                                              null &&
                                          // ignore: use_build_context_synchronously
                                          context
                                              .read<SimpleReviewStepperBloc>()
                                              .state
                                              .simpleAddReviewStepperProps
                                              .images!
                                              .isNotEmpty) {
                                        // ignore: use_build_context_synchronously
                                        context.pushNamed(
                                            AppRoutes.quickAddGallery);
                                      }
                                    },
                                    tooltip: AppLocalizations.of(context)!
                                        .galleryText,
                                    color: Colors.white,
                                  ),
                                ),
                              ),
                              verticalPadding(height: 1),
                              Text(
                                AppLocalizations.of(context)!.galleryText,
                                style: GoogleFonts.poppins(
                                  fontSize: 15.0.sp,
                                  color: Colors.white,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    } else {
                      // Permission denied - show message with close button
                      return Scaffold(
                        backgroundColor: Colors.black,
                        appBar: AppBar(
                          backgroundColor: Colors.transparent,
                          elevation: 0,
                          leading: IconButton(
                            icon: Icon(Icons.close,
                                color: Colors.white, size: 6.w),
                            onPressed: () => context.pop(),
                          ),
                        ),
                        body: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.camera_alt_outlined,
                                color: Colors.white,
                                size: 20.sp,
                              ),
                              const SizedBox(height: 16),
                              Text(
                                'Camera Permission Required',
                                style: GoogleFonts.inter(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.w600,
                                ),
                              ),
                              const SizedBox(height: 8),
                              Text(
                                'Please grant camera permission to capture photos and videos',
                                style: GoogleFonts.inter(
                                  color: Colors.white70,
                                  fontSize: 15.sp,
                                ),
                                textAlign: TextAlign.center,
                              ),
                              const SizedBox(height: 24),
                              ElevatedButton(
                                onPressed: () async {
                                  await Permission.camera.request();
                                  // Rebuild the widget to check permission again
                                  if (mounted) {
                                    setState(() {});
                                  }
                                },
                                child: const Text('Grant Permission'),
                              ),
                            ],
                          ),
                        ),
                      );
                    }
                  },
                ),
              ),
            ),
          )
        : Scaffold(
            body: Container(
              key: const Key('capture_media_page'),
              color: Colors.white,
              child: CameraAwesomeBuilder.awesome(
                onMediaCaptureEvent: (event) {
                  switch ((event.status, event.isPicture, event.isVideo)) {
                    case (MediaCaptureStatus.capturing, true, false):
                      debugPrint('Capturing picture...');
                    case (MediaCaptureStatus.success, true, false):
                      event.captureRequest.when(
                        single: (single) {
                          if (single.file != null) {
                            final files = context
                                .read<SimpleReviewStepperBloc>()
                                .state
                                .simpleAddReviewStepperProps;

                            final prevCapture = files.images ?? [];
                            final newList = List.of(prevCapture)
                              ..add(XFile(single.file!.path));
                            // ignore: use_build_context_synchronously
                            context.read<SimpleReviewStepperBloc>().add(
                                  SimpleReviewStepperUpdate(
                                    images: newList,
                                  ),
                                );
                            saveToGallery(single.file!, context, true);
                          } else {}
                          debugPrint('Picture saved: ${single.file?.path}');
                        },
                        multiple: (multiple) {
                          multiple.fileBySensor.forEach((key, value) {
                            debugPrint(
                                'multiple image taken: $key ${value?.path}');
                          });
                        },
                      );
                    case (MediaCaptureStatus.failure, true, false):
                      debugPrint(
                          'Failed to capture picture: ${event.exception}');
                    case (MediaCaptureStatus.capturing, false, true):
                      debugPrint('Capturing video...');
                    case (MediaCaptureStatus.success, false, true):
                      event.captureRequest.when(
                        single: (single) {
                          debugPrint('Video saved: ${single.file?.path}');
                          if (single.file != null) {
                            final files = context
                                .read<SimpleReviewStepperBloc>()
                                .state
                                .simpleAddReviewStepperProps;

                            final prevCapture = files.videos ?? [];
                            final newList = List.of(prevCapture)
                              ..add(XFile(single.file!.path));
                            context.read<SimpleReviewStepperBloc>().add(
                                  SimpleReviewStepperUpdate(
                                    videos: newList,
                                  ),
                                );
                          }
                          saveToGallery(single.file!, context, false);
                        },
                        multiple: (multiple) {
                          multiple.fileBySensor.forEach((key, value) {
                            debugPrint(
                                'multiple video taken: $key ${value?.path}');
                          });
                        },
                      );
                    case (MediaCaptureStatus.failure, false, true):
                      debugPrint('Failed to capture video: ${event.exception}');
                    default:
                      debugPrint('Unknown event: $event');
                  }
                },
                progressIndicator: Center(
                  child: LoadingAnimationWidget.dotsTriangle(
                      color: AppColors.primaryColor, size: 40),
                ),
                saveConfig: SaveConfig.photoAndVideo(
                  initialCaptureMode: CaptureMode.photo,
                  videoPathBuilder: (sensors) async {
                    final Directory extDir = await getTemporaryDirectory();
                    final draftDir = await Directory(
                      '${extDir.path}/draftReviews',
                    ).create(recursive: true);
                    final String filePath =
                        '${draftDir.path}/${DateTime.now().millisecondsSinceEpoch}.mp4';

                    //* Add Video To list
                    // ignore: use_build_context_synchronously
                    final files = context
                        .read<SimpleReviewStepperBloc>()
                        .state
                        .simpleAddReviewStepperProps;

                    final prevCapture = files.videos ?? [];
                    final newList = List.of(prevCapture)..add(XFile(filePath));
                    // ignore: use_build_context_synchronously
                    context.read<SimpleReviewStepperBloc>().add(
                          SimpleReviewStepperUpdate(
                            videos: newList,
                          ),
                        );

                    return SingleCaptureRequest(filePath, sensors.first);
                  },
                  photoPathBuilder: (sensors) async {
                    final Directory extDir = await getTemporaryDirectory();
                    final draftDir = await Directory(
                      '${extDir.path}/draftReviews',
                    ).create(recursive: true);

                    final String filePath =
                        '${draftDir.path}/${DateTime.now().millisecondsSinceEpoch}.jpg';

                    //* Add Image To list
                    // ignore: use_build_context_synchronously

                    return SingleCaptureRequest(filePath, sensors.first);
                  },
                  videoOptions: VideoOptions(
                    enableAudio: true,
                    ios: CupertinoVideoOptions(
                      fps: 10,
                    ),
                    android: AndroidVideoOptions(
                      bitrate: 6000000,
                      fallbackStrategy: QualityFallbackStrategy.lower,
                    ),
                  ),
                  exifPreferences: ExifPreferences(saveGPSLocation: true),
                ),
                sensorConfig: SensorConfig.single(
                  sensor: Sensor.position(SensorPosition.back),
                  // flashMode: FlashMode.auto,
                  aspectRatio: CameraAspectRatios.ratio_4_3,
                  zoom: 0.0,
                ),
                enablePhysicalButton: true,
                // filter: AwesomeFilter.AddictiveRed,
                previewFit: CameraPreviewFit.contain,
                // onMediaTap: (mediaCapture) {
                //   mediaCapture.captureRequest.when(
                //     single: (single) {
                //       context.pushNamed(AppRoutes.quickAddGallery);
                //     },
                //   );
                // },
                availableFilters: awesomePresetFiltersList,
                topActionsBuilder: (state) => AwesomeTopActions(
                  padding: const EdgeInsets.all(8.0),
                  state: state,
                  children: [
                    // Close button for iphone
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: GestureDetector(
                        onTap: () => context.pop(),
                        child: Container(
                          width: 10.w,
                          height: 10.h,
                          decoration: BoxDecoration(
                            color: Colors.black,
                            borderRadius: BorderRadius.circular(5.w),
                          ),
                          child: Icon(
                            Icons.close,
                            color: Colors.white,
                            size: 6.w,
                          ),
                        ),
                      ),
                    ),
                    const Spacer(),
                    AwesomeCameraSwitchButton(
                      state: state,
                      scale: 1.0,
                      onSwitchTap: (state) {
                        state.switchCameraSensor(
                          aspectRatio: state.sensorConfig.aspectRatio,
                        );
                      },
                    ),
                    const Spacer(),
                    AwesomeFlashButton(
                      state: state,
                    ),
                  ],
                ),
                bottomActionsBuilder: (state) => AwesomeBottomActions(
                  state: state,
                  captureButton: CaptureButton(state: state),
                  onMediaTap: (mediaCapture) {
                    mediaCapture.captureRequest.when(
                      single: (single) {
                        context.pushNamed(AppRoutes.quickAddGallery);
                      },
                    );
                  },
                  right: Column(
                    children: [
                      Container(
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: Colors.white.withOpacity(0.2),
                          ),
                          child: IconButton(
                            icon: const Icon(Icons.preview_outlined),
                            onPressed: () async {
                              context.pushNamed(AppRoutes.quickAddGallery);
                            },
                            tooltip: AppLocalizations.of(context)!.previewText,
                            color: Colors.white,
                          )),
                      const SizedBox(height: 8.0),
                      Text(
                        AppLocalizations.of(context)!.previewText,
                        style: GoogleFonts.poppins(
                          fontSize: 15.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                  left: Column(
                    children: [
                      Container(
                        decoration: BoxDecoration(
                          shape: BoxShape.circle,
                          color: Colors.white.withOpacity(0.2),
                        ),
                        child: IconButton(
                          icon: const Icon(Icons.photo_album_outlined),
                          onPressed: () async {
                            await pickMultipleMedia();
                            // ignore: use_build_context_synchronously
                            // if (context
                            //             .read<SimpleReviewStepperBloc>()
                            //             .state
                            //             .simpleAddReviewStepperProps
                            //             .images !=
                            //         null &&
                            //     // ignore: use_build_context_synchronously
                            //     context
                            //         .read<SimpleReviewStepperBloc>()
                            //         .state
                            //         .simpleAddReviewStepperProps
                            //         .images!
                            //         .isNotEmpty) {
                            //   // ignore: use_build_context_synchronously
                            //   context.pushNamed(AppRoutes.quickAddGallery);
                            // }
                          },
                          tooltip: AppLocalizations.of(context)!.galleryText,
                          color: Colors.white,
                        ),
                      ),
                      const SizedBox(height: 8.0),
                      Text(
                        AppLocalizations.of(context)!.galleryText,
                        style: GoogleFonts.poppins(
                          fontSize: 15.0.sp,
                          color: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          );
  }

  final picker = ImagePicker();

  //* Function to get list of files
  Future<void> pickMultipleMedia() async {
    List<XFile> selectedImages = [];
    List<XFile> selectedVideos = [];
    final pickedFiles = await picker.pickMultipleMedia(
      imageQuality: 20,
    );

    setState(() {
      if (pickedFiles.isNotEmpty) {
        for (var pickedFile in pickedFiles) {
          // Check file extension using regular expression
          final isImage = RegExp(r'\.(jpeg|jpg|png|gif)$', caseSensitive: false)
              .hasMatch(pickedFile.path);
          final isVideo = RegExp(r'\.(mp4|mov|avi)$', caseSensitive: false)
              .hasMatch(pickedFile.path);

          // Get file size in bytes
          final file = File(pickedFile.path);
          final fileSize = file.lengthSync();

          if (isImage && fileSize <= 5 * 1024 * 1024) {
            selectedImages.add(XFile(pickedFile.path));
          } else if (isVideo && fileSize <= 8 * 1024 * 1024) {
            selectedVideos.add(XFile(pickedFile.path));
          } else {
            // String fileName = file.path.split('/').last;
            String fileType = '';
            String fileSizeStr = '';

            // Check if the file is unsupported
            if (!isImage && !isVideo) {
              fileType = 'Unsupported';
              fileSizeStr = 'N/A';
              showCustomToast(
                context: context,
                toastMessage: '$fileType file',
                toastType: ToastType.error,
              );
            } else {
              fileType = isImage ? 'Image' : 'Video';
              fileSizeStr = isImage ? '5MB' : '8MB';
              showCustomToast(
                context: context,
                toastMessage:
                    '${AppLocalizations.of(context)!.sizeExceedsText} $fileSizeStr.',
                toastType: ToastType.error,
              );
            }
          }
          context.read<SimpleReviewStepperBloc>().add(
                SimpleReviewStepperUpdate(
                  images: selectedImages,
                  videos: selectedVideos,
                ),
              );
          context.pushNamed(AppRoutes.quickAddGallery);
        }
      } else {
        showCustomToast(
          context: context,
          toastMessage: AppLocalizations.of(context)!.nothingSelectedText,
          toastType: ToastType.error,
        );
      }
    });
  }
}
