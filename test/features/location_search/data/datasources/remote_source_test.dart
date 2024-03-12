import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/features/features.dart';
import 'remote_source_test.mocks.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/google_auto_complete_model.dart';
import 'package:rateeat_mobile/src/features/location_search/data/models/location_coordinate_model.dart';
import 'package:rateeat_mobile/src/core/core.dart';

@GenerateNiceMocks([MockSpec<Dio>()])
void main() async {
  late SearchLocationRemoteSourceImpl remoteSource;
  late MockDio mockDio;
  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUp(() {
    mockDio = MockDio();
    remoteSource = SearchLocationRemoteSourceImpl(dio: mockDio);
  });

  group('getLocations', () {
    const place = 'Addis Ababa';

    test('returns a list of SearchAutoCompleteModel on success', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: [
              {'display_name': 'Addis Ababa', 'lat': '9.03', 'lon': '38.74'}
            ],
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await remoteSource.getLocations(place: place);

      expect(result, isA<List<SearchAutoCompleteModel>>());
      expect(result.length, 1);
      expect(result[0].description, 'Addis Ababa');
    });

    test('throws ServerException on error', () async {
      when(mockDio.get(any)).thenThrow(Exception('Network Error'));

      expect(
        () async => await remoteSource.getLocations(place: place),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getPlaces', () {
    const place = 'Addis Ababa';

    test('returns a list of GoogleAutoCompleteModel on success', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {
              'predictions': [
                {'description': 'Addis Ababa', 'place_id': '123'}
              ]
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await remoteSource.getPlaces(place: place);

      expect(result, isA<List<GoogleAutoCompleteModel>>());
      expect(result.length, 1);
      expect(result[0].description, 'Addis Ababa');
    });

    test('throws ServerException on error', () async {
      when(mockDio.get(any)).thenThrow(Exception('Network Error'));

      expect(
        () async => await remoteSource.getPlaces(place: place),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getPlaceCoordinates', () {
    const placeId = '123';

    test('returns LocationCoordinateModel on success', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {
              'result': {
                'geometry': {
                  'location': {'lat': 9.03, 'lng': 38.74}
                }
              }
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await remoteSource.getPlaceCoordinates(placeId: placeId);

      expect(result, isA<LocationCoordinateModel>());
      expect(result.latitude, 9.03);
      expect(result.longitude, 38.74);
    });

    test('throws ServerException on error', () async {
      when(mockDio.get(any)).thenThrow(Exception('Network Error'));

      expect(
        () async => await remoteSource.getPlaceCoordinates(placeId: placeId),
        throwsA(isA<ServerException>()),
      );
    });
  });

  group('getLocationDescription', () {
    const latitude = 9.03;
    const longitude = 38.74;

    test('returns formatted address on success', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {
              'results': [
                {'formatted_address': 'Addis Ababa'}
              ]
            },
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      final result = await remoteSource.getLocationDescription(
        latitude: latitude,
        longitude: longitude,
      );

      expect(result, 'Addis Ababa');
    });

    test('throws ServerException when no results found', () async {
      when(mockDio.get(any)).thenAnswer((_) async => Response(
            data: {'results': []},
            statusCode: 200,
            requestOptions: RequestOptions(path: ''),
          ));

      expect(
        () async => await remoteSource.getLocationDescription(
          latitude: latitude,
          longitude: longitude,
        ),
        throwsA(isA<ServerException>()),
      );
    });

    test('throws ServerException on error', () async {
      when(mockDio.get(any)).thenThrow(Exception('Network Error'));

      expect(
        () async => await remoteSource.getLocationDescription(
          latitude: latitude,
          longitude: longitude,
        ),
        throwsA(isA<ServerException>()),
      );
    });
  });
}
