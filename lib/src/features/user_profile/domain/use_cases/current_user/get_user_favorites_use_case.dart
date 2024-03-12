import 'package:dartz/dartz.dart';
import '../../../../../core/core.dart';

import '../../domain.dart';

class GetUserFavoritesUseCase extends UseCase<List<UserFavorite>, String> {
  final ProfileRepository profileRepository;

  GetUserFavoritesUseCase({
    required this.profileRepository,
  });
  @override
  Future<Either<Failure, List<UserFavorite>>> call(String params) async {
    return await profileRepository.getUserFavorites(
      params,
    );
  }
}
