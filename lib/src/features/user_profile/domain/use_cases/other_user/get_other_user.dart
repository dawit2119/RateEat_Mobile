import 'package:dartz/dartz.dart';
import '../../../../../core/core.dart';
import '../../domain.dart';
import '../../repository/others_profile_repository.dart';

class GetOtherUserUseCase extends UseCase<User, String> {
  final OthersProfileRepository othersProfileRepository;

  GetOtherUserUseCase({
    required this.othersProfileRepository,
  });
  @override
  Future<Either<Failure, User>> call(String params) async {
    return await othersProfileRepository.getUser(params);
  }
}
