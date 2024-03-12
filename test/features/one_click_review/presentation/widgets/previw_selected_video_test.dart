// import 'dart:io';
// import 'package:chewie/chewie.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_test/flutter_test.dart';
// import 'package:mockito/annotations.dart';
// import 'package:mockito/mockito.dart';
// import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/preview_selected_video.dart';
// import 'package:video_player/video_player.dart';

// import 'preview_selcted_video_test.mocks.dart';

// void main() {
//   late MockVideoPlayerController mockVideoPlayerController;
//   late MockChewieController mockChewieController;

//   setUp(() {
//     mockVideoPlayerController = MockVideoPlayerController();
//     mockChewieController = MockChewieController();
//   });

//   testWidgets('PreviewVideo shows loading state initially',
//       (WidgetTester tester) async {
//     const testVideoPath = 'test/path/to/video.mp4';
//     when(mockVideoPlayerController.initialize())
//         .thenAnswer((_) => Future.value());
//     when(mockVideoPlayerController.value)
//         .thenReturn(VideoPlayerValue(duration: Duration.zero));

//     await tester.pumpWidget(
//       MaterialApp(
//         home: PreviewVideo(
//           videoPath: testVideoPath,
//         ),
//       ),
//     );

//     expect(find.byType(PreviewVideo), findsOneWidget);
//     expect(find.byType(Dialog), findsOneWidget);
//     expect(find.byType(CircularProgressIndicator),
//         findsOneWidget); // Loading state
//     expect(find.byType(IconButton), findsOneWidget);
//   });

//   testWidgets('PreviewVideo shows video when initialized',
//       (WidgetTester tester) async {
//     const testVideoPath = 'test/path/to/video.mp4';
//     when(mockVideoPlayerController.initialize())
//         .thenAnswer((_) => Future.value());
//     when(mockVideoPlayerController.value).thenReturn(
//       VideoPlayerValue(
//         duration: const Duration(seconds: 1),
//         isInitialized: true,
//       ),
//     );

//     await tester.pumpWidget(
//       MaterialApp(
//         home: PreviewVideo(
//           videoPath: testVideoPath,
//         ),
//       ),
//     );
//     await tester.pump(); // Allow state update after initialization

//     // Assert
//     expect(find.byType(PreviewVideo), findsOneWidget);
//     expect(find.byType(Chewie), findsOneWidget);
//     expect(find.byType(IconButton), findsOneWidget);
//     expect(find.byType(CircularProgressIndicator), findsNothing);
//   });
// }
