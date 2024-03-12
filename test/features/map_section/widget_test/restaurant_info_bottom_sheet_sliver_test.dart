import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover_restaurant_result/data/models/discover_restaurant_result_model/restaurant_phone_number.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/widgets/restaurant_info_bottom_sheet_sliver.dart';
import 'package:rateeat_mobile/src/features/review/presentation/bloc/get_restaurant_reviews/get_restaurant_reviews_bloc.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'restaurant_info_bottom_sheet_sliver_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetRestaurantReviewsBloc>(),
])
void main() {
  late MockGetRestaurantReviewsBloc mockBloc;

  setUp(() {
    mockBloc = MockGetRestaurantReviewsBloc();
  });

  Widget createWidgetUnderTest() {
    return BlocProvider<GetRestaurantReviewsBloc>(
      create: (context) => mockBloc,
      child: ResponsiveSizer(builder: (context, orientation, screenType) {
        SizeConfig().init(context);
        return MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: Scaffold(
            body: RestaurantInfoBottomSheet(
              restaurant: Restaurant(
                id: '1',
                name: 'Test Restaurant',
                averageRating: 4.5,
                numberOfReviews: 10,
                restaurantPhoneNumbers: [
                  RestaurantPhoneNumber(phoneNumber: '0123456789')
                ],
                walkingTime: '10 mins',
                openingHour: '08:00:00',
                closingHour: '22:00:00',
                restaurantLocations: [
                  RestaurantLocation(latitude: 0.0, longitude: 0.0)
                ],
                restaurantImages: [],
                restaurantVideos: [],
              ),
            ),
          ),
        );
      }),
    );
  }

  testWidgets('renders restaurant name and average rating',
      (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(createWidgetUnderTest());

    // Act
    await tester.pumpAndSettle();

    // Assert
    expect(find.text('Test Restaurant'), findsOneWidget);
    expect(find.text('4.5'), findsOneWidget);
  });

  testWidgets('calls GetRestaurantReviewsRequestEvent on initialization',
      (WidgetTester tester) async {
    // Arrange
    when(mockBloc.state).thenReturn(GetRestaurantReviewsInitial(
        sortType: RestaurantReviewsSortTypesState.mostPopular));
    await tester.pumpWidget(createWidgetUnderTest());

    // Act
    await tester.pumpAndSettle();

    // Assert
    verify(mockBloc.add(GetRestaurantReviewsRequestEvent(restaurantId: '1')))
        .called(1);
  });

  testWidgets('displays correct opening hours', (WidgetTester tester) async {
    // Arrange
    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pumpAndSettle();

    // Act
    // Verify that it shows "Open" or "Closed" based on the current time
    expect(find.text('Open'),
        findsOneWidget); // or 'Closed' depending on the test time
  });

  // Add more tests as necessary, such as for the tabs, images, and reviews
}
