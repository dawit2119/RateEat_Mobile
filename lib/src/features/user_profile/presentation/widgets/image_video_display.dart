import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:rateeat_mobile/src/features/item_detail/data/data.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/review_image_video_highlight.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:video_player/video_player.dart';

import '../../../../core/core.dart';

class ImageDialog extends StatefulWidget {
  final List<dynamic> imageURLs;
  final PageController pageController;
  final List<dynamic> mediaList;

  const ImageDialog({
    super.key,
    required this.imageURLs,
    required this.pageController,
    required this.mediaList,
  });

  @override
  State<ImageDialog> createState() => _ImageDialogState();
}

class _ImageDialogState extends State<ImageDialog>
    with SingleTickerProviderStateMixin {
  late final List<VideoPlayerController> videoControllers;
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    videoControllers = List<VideoPlayerController>.generate(
      widget.mediaList.length,
      (index) => VideoPlayerController.networkUrl(Uri.parse(
          widget.mediaList[index] is ReviewMedia
              ? widget.mediaList[index].url
              : widget.mediaList[index])),
    );

    _controller = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    )..addListener(() {
        setState(() {});
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    for (var controller in videoControllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => PageViewIndexCubit(),
      child: BlocBuilder<PageViewIndexCubit, int>(
        builder: (context, pageViewState) {
          return Stack(
            alignment: Alignment.center,
            children: [
              Dialog(
                backgroundColor: Colors.black.withOpacity(0.2),
                insetPadding: EdgeInsets.zero,
                shape: const RoundedRectangleBorder(
                  borderRadius: BorderRadius.zero,
                ),
                child: ReviewImageVideoHighlight(
                  highlights:
                      mapToHighlightModels(widget.imageURLs, widget.mediaList),
                ),
              ),
              Positioned(
                  top: 4.h,
                  right: 3.w,
                  child: Container(
                    height: 5.h,
                    width: 5.h,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      color: Colors.white.withOpacity(.5),
                      boxShadow: [...elevation_4],
                    ),
                    child: IconButton(
                      onPressed: () {
                        Navigator.pop(context);
                      },
                      icon: SvgPicture.asset(
                        'assets/icons/x.svg',
                        colorFilter: const ColorFilter.mode(
                          Colors.black,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),
                  )),
            ],
          );
        },
      ),
    );
  }
}

class PageViewIndexCubit extends Cubit<int> {
  PageViewIndexCubit() : super(0);

  void changeIndex(int index) {
    emit(index);
  }
}
