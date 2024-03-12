import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:image_picker/image_picker.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';

import 'package:rateeat_mobile/src/core/service/firebase_analytics.dart';
import 'package:rateeat_mobile/src/core/service/local_analytics.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'package:rateeat_mobile/src/features/review/presentation/bloc/add_item_review/add_item_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/add_item_review_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/review_entity_info_card.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_image_display.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/star_rating.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/textfield_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'add_item_review_widget_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AuthenticationLocalSource>(),
  MockSpec<LocalAnalyticsObserver>(),
  MockSpec<AnalyticsObserver>(),
  MockSpec<AddItemReviewBloc>(),
  MockSpec<ImagePicker>(),
])
void main() {
  group("add item review testing", () {
    late MockLocalAnalyticsObserver mockLocalAnalyticsObserver;
    late MockAnalyticsObserver mockAnalyticsObserver;
    late MockAuthenticationLocalSource mockAuthenticationLocalSource;
    late MockAddItemReviewBloc mockAddItemReviewBloc;
    late MockImagePicker mockImagePicker;

    setUp(() async {
      mockAuthenticationLocalSource = MockAuthenticationLocalSource();
      mockAnalyticsObserver = MockAnalyticsObserver();
      mockLocalAnalyticsObserver = MockLocalAnalyticsObserver();
      mockAddItemReviewBloc = MockAddItemReviewBloc();
      mockImagePicker = MockImagePicker();
      await dpLocator.reset();
      dpLocator.registerFactory<LocalAnalyticsObserver>(
        () => mockLocalAnalyticsObserver,
      );
      dpLocator.registerFactory<AnalyticsObserver>(
        () => mockAnalyticsObserver,
      );

      dpLocator.registerFactory<AuthenticationLocalSource>(
          () => mockAuthenticationLocalSource);

      dpLocator.registerFactory<AddItemReviewBloc>(() => mockAddItemReviewBloc);

      HttpOverrides.global = null;
    });

    Widget makeTestableWidget(Widget body) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(create: (context) => dpLocator<AddItemReviewBloc>()),
        ],
        child: MaterialApp(
          locale: const Locale('en', 'US'),
          supportedLocales: AppLocalizations.supportedLocales,
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          home: ResponsiveSizer(builder: (context, orientation, screenType) {
            SizeConfig().init(context);
            return body;
          }),
        ),
      );
    }

    final item = ItemModel(
        itemId: '',
        itemName: '',
        numberOfReviews: 100,
        description: '',
        restaurantName: '',
        price: 100,
        imageUrl: '',
        tags: const [],
        fasting: false,
        isFavorite: false,
        ingredients: const [],
        walkingTime: '10',
        ridingTime: '20',
        distance: '200',
        categories: null,
        isOpen: false,
        itemImages: const [],
        itemVideos: const []);

    testWidgets('Should display the widgets', (WidgetTester tester) async {
      await tester
          .pumpWidget(makeTestableWidget(AddItemReviewPage(item: item)));

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(ReviewEntityInfoCard), findsOneWidget);
      expect(find.byType(StarRatingInput), findsOneWidget);
      expect(find.byType(InputTextfield), findsOneWidget);
      expect(find.byType(SubmitButton), findsOneWidget);
    });
    testWidgets('Should display selected images', (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(AddItemReviewPage(
        item: item,
        imagePicker: mockImagePicker,
      )));
      when(mockImagePicker.pickMultipleMedia(
              imageQuality: anyNamed('imageQuality')))
          .thenAnswer((_) async => [
                XFile('assets/images/add_review.png'),
                XFile('assets/images/add_review.png'),
                XFile('assets/images/add_review.png'),
              ]);
      await tester.tap(find.byType(InkWell).first);
      await tester.pump(Duration(milliseconds: 500));
      expect(find.byType(SelectedImageDisplay), findsNWidgets(3));
    });
  });
}
