import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/location_coordinate_model.dart';

import 'search_location_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<SearchLocationRemoteSource>(),
])
void main() {
  late SearchLocationRepositoryImpl searchLocationRepositoryImpl;
  late MockSearchLocationRemoteSource mockSearchLocationRemoteSource;

  setUp(() {
    mockSearchLocationRemoteSource = MockSearchLocationRemoteSource();
    searchLocationRepositoryImpl = SearchLocationRepositoryImpl(
      remoteSource: mockSearchLocationRemoteSource,
    );
  });

  const String place = 'place';

  group('Location Search Repo', () {
    group('get locations from Nominatim API', () {
      test('should return a list of search auto complete model', () async {
        // arrange
        final suggestions = <SearchAutoCompleteModel>[
          const SearchAutoCompleteModel(
            description: 'Addis Ababa, Ethiopia',
            placeId: 'ChIJQ6Vb0y8JYRcRnZM0v9Uv4YQ',
            name: 'Addis Ababa',
            latitude: '0.1',
            longitude: '0.1',
          )
        ];
        when(
          mockSearchLocationRemoteSource.getLocations(place: place),
        ).thenAnswer(
          (_) async => suggestions,
        );

        // act
        final result =
            await searchLocationRepositoryImpl.getLocations(place: place);
        // assert
        expect(result, equals(Right(suggestions)));
      });

      test('should return a failure when the server fails', () async {
        // arrange
        when(
          mockSearchLocationRemoteSource.getLocations(place: place),
        ).thenThrow(ServerException(errorMessage: 'Server error'));

        // act
        final result =
            await searchLocationRepositoryImpl.getLocations(place: place);
        // assert
        expect(
            result, equals(Left(ServerFailure(errorMessage: 'Server error'))));
      });
    });

    group('get places from google API', () {
      test('should return a list of google auto complete model', () async {
        // arrange
        final predictions = <GoogleAutoCompleteModel>[
          const GoogleAutoCompleteModel(
            description: 'Addis Ababa, Ethiopia',
            placeId: 'ChIJQ6Vb0y8JYRcRnZM0v9Uv4YQ',
          )
        ];
        when(
          mockSearchLocationRemoteSource.getPlaces(place: place),
        ).thenAnswer(
          (_) async => predictions,
        );

        // act
        final result =
            await searchLocationRepositoryImpl.getPlaces(place: place);
        // assert
        expect(result, equals(Right(predictions)));
      });

      test('should return a failure when the server fails', () async {
        // arrange
        when(
          mockSearchLocationRemoteSource.getPlaces(place: place),
        ).thenThrow(ServerException(errorMessage: 'Server error'));

        // act
        final result =
            await searchLocationRepositoryImpl.getPlaces(place: place);
        // assert
        expect(
            result, equals(Left(ServerFailure(errorMessage: 'Server error'))));
      });
    });

    group('get place coordinates from google API', () {
      test('should return a location coordinate model', () async {
        // arrange
        const locationCoordinate = LocationCoordinateModel(
          latitude: 0.1,
          longitude: 0.1,
          name: 'Addis Ababa',
        );
        when(
          mockSearchLocationRemoteSource.getPlaceCoordinates(placeId: place),
        ).thenAnswer(
          (_) async => locationCoordinate,
        );

        // act
        final result = await searchLocationRepositoryImpl.getPlaceCoordinates(
          placeId: place,
        );
        // assert
        expect(result, equals(const Right(locationCoordinate)));
      });

      test('should return a failure when the server fails', () async {
        // arrange
        when(
          mockSearchLocationRemoteSource.getPlaceCoordinates(placeId: place),
        ).thenThrow(ServerException(errorMessage: 'Server error'));

        // act
        final result = await searchLocationRepositoryImpl.getPlaceCoordinates(
          placeId: place,
        );
        // assert
        expect(
            result, equals(Left(ServerFailure(errorMessage: 'Server error'))));
      });
    });

    group('get location description from GOogle API', () {
      test('should return a location description', () async {
        // arrange
        const locationDescription = 'Addis Ababa, Ethiopia';
        when(
          mockSearchLocationRemoteSource.getLocationDescription(
            latitude: 0.1,
            longitude: 0.1,
          ),
        ).thenAnswer(
          (_) async => locationDescription,
        );

        // act
        final result =
            await searchLocationRepositoryImpl.getLocationDescription(
          latitude: 0.1,
          longitude: 0.1,
        );
        // assert
        expect(result, equals(const Right(locationDescription)));
      });

      test('should return a failure when the server fails', () async {
        // arrange
        when(
          mockSearchLocationRemoteSource.getLocationDescription(
            latitude: 0.1,
            longitude: 0.1,
          ),
        ).thenThrow(ServerException(errorMessage: 'Server error'));

        // act
        final result =
            await searchLocationRepositoryImpl.getLocationDescription(
          latitude: 0.1,
          longitude: 0.1,
        );
        // assert
        expect(
            result, equals(Left(ServerFailure(errorMessage: 'Server error'))));
      });
    });
  });
}
