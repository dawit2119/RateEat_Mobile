import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'get_location_repository_impl_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<LocationDataProvider>(),
])
void main() {
  late DiscoverRepoImpl discoverRepoImpl;
  late MockLocationDataProvider mockLocationDataProvider;

  setUp(() {
    mockLocationDataProvider = MockLocationDataProvider();
    discoverRepoImpl = DiscoverRepoImpl(
      locationDataProvider: mockLocationDataProvider,
    );
  });

  const location = LocationModel(
    latitude: 1.0,
    longitude: 1.0,
  );
  group('get location', () {
    test('should get the location', () async {
      // arrange
      when(
        mockLocationDataProvider.determinePosition(),
      ).thenAnswer(
        (_) async => location,
      );

      // act
      final result = await discoverRepoImpl.getLocation();
      // assert
      expect(result, equals(const Right(location)));
    });

    test('should return a failure when the network fails', () async {
      // arrange
      when(
        mockLocationDataProvider.determinePosition(),
      ).thenThrow(NetworkException());

      // act
      final result = await discoverRepoImpl.getLocation();
      // assert
      expect(
          result, equals(Left(NetworkFailure(errorMessage: 'Network error'))));
    });
  });
}
