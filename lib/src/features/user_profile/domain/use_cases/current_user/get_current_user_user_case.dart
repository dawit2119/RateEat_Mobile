import 'package:dartz/dartz.dart';

import '../../../../../core/core.dart';
import '../../domain.dart';

class GetCurrentUserUseCase extends UseCase<User, NoParams> {
  final ProfileRepository profileRepository;

  GetCurrentUserUseCase({
    required this.profileRepository,
  });

  @override
  Future<Either<Failure, User>> call(NoParams params) async {
    return await profileRepository.getCurrentUser();
  }
}
