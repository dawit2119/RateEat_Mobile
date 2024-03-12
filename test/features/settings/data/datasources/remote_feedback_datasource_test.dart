import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:dio/dio.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/hive/local_user_model.dart';
import 'package:rateeat_mobile/src/features/authentication/data/datasources/local_authentication_datasource.dart';
import 'package:rateeat_mobile/src/features/settings/data/datasources/remote_feedback_datasource.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';

import 'remote_feedback_datasource_test.mocks.dart';

@GenerateNiceMocks([MockSpec<Dio>(), MockSpec<AuthenticationLocalSource>()])
void main() {
  late MockDio dio;
  late FeedbackDataSource feedbackDataSource;
  late MockAuthenticationLocalSource mockauthenticationLocalSource;
  late String baseUrl;

  setUp(() async {
    await dotenv.load(fileName: '.env');
    baseUrl = dotenv.get('BASE_URL');
    dio = MockDio();
    feedbackDataSource = FeedbackDataSource(dio: dio);
    mockauthenticationLocalSource = MockAuthenticationLocalSource();
    dpLocator.registerLazySingleton<AuthenticationLocalSource>(
        () => mockauthenticationLocalSource);
  });

  group('test FeedbackDataSource', () {
    final comment = 'comment';
    final token = LocalUserModel(token: 'token');
    final data = {'text': comment};
    test('giveFeedBack should return string on success', () async {
      when(mockauthenticationLocalSource.getUserCredential()).thenReturn(token);

      when(dio.post('$baseUrl/feedbacks',
              options: anyNamed('options'), data: anyNamed('data')))
          .thenAnswer((_) async => Response(
              requestOptions: RequestOptions(path: ''),
              statusCode: 200,
              data: {'data': 'success'}));

      final result = await feedbackDataSource.giveFeedback(comment);

      expect(result, isA<String>());
    });
  });
}
