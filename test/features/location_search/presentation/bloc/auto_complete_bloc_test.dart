import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/usecases/google_search_places.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/usecases/search_location_usecase.dart';

import 'auto_complete_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GoogleLocationUseCase>(),
  MockSpec<SearchLocationUseCase>(),
])
void main() {
  late AutoCompleteBloc autoCompleteBloc;
  late MockGoogleLocationUseCase mockGoogleLocationUseCase;
  late MockSearchLocationUseCase mockSearchLocationUseCase;

  setUp(() {
    mockGoogleLocationUseCase = MockGoogleLocationUseCase();
    mockSearchLocationUseCase = MockSearchLocationUseCase();
    autoCompleteBloc = AutoCompleteBloc(
      googleLocationUseCase: mockGoogleLocationUseCase,
      searchLocationUseCase: mockSearchLocationUseCase,
    );
  });

  const String place = "Paris";
  const locationResponse = [
    SearchAutoCompleteModel(
      name: 'Addis Ababa',
      description: "Paris",
      placeId: "1",
      latitude: '1.0',
      longitude: '1.0',
    ),
  ];
  const placesResponse = [
    GoogleAutoCompleteModel(
      description: "Paris",
      placeId: "1",
    )
  ];
  group('AutoComplete Bloc', () {
    test('initial state should be AutoCompleteInitial', () {
      // assert
      expect(autoCompleteBloc.state, AutoCompleteInitial());
    });

    group('search location', () {
      blocTest<AutoCompleteBloc, AutoCompleteState>(
        'should emit [ SearchLocationState(SearchStatus.loading), SearchLocationState(SearchStatus.loaded)] when SearchLocationEvent is called.',
        build: () {
          when(
            mockSearchLocationUseCase(
              const SearchLocationParams(place: place),
            ),
          ).thenAnswer(
            (_) async => const Right(
              locationResponse,
            ),
          );
          return autoCompleteBloc;
        },
        act: (bloc) => bloc.add(SearchLocationEvent(place: place)),
        expect: () => <AutoCompleteState>[
          SearchLocationState(status: SearchStatus.loading),
          SearchLocationState(
            status: SearchStatus.loaded,
            searchAutocomplete: locationResponse,
          ),
        ],
      );
      blocTest<AutoCompleteBloc, AutoCompleteState>(
        'should emit [ SearchLocationState(SearchStatus.loading), SearchLocationState(SearchStatus.error)] when SearchLocationEvent is called.',
        build: () {
          when(
            mockSearchLocationUseCase(
              const SearchLocationParams(place: place),
            ),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure(errorMessage: "Server Error"),
            ),
          );
          return autoCompleteBloc;
        },
        act: (bloc) => bloc.add(SearchLocationEvent(place: place)),
        expect: () => <AutoCompleteState>[
          SearchLocationState(status: SearchStatus.loading),
          SearchLocationState(
              status: SearchStatus.error, errorMessage: "Server Error"),
        ],
      );
    });

    group('get places', () {
      blocTest<AutoCompleteBloc, AutoCompleteState>(
        'should emit [ SearchPlacesState(status: SearchStatus.loading), SearchPlacesState(status: SearchStatus.loaded)] when GetPlacesEvent is called.',
        build: () {
          when(
            mockGoogleLocationUseCase(
              const SearchLocationParams(place: place),
            ),
          ).thenAnswer(
            (_) async => const Right(placesResponse),
          );
          return autoCompleteBloc;
        },
        act: (bloc) => bloc.add(GetPlacesEvent(place: place)),
        expect: () => <AutoCompleteState>[
          SearchPlacesState(status: SearchStatus.loading),
          SearchPlacesState(
            status: SearchStatus.loaded,
            searchAutocomplete: placesResponse,
          ),
        ],
      );
      blocTest<AutoCompleteBloc, AutoCompleteState>(
        'should emit [ SearchPlacesState(status: SearchStatus.loading), SearchPlacesState(status: SearchStatus.error)] when GetPlacesEvent is called.',
        build: () {
          when(
            mockGoogleLocationUseCase(
              const SearchLocationParams(place: place),
            ),
          ).thenAnswer(
            (_) async => Left(
              ServerFailure(errorMessage: "Server Error"),
            ),
          );
          return autoCompleteBloc;
        },
        act: (bloc) => bloc.add(GetPlacesEvent(place: place)),
        expect: () => <AutoCompleteState>[
          SearchPlacesState(status: SearchStatus.loading),
          SearchPlacesState(
              status: SearchStatus.error, errorMessage: "Server Error"),
        ],
      );
    });

    group('trigger initial event', () {
      blocTest<AutoCompleteBloc, AutoCompleteState>(
        'should emit [ AutoCompleteInitial()] when TriggerInitialEvent is called.',
        build: () {
          return autoCompleteBloc;
        },
        act: (bloc) => bloc.add(TriggerInitialEvent()),
        expect: () => <AutoCompleteState>[
          AutoCompleteInitial(),
        ],
      );
    });
  });
}
