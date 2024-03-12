import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:mockito/annotations.dart';
import 'package:rateeat_mobile/l10n/gen_l10n/app_localizations.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/map_section/presentation/widgets/google_map_content.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'location_search_page_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<AutoCompleteBloc>(),
  MockSpec<SearchQueryCubit>(),
])
void main() {
  late MockAutoCompleteBloc mockAutoCompleteBloc;
  late MockSearchQueryCubit mockSearchQueryCubit;

  setUp(() {
    mockAutoCompleteBloc = MockAutoCompleteBloc();
    mockSearchQueryCubit = MockSearchQueryCubit();
  });

  Widget createWidgetUnderTest() {
    return MultiBlocProvider(
      providers: [
        BlocProvider<AutoCompleteBloc>(
          create: (_) => mockAutoCompleteBloc,
        ),
        BlocProvider<SearchQueryCubit>(
          create: (_) => mockSearchQueryCubit,
        ),
      ],
      child: ResponsiveSizer(builder: (context, orientation, screenType) {
        SizeConfig().init(context);
        return const MaterialApp(
          localizationsDelegates: AppLocalizations.localizationsDelegates,
          supportedLocales: AppLocalizations.supportedLocales,
          home: LocationSearchPage(),
        );
      }),
    );
  }

  testWidgets('renders search bar and handles input',
      (WidgetTester tester) async {
    await tester.pumpWidget(createWidgetUnderTest());

    // Verify the search bar is present
    expect(find.byType(TextField), findsOneWidget);

    // Simulate typing in the search bar
    await tester.enterText(find.byType(TextField), 'Addis Ababa');
    verify(mockSearchQueryCubit.updateQuery('Addis Ababa')).called(1);
    verify(mockAutoCompleteBloc.add(GetPlacesEvent(place: 'Addis Ababa')))
        .called(1);
  });

  testWidgets('displays loading animation during search',
      (WidgetTester tester) async {
    when(mockAutoCompleteBloc.state)
        .thenReturn(SearchPlacesState(status: SearchStatus.loading));

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Trigger a frame

    // Verify loading animation is displayed
    expect(
        find.byKey(
          Key("search_state_loading_widget"),
        ),
        findsOneWidget);
  });

  testWidgets('displays search results when loaded',
      (WidgetTester tester) async {
    when(mockAutoCompleteBloc.state).thenReturn(
      SearchPlacesState(
        status: SearchStatus.loaded,
        searchAutocomplete: [
          GoogleAutoCompleteModel(description: 'Addis Ababa', placeId: '123'),
        ],
      ),
    );

    await tester.pumpWidget(createWidgetUnderTest());
    await tester.pump(); // Trigger a frame

    // Verify that the location tile is displayed
    expect(find.text('Addis Ababa'), findsNWidgets(2));
  });
}
