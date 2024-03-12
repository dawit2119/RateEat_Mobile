import 'package:dartz/dartz.dart';
import '../../../../../core/core.dart';
import '../../domain.dart';
import '../../repository/others_profile_repository.dart';

class GetOtherUserFavoritesUseCase extends UseCase<List<UserFavorite>, String> {
  final OthersProfileRepository othersProfileRepository;

  GetOtherUserFavoritesUseCase({
    required this.othersProfileRepository,
  });
  @override
  Future<Either<Failure, List<UserFavorite>>> call(String params) async {
    return await othersProfileRepository.getUserFavorites(params);
  }
}
