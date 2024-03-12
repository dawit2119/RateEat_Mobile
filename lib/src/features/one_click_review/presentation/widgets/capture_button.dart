import 'dart:async';

import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:flutter/material.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

class CaptureButton extends StatefulWidget {
  final CameraState state;

  const CaptureButton({super.key, required this.state});

  @override
  State<StatefulWidget> createState() => _CaptureButtonState();
}

class _CaptureButtonState extends State<CaptureButton> {
  String _videoTime = "00:00";
  final Stopwatch _stopwatch = Stopwatch();
  late Timer timer;
  bool canCapture = true;
  @override
  void initState() {
    timer = Timer.periodic(const Duration(seconds: 1), (Timer timer) {
      setState(() {
        // Update elapsed time only if the stopwatch is running
        if (_stopwatch.isRunning) {
          _updateElapsedTime();
        }
      });
    });
    super.initState();
  }

  @override
  void dispose() {
    timer.cancel();
    super.dispose();
  }

  // Start/Stop button callback
  void _startStopwatch() {
    if (!_stopwatch.isRunning) {
      // Start the stopwatch and update elapsed time
      _stopwatch.start();
      _updateElapsedTime();
    } else {
      // Stop the stopwatch
      _stopwatch.stop();
    }
  }

  // Reset button callback
  void _resetStopwatch() {
    // Reset the stopwatch to zero and update elapsed time
    _stopwatch.reset();
    _updateElapsedTime();
  }

  // Update elapsed time and formatted time string
  void _updateElapsedTime() {
    setState(() {
      _videoTime = _formatElapsedTime(_stopwatch.elapsed);
    });
  }

  // Format a Duration into a string (MM:SS.SS)
  String _formatElapsedTime(Duration time) {
    return '${time.inMinutes.remainder(60).toString().padLeft(2, '0')}:${(time.inSeconds.remainder(60)).toString().padLeft(2, '0')}';
  }

  @override
  Widget build(BuildContext context) {
    return widget.state.when(
      onPhotoMode: (cameraState) {
        //camera button
        return SizedBox(
          height: 15.h,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () async {
                if (canCapture) {
                  setState(() {
                    canCapture = false;
                  });
                  cameraState.takePhoto();
                  await Future.delayed(const Duration(seconds: 1));
                  setState(() {
                    canCapture = true;
                  });
                }
              },
              child: Stack(
                children: [
                  Container(
                    height: 12.h,
                    width: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                    width: 12.h,
                    child: Center(
                      child: Container(
                        height: 9.5.h,
                        width: 9.5.h,
                        decoration: const BoxDecoration(
                          color: Colors.white,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      onVideoMode: (videoState) {
        _stopwatch.stop();
        //start recording video button
        return SizedBox(
          height: 15.h,
          width: 12.h,
          child: Align(
            alignment: Alignment.bottomCenter,
            child: GestureDetector(
              onTap: () {
                videoState.startRecording();
                _startStopwatch();
              },
              child: Stack(
                children: [
                  Container(
                    height: 12.h,
                    width: 12.h,
                    decoration: BoxDecoration(
                      color: Colors.white.withOpacity(0.5),
                      shape: BoxShape.circle,
                    ),
                  ),
                  SizedBox(
                    height: 12.h,
                    width: 12.h,
                    child: Center(
                      child: Container(
                        height: 9.5.h,
                        width: 9.5.h,
                        decoration: const BoxDecoration(
                          color: Colors.red,
                          shape: BoxShape.circle,
                        ),
                      ),
                    ),
                  )
                ],
              ),
            ),
          ),
        );
      },
      onVideoRecordingMode: (videoRecordinagState) {
        _stopwatch.start();
        //stop recoring video button
        return SizedBox(
          height: 15.h,
          width: 12.h,
          child: Column(
            children: [
              Text(
                _videoTime,
                style: const TextStyle(
                  color: Colors.white,
                ),
              ),
              SizedBox(
                height: 0.4.h,
              ),
              GestureDetector(
                onTap: () {
                  videoRecordinagState.stopRecording();
                  _resetStopwatch();
                },
                child: Stack(
                  children: [
                    Container(
                      height: 12.h,
                      width: 12.h,
                      decoration: BoxDecoration(
                        color: Colors.white.withOpacity(0.5),
                        shape: BoxShape.circle,
                      ),
                    ),
                    SizedBox(
                      height: 12.h,
                      width: 12.h,
                      child: Center(
                        child: Container(
                          height: 6.h,
                          width: 6.h,
                          decoration: const BoxDecoration(
                              color: Colors.red,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(10))),
                        ),
                      ),
                    )
                  ],
                ),
              ),
            ],
          ),
        );
      },
    );
  }
}
