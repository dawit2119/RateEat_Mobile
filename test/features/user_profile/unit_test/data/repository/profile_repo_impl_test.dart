import 'package:dartz/dartz.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/core/error/failure.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/saved_reviews_response_model.dart';

import 'package:rateeat_mobile/src/features/user_profile/user_profile.dart';

import 'profile_repo_impl_test.mocks.dart';

class MockProfileDataProvider extends Mock implements ProfileDataProvider {}

@GenerateMocks([MockProfileDataProvider])
void main() {
  late ProfileRepoImpl profileRepoImpl;
  late MockProfileDataProvider mockProfileDataProvider;

  setUp(() {
    mockProfileDataProvider = MockMockProfileDataProvider();
    profileRepoImpl =
        ProfileRepoImpl(profileDataProvider: mockProfileDataProvider);
  });

  group('editProfile', () {
    test('should return a User when edit is successful', () async {
      final user = UserModel();
      final updateData = <String, dynamic>{};
      when(mockProfileDataProvider.editProfile(
              user: user, updatedFields: updateData))
          .thenAnswer((_) async => user);

      final result =
          await profileRepoImpl.editProfile(user: user, updateData: updateData);

      expect(result, Right(user));
      verify(mockProfileDataProvider.editProfile(
          user: user, updatedFields: updateData));
      verifyNoMoreInteractions(mockProfileDataProvider);
    });

    test('should return a ServerFailure when edit fails', () async {
      final user = UserModel();
      final updateData = <String, dynamic>{};
      final error = ServerFailure();
      when(mockProfileDataProvider.editProfile(
              user: user, updatedFields: updateData))
          .thenThrow(error);

      final result =
          await profileRepoImpl.editProfile(user: user, updateData: updateData);

      expect(result, Left(ServerFailure(errorMessage: error.errorMessage)));
      verify(mockProfileDataProvider.editProfile(
          user: user, updatedFields: updateData));
      verifyNoMoreInteractions(mockProfileDataProvider);
    });
  });

  group('getUserFavorites', () {
    test('should return a list of favorites when retrieval is successful',
        () async {
      const userId = '123';
      final List<UserFavoriteModel> favorites = [];
      when(mockProfileDataProvider.getUserFavorites(userId))
          .thenAnswer((_) async => favorites);

      final result = await profileRepoImpl.getUserFavorites(userId);

      expect(result, Right(favorites));
      verify(mockProfileDataProvider.getUserFavorites(userId));
      verifyNoMoreInteractions(mockProfileDataProvider);
    });

    test('should return a ServerFailure when favorites retrieval fails',
        () async {
      const userId = '123';
      final error = ServerFailure();
      when(mockProfileDataProvider.getUserFavorites(userId)).thenThrow(error);

      final result = await profileRepoImpl.getUserFavorites(userId);

      expect(result, Left(ServerFailure(errorMessage: error.errorMessage)));
      verify(mockProfileDataProvider.getUserFavorites(userId));
      verifyNoMoreInteractions(mockProfileDataProvider);
    });
  });

  group('getUserReviews', () {
    test('should return a list of reviews when retrieval is successful',
        () async {
      const userId = '123';
      final List<UserReviewModel> reviews = [];
      when(mockProfileDataProvider.getUserReviews(
              userId: userId, page: 1, limit: 10))
          .thenAnswer((_) async => reviews);

      final result = await profileRepoImpl.getUserReviews(
          userId: userId, page: 1, limit: 10);

      expect(result, Right(reviews));
      verify(mockProfileDataProvider.getUserReviews(
          userId: userId, page: 1, limit: 10));
      verifyNoMoreInteractions(mockProfileDataProvider);
    });

    test('should return a ServerFailure when reviews retrieval fails',
        () async {
      const userId = '123';
      final error = ServerFailure();
      when(mockProfileDataProvider.getUserReviews(
              userId: userId, page: 1, limit: 10))
          .thenThrow(error);

      final result = await profileRepoImpl.getUserReviews(
          userId: userId, page: 1, limit: 10);

      expect(result, Left(ServerFailure(errorMessage: error.errorMessage)));
      verify(mockProfileDataProvider.getUserReviews(
          userId: userId, page: 1, limit: 10));
      verifyNoMoreInteractions(mockProfileDataProvider);
    });

    test('should return a list of saved reviews when retrieval is successful',
        () async {
      const page = 1;
      const limit = 10;
      final List<SavedReviewsResponseModel> savedReviews = [];
      when(mockProfileDataProvider.getSavedReviews(page: page, limit: limit))
          .thenAnswer((_) async => savedReviews);

      final result =
          await profileRepoImpl.getSavedReviews(page: page, limit: limit);

      expect(result, Right(savedReviews));
      verify(mockProfileDataProvider.getSavedReviews(page: page, limit: limit));
      verifyNoMoreInteractions(mockProfileDataProvider);
    });

    test('should return a ServerFailure when saved reviews retrieval fails',
        () async {
      const page = 1;
      const limit = 10;
      final error = ServerFailure();
      when(mockProfileDataProvider.getSavedReviews(page: page, limit: limit))
          .thenThrow(error);

      final result =
          await profileRepoImpl.getSavedReviews(page: page, limit: limit);

      expect(result, Left(ServerFailure(errorMessage: error.errorMessage)));
      verify(mockProfileDataProvider.getSavedReviews(page: page, limit: limit));
      verifyNoMoreInteractions(mockProfileDataProvider);
    });

    test('should return true when username is available', () async {
      const username = 'john_doe';
      const bool isAvailable = true;
      when(mockProfileDataProvider.checkUsernameAvailability(
              userName: username))
          .thenAnswer((_) async => isAvailable);

      final result =
          await profileRepoImpl.checkUsernameAvailability(userName: username);

      expect(result, const Right(isAvailable));
      verify(mockProfileDataProvider.checkUsernameAvailability(
          userName: username));
      verifyNoMoreInteractions(mockProfileDataProvider);
    });

    test('should return a ServerFailure when username availability check fails',
        () async {
      const username = 'john_doe';
      final error = ServerFailure();
      when(mockProfileDataProvider.checkUsernameAvailability(
              userName: username))
          .thenThrow(error);

      final result =
          await profileRepoImpl.checkUsernameAvailability(userName: username);

      expect(result, Left(ServerFailure(errorMessage: error.errorMessage)));
      verify(mockProfileDataProvider.checkUsernameAvailability(
          userName: username));
      verifyNoMoreInteractions(mockProfileDataProvider);
    });
  });
}
