import 'package:flutter_test/flutter_test.dart';
import 'package:get_it/get_it.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/data.dart';
import 'package:rateeat_mobile/src/features/user_profile/data/models/saved_reviews_response_model.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/use_cases/current_user/get_saved_reviews_use_case.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/saved_reviews/saved_reviews_bloc.dart';

import 'saved_reviews_bloc_test.mocks.dart';

@GenerateNiceMocks(
    [MockSpec<GetSavedReviewsUseCase>(), MockSpec<LocalProfileDataProvider>()])
void main() {
  late MockGetSavedReviewsUseCase mockGetSavedReviewsUseCase;
  late SavedReviewsBloc savedReviewsBloc;
  late MockLocalProfileDataProvider mockLocalProfileDataProvider;

  setUp(() {
    mockGetSavedReviewsUseCase = MockGetSavedReviewsUseCase();
    mockLocalProfileDataProvider = MockLocalProfileDataProvider();
    savedReviewsBloc =
        SavedReviewsBloc(getSavedReviewsUseCase: mockGetSavedReviewsUseCase);
    final dpLocator = GetIt.instance;
    dpLocator.registerLazySingleton<LocalProfileDataProvider>(
        () => mockLocalProfileDataProvider);
  });

  tearDown(() async {
    dpLocator.reset();
  });

  group('SavedReviewsBloc', () {
    test('initial state should be SavedReviewsInitial', () {
      expect(savedReviewsBloc.state, SavedReviewsInitial());
    });
    test(
        'should emit [SavedReviewLoading, SavedReviewLoaded] when getting saved reviews is successful',
        () async {
      const page = 1;
      const limit = 10;
      final savedReviews = [const SavedReviewsResponseModel()];
      final expectedState = SavedReviewLoaded(
          savedReviews: savedReviews, isLocalData: false, page: 1);
      when(mockLocalProfileDataProvider.getSavedReviews()).thenReturn(null);
      when(mockGetSavedReviewsUseCase(
              const GetSavedReviewsUseCaseParams(page: page, limit: limit)))
          .thenAnswer((_) async => Right(savedReviews));

      savedReviewsBloc.add(GetSavedReviewsEvent(page: page, limit: limit));

      await expectLater(
        savedReviewsBloc.stream,
        emitsInOrder([
          SavedReviewLoading(),
          expectedState,
        ]),
      );
      verify(mockGetSavedReviewsUseCase(
              const GetSavedReviewsUseCaseParams(page: page, limit: limit)))
          .called(1);
    });

    test(
        'should emit [SavedReviewLoading, SavedReviewError] when getting saved reviews fails',
        () async {
      const page = 1;
      const limit = 10;

      final error = ServerFailure(errorMessage: 'Failed to load saved reviews');
      final expectedState =
          SavedReviewError(error: 'Failed to load saved reviews');

      when(mockLocalProfileDataProvider.getSavedReviews()).thenReturn(null);
      when(mockGetSavedReviewsUseCase(
              const GetSavedReviewsUseCaseParams(page: page, limit: limit)))
          .thenAnswer((_) async => Left(error));

      savedReviewsBloc.add(GetSavedReviewsEvent(page: page, limit: limit));

      await expectLater(
        savedReviewsBloc.stream,
        emitsInOrder([
          SavedReviewLoading(),
          expectedState,
        ]),
      );
      verify(mockGetSavedReviewsUseCase(
              const GetSavedReviewsUseCaseParams(page: page, limit: limit)))
          .called(1);
    });
  });
}
