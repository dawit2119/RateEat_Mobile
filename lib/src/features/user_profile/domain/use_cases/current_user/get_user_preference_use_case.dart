import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class GetUserPreferenceUseCase extends UseCase<UserPreference, NoParams> {
  final ProfileRepository profileRepository;

  GetUserPreferenceUseCase({required this.profileRepository});
  @override
  Future<Either<Failure, UserPreference>> call(NoParams params) {
    return profileRepository.getUserPreference();
  }
}
