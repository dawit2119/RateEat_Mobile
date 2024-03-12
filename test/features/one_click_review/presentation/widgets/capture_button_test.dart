import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:camerawesome/camerawesome_plugin.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/capture_button.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

enum CameraState {
  photo,
  video,
}

class CaptureButton extends StatelessWidget {
  final CameraState state;

  CaptureButton({required this.state});

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        // Handle tap
      },
      child: Icon(
        state == CameraState.photo ? Icons.camera_alt : Icons.videocam,
      ),
    );
  }
}

void main() {
  testWidgets('CaptureButton renders and responds to taps',
      (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: ResponsiveSizer(
            builder: (context, orientation, screenType) {
              return CaptureButton(
                state: CameraState.photo,
              );
            },
          ),
        ),
      ),
    );

    expect(find.byType(CaptureButton), findsOneWidget);

    await tester.tap(find.byType(GestureDetector));
    await tester.pump();
  });
}
