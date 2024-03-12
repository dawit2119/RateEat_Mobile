import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_profile/get_others_profile_bloc.dart';
import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';

import 'others_profile_bloc_test.mocks.dart';

class MockGetOtherUserUseCase extends Mock implements GetOtherUserUseCase {}

@GenerateMocks([MockGetOtherUserUseCase])
void main() {
  late MockGetOtherUserUseCase mockGetOtherUserUseCase;
  late GetOthersProfileBloc getOthersProfileBloc;

  setUp(() {
    mockGetOtherUserUseCase = MockMockGetOtherUserUseCase();
    getOthersProfileBloc =
        GetOthersProfileBloc(getOtherUserUseCase: mockGetOtherUserUseCase);
  });

  group('GetOthersProfileBloc', () {
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
    const userId = '123';

    test(
        'should emit [OthersProfileLoading, OthersProfileLoaded] when getting other user profile is successful',
        () async {
      final expectedState = OthersProfileLoaded(user: user);
      when(mockGetOtherUserUseCase(userId))
          .thenAnswer((_) async => Right(user));

      getOthersProfileBloc.add(const GetOthersProfileEvent(userId: userId));

      await expectLater(
        getOthersProfileBloc.stream,
        emitsInOrder([
          OthersProfileLoading(),
          expectedState,
        ]),
      );
      verify(mockGetOtherUserUseCase(userId)).called(1);
    });

    test(
        'should emit [OthersProfileLoading, GetOthersProfileError] when getting other user profile fails',
        () async {
      final error = ServerFailure();
      final expectedState = GetOthersProfileError(error: error.errorMessage);
      when(mockGetOtherUserUseCase(userId))
          .thenAnswer((_) async => Left(error));

      getOthersProfileBloc.add(const GetOthersProfileEvent(userId: userId));

      await expectLater(
        getOthersProfileBloc.stream,
        emitsInOrder([
          OthersProfileLoading(),
          expectedState,
        ]),
      );
      verify(mockGetOtherUserUseCase(userId)).called(1);
    });
  });
}
