import 'dart:io';

import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/data_sources/candid_rest_data_sources.dart';
import 'package:rateeat_mobile/src/features/candidate_restaurant/data/models/candid_rest.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

import 'candid_rest_data_sources_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<Dio>(),
  MockSpec<AuthenticationLocalSource>(),
])
void main() async {
  late MockDio mockDio;
  late MockAuthenticationLocalSource mockAuthLocalSource;
  late CandidateDataSource candidateDataSource;

  TestWidgetsFlutterBinding.ensureInitialized();
  await dotenv.load(fileName: ".env");

  setUpAll(() async {
    mockDio = MockDio();
    mockAuthLocalSource = MockAuthenticationLocalSource();
    candidateDataSource = CandidateDataSource(dio: mockDio);

    final dpLocator = GetIt.instance;
    await dpLocator.reset();
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => mockAuthLocalSource);
  });

  group('CandidateDataSource', () {
    const String token = 'test_token';

    test(
        'createCandidate returns success message on status 201 when menuImages and restImages are empty',
        () async {
      // Arrange
      final candidRest = CandidRest(
          name: 'Test Restaurant',
          description: 'A great place to eat',
          menuImages: [],
          restImages: []);
      final user = LocalUserModel(token: token);

      when(mockAuthLocalSource.getUserCredential()).thenReturn(user);

      when(mockDio.post(
        "$baseURL/candidate-restaurants",
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            statusCode: 201,
            data: {},
            requestOptions:
                RequestOptions(path: "$baseURL/candidate-restaurants"),
          ));

      // Act
      final result = await candidateDataSource.createCandidate(candidRest);

      // Assert
      expect(result,
          "Restaurant registration is successful. We will review the suggested Restaurant");
    });

    test(
        'createCandidate returns success message on status 201 when restImages are null',
        () async {
      // Arrange
      final candidRest = CandidRest(
          name: 'Test Restaurant',
          description: 'A great place to eat',
          menuImages: [],
          restImages: null);
      final user = LocalUserModel(token: token);

      when(mockAuthLocalSource.getUserCredential()).thenReturn(user);

      when(mockDio.post(
        "$baseURL/candidate-restaurants",
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            statusCode: 201,
            data: {},
            requestOptions:
                RequestOptions(path: "$baseURL/candidate-restaurants"),
          ));

      // Act
      final result = await candidateDataSource.createCandidate(candidRest);

      // Assert
      expect(result,
          "Restaurant registration is successful. We will review the suggested Restaurant");
    });

    test(
        'createCandidate returns success message on status 201 when menuImages and restImages are not empty',
        () async {
      // Arrange
      final candidRest = CandidRest(
          name: 'Test Restaurant',
          description: 'A great place to eat',
          menuImages: [File('assets/images/add_review.png')],
          restImages: [File('assets/images/add_review.png')]);
      final user = LocalUserModel(token: token);

      when(mockAuthLocalSource.getUserCredential()).thenReturn(user);

      when(mockDio.post(
        "$baseURL/candidate-restaurants",
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            statusCode: 201,
            data: {},
            requestOptions:
                RequestOptions(path: "$baseURL/candidate-restaurants"),
          ));

      // Act
      final result = await candidateDataSource.createCandidate(candidRest);

      // Assert
      expect(result,
          "Restaurant registration is successful. We will review the suggested Restaurant");
    });

    test('createCandidate throws ServerException on non-201 status', () async {
      // Arrange
      final candidRest = CandidRest(
          name: 'Test Restaurant',
          description: 'A great place to eat',
          menuImages: [],
          restImages: []);
      final user = LocalUserModel(token: token);

      when(mockAuthLocalSource.getUserCredential()).thenReturn(user);
      when(mockDio.post(
        "$baseURL/candidate-restaurants",
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenAnswer((_) async => Response(
            statusCode: 400,
            data: {'message': 'Bad Request'},
            requestOptions:
                RequestOptions(path: "$baseURL/candidate-restaurants"),
          ));

      // Act & Assert
      expect(
        () async => await candidateDataSource.createCandidate(candidRest),
        throwsA(isA<ServerException>()
            .having((e) => e.errorMessage, 'errorMessage', 'Bad Request')),
      );
    });

    test('createCandidate throws ServerException on DioException', () async {
      // Arrange
      final candidRest = CandidRest(
          name: 'Test Restaurant',
          description: 'A great place to eat',
          menuImages: [],
          restImages: []);
      final user = LocalUserModel(token: token);

      when(mockAuthLocalSource.getUserCredential()).thenReturn(user);
      when(mockDio.post(
        "$baseURL/candidate-restaurants",
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenThrow(DioException(
        response: Response(
            requestOptions:
                RequestOptions(path: "$baseURL/candidate-restaurants"),
            data: {'message': 'Server Error'}),
        requestOptions: RequestOptions(path: "$baseURL/candidate-restaurants"),
        type: DioExceptionType.connectionError, // Simulating a connection error
      ));

      // Act & Assert
      expect(
        () async => await candidateDataSource.createCandidate(candidRest),
        throwsA(isA<ServerException>()
            .having((e) => e.errorMessage, 'errorMessage', 'Server Error')),
      );
    });

    test('createCandidate throws ServerException on other exceptions',
        () async {
      // Arrange
      final candidRest = CandidRest(
          name: 'Test Restaurant',
          description: 'A great place to eat',
          menuImages: [],
          restImages: []);
      final user = LocalUserModel(token: token);

      when(mockAuthLocalSource.getUserCredential()).thenReturn(user);
      when(mockDio.post(
        "$baseURL/candidate-restaurants",
        options: anyNamed('options'),
        data: anyNamed('data'),
      )).thenThrow(Exception());

      // Act & Assert
      expect(
        () async => await candidateDataSource.createCandidate(candidRest),
        throwsA(isA<ServerException>()
            .having((e) => e.errorMessage, 'errorMessage', 'Server Error')),
      );
    });
  });
}
