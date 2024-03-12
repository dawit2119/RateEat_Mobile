import 'package:dartz/dartz.dart';

import '../../../../../core/core.dart';
import '../../domain.dart';

class GetUserUseCase extends UseCase<User, String> {
  final ProfileRepository profileRepository;

  GetUserUseCase({
    required this.profileRepository,
  });

  @override
  Future<Either<Failure, User>> call(String params) async {
    return await profileRepository.getUser(params);
  }
}
