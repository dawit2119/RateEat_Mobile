import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mocktail/mocktail.dart';
import 'package:rateeat_mobile/src/features/one_click_review/data/models/simple_review_stepper_model.dart';
import 'package:rateeat_mobile/src/features/one_click_review/domain/entities/nearby_item_response.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/bloc/simple_review_stepper/simple_review_stepper_bloc.dart';
import 'package:rateeat_mobile/src/features/one_click_review/presentation/widgets/gallery_display.dart';

class MockSimpleReviewStepperBloc extends Mock
    implements SimpleReviewStepperBloc {}

void main() {
  late MockSimpleReviewStepperBloc mockBloc;

  setUp(() {
    mockBloc = MockSimpleReviewStepperBloc();
    when(() => mockBloc.state).thenReturn(
      SimpleReviewStepperState(
          simpleAddReviewStepperProps: SimpleAddReviewStepperModel(
        item: NearByItemResponse(
            id: '1', name: 'pizza', imageUri: 'https://smething.com/image.png'),
        images: [],
        videos: [],
        restaurant: null,
      )),
    );
  });

  testWidgets('GalleryPage displays correctly', (WidgetTester tester) async {
    await tester.pumpWidget(
      MaterialApp(
        home: BlocProvider<SimpleReviewStepperBloc>.value(
          value: mockBloc,
          child: const GalleryPage(),
        ),
      ),
    );

    // Verify app bar title exists
    expect(find.textContaining('Select Media'), findsOneWidget);

    // Verify placeholder text for no selected media
    expect(find.textContaining('No files selected'), findsOneWidget);
  });
}
