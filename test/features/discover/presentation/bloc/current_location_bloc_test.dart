import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/features.dart';

import 'current_location_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<GetLocationUseCase>(),
])
void main() {
  late UserLocationBloc userLocationBloc;
  late MockGetLocationUseCase mockGetLocationUseCase;
  final noParams = NoParams();
  const testResponse = LocationModel(
    latitude: 1.0,
    longitude: 1.0,
  );

  setUp(() {
    mockGetLocationUseCase = MockGetLocationUseCase();
    userLocationBloc = UserLocationBloc(
      getLocationUseCase: mockGetLocationUseCase,
    );
    when(mockGetLocationUseCase.call(noParams))
        .thenAnswer((_) async => const Right(testResponse));
  });

  group('get user location', () {
    blocTest<UserLocationBloc, UserLocationState>(
      'should emit [UserLocationLoading, UserLocationLoaded] when GetUserLocation is called.',
      build: () {
        when(mockGetLocationUseCase.call(noParams))
            .thenAnswer((_) async => const Right(testResponse));
        return userLocationBloc;
      },
      act: (bloc) => bloc.add(const GetUserLocation()),
      expect: () => <UserLocationState>[
        const UserLocationLoading(),
        const UserLocationLoaded(location: testResponse),
      ],
    );

    blocTest<UserLocationBloc, UserLocationState>(
      'should emit [UserLocationLoading, UserLocationError] when GetUserLocation fails.',
      build: () {
        when(mockGetLocationUseCase.call(noParams)).thenAnswer(
            (_) async => Left(NetworkFailure(errorMessage: 'Network error')));
        return userLocationBloc;
      },
      act: (bloc) => bloc.add(const GetUserLocation()),
      expect: () => <UserLocationState>[
        const UserLocationLoading(),
        const UserLocationError(message: 'Network error'),
      ],
    );
  });

  group('change user location', () {
    blocTest<UserLocationBloc, UserLocationState>(
      'should emit [UserLocationLoaded] when ChangeUserLocation is called.',
      build: () {
        return UserLocationBloc(getLocationUseCase: mockGetLocationUseCase);
      },
      act: (bloc) =>
          bloc.add(const ChangeUserLocation(newLocation: testResponse)),
      expect: () => <UserLocationState>[
        //loading state added because it is emitted when the bloc is initialized
        const UserLocationLoading(),
        const UserLocationLoaded(location: testResponse),
      ],
    );
  });
}
