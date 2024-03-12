import 'package:dartz/dartz.dart';
import 'package:rateeat_mobile/src/core/core.dart';
import 'package:rateeat_mobile/src/features/user_profile/domain/domain.dart';

class UpdateUserPreferenceUseCase
    extends UseCase<void, UpdateUserPreferenceUseCaseParams> {
  final ProfileRepository profileRepository;

  UpdateUserPreferenceUseCase({required this.profileRepository});

  @override
  Future<Either<Failure, dynamic>> call(
      UpdateUserPreferenceUseCaseParams params) {
    return profileRepository.updateUserPreference(
      params.preferredWalkingDistance,
      params.preferredDrivingDistance,
      params.minNumberOfReviews,
    );
  }
}

class UpdateUserPreferenceUseCaseParams {
  final int? preferredWalkingDistance;
  final int? preferredDrivingDistance;
  final int? minNumberOfReviews;

  UpdateUserPreferenceUseCaseParams({
    required this.preferredWalkingDistance,
    required this.preferredDrivingDistance,
    required this.minNumberOfReviews,
  });
}
