import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';

import 'edit_profile_bloc_test.mocks.dart';

class MockEditProfileUseCase extends Mock implements EditProfileUseCase {}

@GenerateMocks([MockEditProfileUseCase])
void main() {
  late MockEditProfileUseCase mockEditProfileUseCase;
  late EditProfileBloc editProfileBloc;

  setUp(() {
    mockEditProfileUseCase = MockMockEditProfileUseCase();
    editProfileBloc =
        EditProfileBloc(editProfileUseCase: mockEditProfileUseCase);
  });

  group('EditProfileBloc', () {
    final user = UserModel(
        id: '1',
        telegramId: '',
        facebookId: '',
        userName: '',
        firstName: '',
        lastName: '',
        dateOfBirth: '',
        email: '',
        gender: '',
        roleId: '',
        phoneNumber: '',
        image: '',
        createdAt: null,
        updatedAt: null,
        token: '',
        incentive: null,
        fcmToken: '',
        verified: null,
        levelInfo: UserLevel(level: 1, levelName: 'Beginner'),
        userStat: UserStat(
          favoritesCount: 0,
          reviewsCount: 0,
        ),
        isFollowed: true,
        refreshToken: '');
    final updateData = {'name': 'John Smith'};
    final params = EditProfileUseCaseParams(user: user, updateData: updateData);
    test(
        'should emit [EditProfileLoading, EditProfileLoaded] when edit profile is successful',
        () async {
      when(mockEditProfileUseCase(params)).thenAnswer((_) async => Right(user));

      editProfileBloc
          .add(SubmitEditProfileEvent(user: user, updateData: updateData));

      await expectLater(
        editProfileBloc.stream,
        emitsInOrder([EditProfileLoading(), EditProfileLoaded(user: user)]),
      );
      verify(mockEditProfileUseCase(
              EditProfileUseCaseParams(user: user, updateData: updateData)))
          .called(1);
    });

    test(
        'should emit [EditProfileLoading, EditProfileError] when edit profile fails',
        () async {
      final error = ServerFailure(errorMessage: 'Error message');
      when(mockEditProfileUseCase(params)).thenAnswer((_) async => Left(error));

      editProfileBloc
          .add(SubmitEditProfileEvent(user: user, updateData: updateData));

      await expectLater(
        editProfileBloc.stream,
        emitsInOrder([
          EditProfileLoading(),
          EditProfileError(error: error.errorMessage)
        ]),
      );
      verify(mockEditProfileUseCase(
              EditProfileUseCaseParams(user: user, updateData: updateData)))
          .called(1);
    });
  });
}
