import 'package:dio/dio.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/authentication/authentication.dart';

class SendLocationDataSource {
  final Dio dio = Dio();

  Future<void> sendLocation({required double lat, required double long}) async {
    try {
      final user = dpLocator<AuthenticationLocalSource>().getUserCredential();
      var headers = {
        'Content-Type': 'application/json',
        'Accept': 'application/json',
      };
      if (user != null) {
        headers.addEntries([
          MapEntry('Authorization', 'Bearer ${user.token}'),
        ]);
      }
      final response = await dio.get(
        "$baseURL/notifications/location/ping-restaurant?latitude=$lat&longitude=$long",
        options: Options(
          headers: headers,
        ),
      );
      if (response.statusCode == 200) {
        return;
      } else {
        throw Exception('Failed to send locations');
      }
    } catch (e) {
      throw ServerException();
    }
  }
}
