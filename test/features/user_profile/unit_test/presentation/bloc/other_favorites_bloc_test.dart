import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';
import 'package:rateeat_mobile/src/features/user_profile/presentation/bloc/others_profile/others_favorites_bloc.dart';

import 'other_favorites_bloc_test.mocks.dart';

class MockGetOtherUserFavoritesUseCase extends Mock
    implements GetOtherUserFavoritesUseCase {}

@GenerateMocks([MockGetOtherUserFavoritesUseCase])
void main() {
  late MockGetOtherUserFavoritesUseCase mockGetOtherUserFavoritesUseCase;
  late OthersFavoriteBloc othersFavoriteBloc;

  setUp(() {
    mockGetOtherUserFavoritesUseCase = MockMockGetOtherUserFavoritesUseCase();
    othersFavoriteBloc = OthersFavoriteBloc(
        getOtherUserFavoritesUseCase: mockGetOtherUserFavoritesUseCase);
  });

  group('OthersFavoriteBloc', () {
    test(
        'should emit [OthersFavoritesLoading, OthersFavoritesLoaded] when getting other user favorites is successful',
        () async {
      const userId = '123';
      final favorites = [const UserFavorite()];
      final expectedState = OthersFavoritesLoaded(favorites: favorites);
      when(mockGetOtherUserFavoritesUseCase(userId))
          .thenAnswer((_) async => Right(favorites));

      othersFavoriteBloc.add(const GetOthersFavoritesEvent(userId: userId));

      await expectLater(
        othersFavoriteBloc.stream,
        emitsInOrder([
          OthersFavoritesLoading(),
          expectedState,
        ]),
      );
      verify(mockGetOtherUserFavoritesUseCase(userId)).called(1);
    });

    test(
        'should emit [OthersFavoritesLoading, OthersFavoritesError] when getting other user favorites fails',
        () async {
      const userId = '123';

      final error = ServerFailure();
      final expectedState = OthersFavoritesError(error: error.errorMessage);
      when(mockGetOtherUserFavoritesUseCase(userId))
          .thenAnswer((_) async => Left(error));

      othersFavoriteBloc.add(const GetOthersFavoritesEvent(userId: userId));

      await expectLater(
        othersFavoriteBloc.stream,
        emitsInOrder([
          OthersFavoritesLoading(),
          expectedState,
        ]),
      );
      verify(mockGetOtherUserFavoritesUseCase(userId)).called(1);
    });
  });
}
