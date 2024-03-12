import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/discover/discover.dart';
import 'package:rateeat_mobile/src/features/location_search/domain/usecases/get_location_description_usecase.dart';
import 'package:rateeat_mobile/src/features/location_search/presentation/bloc/location_description/location_description_bloc.dart';

import 'location_description_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetLocationDescriptionUseCase>(),
])
void main() {
  late LocationDescriptionBloc locationDescriptionBloc;
  late MockGetLocationDescriptionUseCase mockGetLocationDescriptionUseCase;

  setUp(() {
    mockGetLocationDescriptionUseCase = MockGetLocationDescriptionUseCase();
    locationDescriptionBloc = LocationDescriptionBloc(
      getLocationDescriptionUseCase: mockGetLocationDescriptionUseCase,
    );
  });

  const location = Location(
    latitude: 1.0,
    longitude: 1.0,
  );
  const locationDescription = 'Paris is the capital of France';

  group('Location Description Bloc', () {
    test('initial state should be LocationDescriptionState', () {
      // assert
      expect(locationDescriptionBloc.state,
          const LocationDescriptionState(locationDescription: ''));
    });

    group('get location description', () {
      blocTest<LocationDescriptionBloc, LocationDescriptionState>(
        'should emit [ LocationDescriptionState(locationDescription: locationDescription)] when UpdateLocationDescription is called.',
        build: () {
          when(
            mockGetLocationDescriptionUseCase(location),
          ).thenAnswer((_) async => const Right(locationDescription));

          return locationDescriptionBloc;
        },
        act: (bloc) => bloc.add(UpdateLocationDescription(location: location)),
        expect: () => [
          const LocationDescriptionState(
              locationDescription: locationDescription),
        ],
      );

      blocTest<LocationDescriptionBloc, LocationDescriptionState>(
        'should emit [ LocationDescriptionState(locationDescription: errorMessage)] when UpdateLocationDescription is called.',
        build: () {
          when(
            mockGetLocationDescriptionUseCase(location),
          ).thenAnswer((_) async => Left(ServerFailure(errorMessage: 'error')));

          return locationDescriptionBloc;
        },
        act: (bloc) => bloc.add(UpdateLocationDescription(location: location)),
        expect: () => [
          const LocationDescriptionState(locationDescription: 'error'),
        ],
      );
    });
  });
}
