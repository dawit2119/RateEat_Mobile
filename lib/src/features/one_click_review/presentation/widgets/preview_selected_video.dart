import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:video_player/video_player.dart';

class PreviewVideo extends StatefulWidget {
  final String videoPath;
  final VoidCallback? onClose;

  const PreviewVideo({super.key, required this.videoPath, this.onClose});

  @override
  State<PreviewVideo> createState() => _PreviewVideoState();
}

class _PreviewVideoState extends State<PreviewVideo> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;

  @override
  void initState() {
    super.initState();

    _videoPlayerController = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        setState(() {});
      });

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoPlay: false,
      looping: false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: SizedBox(
          width: SizeConfig.screenHeight * 0.5,
          height: SizeConfig.screenHeight * 0.5,
          child: Stack(
            alignment: Alignment.center,
            children: [
              _videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
              Positioned(
                top: 10,
                left: 10,
                child: IconButton(
                  icon: const Icon(Icons.close, color: Colors.white),
                  onPressed: () {
                    _chewieController.pause();
                    _videoPlayerController.pause();
                    widget.onClose?.call();
                  },
                ),
              ),
            ],
          ),
        ));
  }

  @override
  void dispose() {
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }
}
