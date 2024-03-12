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
import 'package:rateeat_mobile/src/features/review/presentation/bloc/add_restaurant_review/add_restaurant_review_bloc.dart';
import 'package:rateeat_mobile/src/features/review/presentation/pages/add_restaurant_review_page.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/review_entity_info_card.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/selected_image_display.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/star_rating.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/submit_button.dart';
import 'package:rateeat_mobile/src/features/review/presentation/widgets/textfield_input.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'add_restaurant_review_widget_test.mocks.dart';

class MockLocalAnalyticsObserver extends Mock
    implements LocalAnalyticsObserver {}

class MockAnalyticsObserver extends Mock implements AnalyticsObserver {}

class MockAuthenticationLocalSource extends Mock
    implements AuthenticationLocalSource {}

class MockAddRestaurantReviewBloc extends Mock
    implements AddRestaurantReviewBloc {}

@GenerateNiceMocks([
  MockSpec<MockAuthenticationLocalSource>(),
  MockSpec<MockLocalAnalyticsObserver>(),
  MockSpec<MockAnalyticsObserver>(),
  MockSpec<MockAddRestaurantReviewBloc>(),
  MockSpec<ImagePicker>(),
])
void main() {
  group("add restaurant review testing", () {
    late MockLocalAnalyticsObserver mockLocalAnalyticsObserver;
    late MockAnalyticsObserver mockAnalyticsObserver;
    late MockAuthenticationLocalSource mockAuthenticationLocalSource;
    late MockAddRestaurantReviewBloc mockAddRestaurantReviewBloc;
    late MockImagePicker mockImagePicker;

    setUp(() async {
      mockLocalAnalyticsObserver = MockMockLocalAnalyticsObserver();
      mockAddRestaurantReviewBloc = MockMockAddRestaurantReviewBloc();
      mockAuthenticationLocalSource = MockMockAuthenticationLocalSource();
      mockAnalyticsObserver = MockMockAnalyticsObserver();
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

      dpLocator.registerFactory<AddRestaurantReviewBloc>(
          () => mockAddRestaurantReviewBloc);
    });
    RestaurantModel restaurantModel = RestaurantModel(
      id: '1',
      name: 'Dummy Restaurant',
      openingHour: '08:00:00',
      closingHour: '10:00:00',
      isOpen: true,
      averagePrice: 25.0,
      averageRating: 4.5,
      numberOfReviews: 100,
      popularityIndex: 80,
      userId: 'user123',
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      distance: '1.5 miles',
      walkingTime: '20 mins',
      ridingTime: '10 mins',
      restaurantTags: const [
        RestaurantTagModel(id: '1', name: 'Tag 1'),
        RestaurantTagModel(id: '2', name: 'Tag 2'),
      ],
      restaurantImages: const [],
      restaurantVideos: const [],
      restaurantLocations: const [
        RestaurantLocationModel(id: '1', latitude: 0.0, longitude: 0.0),
      ],
      restaurantPhoneNumbers: const [],
    );
    Widget makeTestableWidget(Widget body) {
      return MultiBlocProvider(
        providers: [
          BlocProvider(
              create: (context) => dpLocator<AddRestaurantReviewBloc>()),
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

    testWidgets('Should display the widgets on restaurant add review page',
        (WidgetTester tester) async {
      await tester.pumpWidget(makeTestableWidget(AddRestaurantReviewPage(
        restaurant: restaurantModel,
      )));

      expect(find.byType(SingleChildScrollView), findsOneWidget);
      expect(find.byType(ReviewEntityInfoCard), findsOneWidget);
      expect(find.byType(StarRatingInput), findsOneWidget);
      expect(find.byType(InputTextfield), findsOneWidget);
      expect(find.byType(SubmitButton), findsOneWidget);
    });

    testWidgets('should display selected images and videos',
        (WidgetTester tester) async {
      await tester.pumpWidget(
        makeTestableWidget(
          AddRestaurantReviewPage(
            restaurant: restaurantModel,
            imagePicker: mockImagePicker,
          ),
        ),
      );
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
