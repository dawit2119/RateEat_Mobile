import 'package:flutter/material.dart';
import 'package:loading_animation_widget/loading_animation_widget.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:video_player/video_player.dart';

class CustomVidePlayer extends StatefulWidget {
  final String videoUrl;
  const CustomVidePlayer({super.key, required this.videoUrl});

  @override
  State<CustomVidePlayer> createState() => _CustomVidePlayerState();
}

class _CustomVidePlayerState extends State<CustomVidePlayer> {
  late VideoPlayerController _videoPlayerController;

  @override
  void initState() {
    super.initState();
    _videoPlayerController =
        VideoPlayerController.networkUrl(Uri.parse(widget.videoUrl))
          ..addListener(_onVideoStateChanged);

    _videoPlayerController.initialize().then((_) {
      setState(() {});
      _videoPlayerController.play();
    });
  }

  void _onVideoStateChanged() {
    if (_videoPlayerController.value.position >=
        _videoPlayerController.value.duration) {
      // Video has reached the end, seek to the beginning
      _videoPlayerController.seekTo(Duration.zero);

      _videoPlayerController.play();
    }
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_onVideoStateChanged);
    _videoPlayerController.dispose();

    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    double screenHeight = MediaQuery.of(context).size.height;
    return Stack(
      alignment: Alignment.center,
      children: [
        _videoPlayerController.value.isInitialized
            ? SizedBox(
                height: screenHeight * 0.5,
                width: double.infinity,
                child: VideoPlayer(_videoPlayerController))
            : LoadingAnimationWidget.dotsTriangle(
                color: AppColors.primaryColor,
                size: 60,
              ),
      ],
    );
  }
}
