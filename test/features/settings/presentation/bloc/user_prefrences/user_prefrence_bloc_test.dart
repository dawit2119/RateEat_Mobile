import 'package:bloc_test/bloc_test.dart';
import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/error/error.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/user_preference/user_preference_bloc.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/user_preference/user_preference_event.dart';
import 'package:rateeat_mobile/src/features/settings/presentation/bloc/user_preference/user_preference_state.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/get_user_preference_use_case.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/update_user_preference_use_case.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/entity/user_preference.dart';

import 'user_prefrence_bloc_test.mocks.dart';

@GenerateNiceMocks([
  MockSpec<UpdateUserPreferenceUseCase>(),
  MockSpec<GetUserPreferenceUseCase>(),
])
void main() {
  late MockUpdateUserPreferenceUseCase mockUpdateUserPreferenceUseCase;
  late MockGetUserPreferenceUseCase mockGetUserPreferenceUseCase;
  late UserPreferenceBloc userPreferenceBloc;

  setUp(() async {
    mockUpdateUserPreferenceUseCase = MockUpdateUserPreferenceUseCase();
    mockGetUserPreferenceUseCase = MockGetUserPreferenceUseCase();
    userPreferenceBloc = UserPreferenceBloc(
        getUserPreferenceUseCase: mockGetUserPreferenceUseCase,
        updateUserPreferenceUseCase: mockUpdateUserPreferenceUseCase);
  });

  group('test UserPrefrenceBloc on UpdateUserPrefrence', () {
    test('intial state of UserPrefrenceBloc returns UserPrefrenceInitial',
        () async {
      expect(userPreferenceBloc.state, isA<UserPreferenceInitial>());
    });

    blocTest(
        'emits [UserPreferenceUpdateLoading,UserPreferenceUpdateSuccess] on UpdateUserPreference event',
        build: () {
          when(mockUpdateUserPreferenceUseCase(any))
              .thenAnswer((_) async => Right(true));
          return userPreferenceBloc;
        },
        act: (bloc) => bloc.add(UpdateUserPreference(
              preferredDrivingDistance: 10,
              preferredWalkingDistance: 10,
              minNumberOfReviews: 2,
            )),
        expect: () => [
              isA<UserPreferenceUpdateLoading>(),
              isA<UserPreferenceUpdateSuccess>(),
            ]);

    blocTest<UserPreferenceBloc, UserPreferenceState>(
      'emits [UserPreferenceUpdateLoading, UserPreferenceUpdateFailed] on UpdateUserPreference event',
      build: () {
        when(mockUpdateUserPreferenceUseCase(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return userPreferenceBloc;
      },
      act: (bloc) => bloc.add(UpdateUserPreference(
        preferredDrivingDistance: 10,
        preferredWalkingDistance: 10,
        minNumberOfReviews: 2,
      )),
      expect: () => [
        isA<UserPreferenceUpdateLoading>(),
        isA<UserPreferenceUpdateFailed>(),
      ],
    );
  });

  group('test UserPrefrenceBloc on GetPreviousUserPrefrence', () {
    blocTest(
        'emits [UserPreferenceInitial, PreviousPreferencesFetched] on GetPreviousPreference',
        build: () {
          when(mockGetUserPreferenceUseCase(any)).thenAnswer((_) async => Right(
              UserPreference(
                  drivingDistance: 10,
                  walkingDistance: 10,
                  minNumberOfReviews: 2)));
          return userPreferenceBloc;
        },
        act: (bloc) => userPreferenceBloc.add(GetPreviousPreference()),
        expect: () => [
              isA<UserPreferenceInitial>(),
              isA<PreviousPreferencesFetched>(),
            ]);

    blocTest(
      'emits [UserPreferenceInitial, PreviousPreferencesFetchFailed] on GetPreviousPreference',
      build: () {
        when(mockGetUserPreferenceUseCase(any))
            .thenAnswer((_) async => Left(ServerFailure()));
        return userPreferenceBloc;
      },
      act: (bloc) => userPreferenceBloc.add(GetPreviousPreference()),
      expect: () => [
        isA<UserPreferenceInitial>(),
        isA<PreviousPreferencesFetchFailed>(),
      ],
    );
  });
}
