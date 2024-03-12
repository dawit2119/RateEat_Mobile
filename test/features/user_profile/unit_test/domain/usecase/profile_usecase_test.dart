import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';

import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/get_saved_reviews_use_case.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/saved_reviews_response_model.dart';

import 'profile_usecase_test.mocks.dart';

class MockProfileRepository extends Mock implements ProfileRepository {}

@GenerateMocks([MockProfileRepository])
void main() {
  late EditProfileUseCase editProfileUseCase;
  late MockProfileRepository mockProfileRepository;
  late GetSavedReviewsUseCase getSavedReviewsUseCase;
  late GetUserFavoritesUseCase getUserFavoritesUseCase;
  late GetUserReviewsUseCase getUserReviewsUseCase;
  late GetUserUseCase getUserUseCase;

  setUp(() {
    mockProfileRepository = MockMockProfileRepository();
    editProfileUseCase =
        EditProfileUseCase(profileRepository: mockProfileRepository);
    getSavedReviewsUseCase =
        GetSavedReviewsUseCase(profileRepository: mockProfileRepository);
    getUserFavoritesUseCase =
        GetUserFavoritesUseCase(profileRepository: mockProfileRepository);
    getUserReviewsUseCase =
        GetUserReviewsUseCase(profileRepository: mockProfileRepository);
    getUserUseCase = GetUserUseCase(profileRepository: mockProfileRepository);
  });

  test('should edit profile successfully', () async {
    final user = User(
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
        refreshToken: ''); // Provide a user instance
    final updateData = {'name': 'John Smith'};
    final params = EditProfileUseCaseParams(user: user, updateData: updateData);
    final updatedUser = User(
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

    when(mockProfileRepository.editProfile(user: user, updateData: updateData))
        .thenAnswer((_) async => Right(updatedUser));

    final result = await editProfileUseCase(params);

    expect(result, Right(updatedUser));
    verify(
        mockProfileRepository.editProfile(user: user, updateData: updateData));
    verifyNoMoreInteractions(mockProfileRepository);
  });

  test('should return a failure when profile editing fails', () async {
    final user = User(
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
    final failure = ServerFailure();
    when(mockProfileRepository.editProfile(user: user, updateData: updateData))
        .thenAnswer((_) async => Left(failure));

    final result = await editProfileUseCase(params);

    expect(result, Left(failure));
    verify(
        mockProfileRepository.editProfile(user: user, updateData: updateData));
    verifyNoMoreInteractions(mockProfileRepository);
  });

  test('should return a list of saved reviews successfully', () async {
    const page = 1;
    const limit = 10;
    const params = GetSavedReviewsUseCaseParams(page: page, limit: limit);
    final List<SavedReviewsResponseModel> savedReviews = [];
    when(mockProfileRepository.getSavedReviews(page: page, limit: limit))
        .thenAnswer((_) async => Right(savedReviews));

    final result = await getSavedReviewsUseCase(params);

    expect(result, Right(savedReviews));
    verify(mockProfileRepository.getSavedReviews(page: page, limit: limit));
    verifyNoMoreInteractions(mockProfileRepository);
  });

  test('should return a failure when retrieving saved reviews fails', () async {
    const page = 1;
    const limit = 10;
    const params = GetSavedReviewsUseCaseParams(page: page, limit: limit);
    final failure = ServerFailure(errorMessage: 'Error message');
    when(mockProfileRepository.getSavedReviews(page: page, limit: limit))
        .thenAnswer((_) async => Left(failure));

    final result = await getSavedReviewsUseCase(params);

    expect(result, Left(failure));
    verify(mockProfileRepository.getSavedReviews(page: page, limit: limit));
    verifyNoMoreInteractions(mockProfileRepository);
  });

  test('should return a list of user favorites successfully', () async {
    const userId = '123';
    final List<UserFavorite> userFavorites = [];
    when(mockProfileRepository.getUserFavorites(userId))
        .thenAnswer((_) async => Right(userFavorites));

    final result = await getUserFavoritesUseCase(userId);

    expect(result, Right(userFavorites));
    verify(mockProfileRepository.getUserFavorites(userId));
    verifyNoMoreInteractions(mockProfileRepository);
  });

  test('should return a failure when retrieving user favorites fails',
      () async {
    const userId = '123';
    final failure = ServerFailure(errorMessage: 'Error message');
    when(mockProfileRepository.getUserFavorites(userId))
        .thenAnswer((_) async => Left(failure));

    final result = await getUserFavoritesUseCase(userId);

    expect(result, Left(failure));
    verify(mockProfileRepository.getUserFavorites(userId));
    verifyNoMoreInteractions(mockProfileRepository);
  });

  test('should return a list of user reviews successfully', () async {
    const userId = '123';
    const page = 1;
    const limit = 4;
    const params =
        GetUserReviewsUseCaseParams(userId: userId, page: page, limit: limit);
    final List<UserReview> userReviews = [];
    when(mockProfileRepository.getUserReviews(
            userId: userId, page: page, limit: limit))
        .thenAnswer((_) async => Right(userReviews));

    final result = await getUserReviewsUseCase(params);

    expect(result, Right(userReviews));
    verify(mockProfileRepository.getUserReviews(
        userId: userId, page: page, limit: limit));
    verifyNoMoreInteractions(mockProfileRepository);
  });

  test('should return a failure when retrieving user reviews fails', () async {
    const userId = '123';
    const page = 1;
    const limit = 4;
    const params =
        GetUserReviewsUseCaseParams(userId: userId, page: page, limit: limit);
    final failure = ServerFailure(
        errorMessage: 'Error message'); // Provide a failure instance
    when(mockProfileRepository.getUserReviews(
            userId: userId, page: page, limit: limit))
        .thenAnswer((_) async => Left(failure));

    final result = await getUserReviewsUseCase(params);

    expect(result, Left(failure));
    verify(mockProfileRepository.getUserReviews(
        userId: userId, page: page, limit: limit));
    verifyNoMoreInteractions(mockProfileRepository);
  });

  test('should return a user successfully', () async {
    const userId = '123';
    final user = User(
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
    when(mockProfileRepository.getUser(userId))
        .thenAnswer((_) async => Right(user));

    final result = await getUserUseCase(userId);

    expect(result, Right(user));
    verify(mockProfileRepository.getUser(userId));
    verifyNoMoreInteractions(mockProfileRepository);
  });

  test('should return a failure when retrieving user fails', () async {
    const userId = '123';
    final failure = ServerFailure(errorMessage: 'Error message');
    when(mockProfileRepository.getUser(userId))
        .thenAnswer((_) async => Left(failure));

    final result = await getUserUseCase(userId);

    expect(result, Left(failure));
    verify(mockProfileRepository.getUser(userId));
    verifyNoMoreInteractions(mockProfileRepository);
  });
}
