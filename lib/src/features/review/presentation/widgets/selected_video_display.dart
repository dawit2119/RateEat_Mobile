import 'dart:io';

import 'package:chewie/chewie.dart';
import 'package:flutter/material.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:video_player/video_player.dart';

class SelectedVideoDisplay extends StatefulWidget {
  final bool remoteSource;
  final String videoPath;
  final VoidCallback onRemove;

  const SelectedVideoDisplay(
      {super.key,
      required this.videoPath,
      required this.onRemove,
      this.remoteSource = true});

  @override
  State<SelectedVideoDisplay> createState() => _SelectedVideoDisplayState();
}

class _SelectedVideoDisplayState extends State<SelectedVideoDisplay> {
  late VideoPlayerController _videoPlayerController;
  late ChewieController _chewieController;
  @override
  void initState() {
    super.initState();

    if (widget.remoteSource) {
      _videoPlayerController =
          VideoPlayerController.networkUrl(Uri.parse(widget.videoPath))
            ..addListener(_onVideoStateChanged);
    } else {
      _videoPlayerController =
          VideoPlayerController.file(File(widget.videoPath))
            ..addListener(_onVideoStateChanged);
    }

    _chewieController = ChewieController(
      videoPlayerController: _videoPlayerController,
      aspectRatio: _videoPlayerController.value.aspectRatio,
      autoPlay: false,
      looping: false,
    );
    _initializeVideoPlayer();
  }

  Future<void> _initializeVideoPlayer() async {
    try {
      await _videoPlayerController.initialize();
      setState(() {
        _videoPlayerController.pause();
      });
    } catch (e) {
      debugPrint("error in initialize video player ${e.toString()}");
    }
  }

  void _onVideoStateChanged() {
    if (_videoPlayerController.value.position >=
        _videoPlayerController.value.duration) {
      _videoPlayerController.seekTo(Duration.zero);
      _videoPlayerController.play();
    }
  }

  @override
  void dispose() {
    _videoPlayerController.removeListener(_onVideoStateChanged);
    _videoPlayerController.dispose();
    _chewieController.dispose();
    super.dispose();
  }

  void _showVideoDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (context) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(16.0),
        ),
        elevation: 0.0,
        backgroundColor: Colors.transparent,
        child: Stack(
          alignment: Alignment.center,
          children: [
            Container(
              width: MediaQuery.of(context).size.width,
              height: 400,
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(16.0),
                color: Colors.black,
              ),
              child: _videoPlayerController.value.isInitialized
                  ? Chewie(
                      controller: _chewieController,
                    )
                  : const Center(
                      child: CircularProgressIndicator(),
                    ),
            ),
            Positioned(
              top: 10,
              left: 10,
              child: IconButton(
                icon: const Icon(Icons.close, color: Colors.white),
                onPressed: () {
                  Navigator.of(context).pop();
                  _videoPlayerController.pause();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        _showVideoDialog(context);
      },
      child: Stack(
        alignment: Alignment.center,
        children: [
          _videoPlayerController.value.isInitialized
              ? ClipOval(
                  child: SizedBox(
                    height: SizeConfig.screenHeight * 0.1,
                    width: SizeConfig.screenHeight * 0.1,
                    child: VideoPlayer(_videoPlayerController),
                  ),
                )
              : ShimmerContainer(
                  width: SizeConfig.screenHeight * 0.1,
                  height: SizeConfig.screenHeight * 0.1,
                ),
          Icon(
            Icons.play_circle_filled,
            color: Colors.white,
            size: SizeConfig.screenHeight * 0.023,
          ),
          if (!widget.remoteSource)
            Positioned(
              top: 0,
              right: 0,
              child: GestureDetector(
                onTap: widget.onRemove,
                child: Container(
                  decoration: const BoxDecoration(
                    shape: BoxShape.circle,
                    color: Colors.red,
                  ),
                  child: Icon(
                    Icons.close,
                    color: Colors.white,
                    size: SizeConfig.screenHeight * 0.024,
                  ),
                ),
              ),
            ),
        ],
      ),
    );
  }
}
